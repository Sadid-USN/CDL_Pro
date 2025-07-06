import 'dart:async';
import 'dart:convert';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CDLTestsBloc extends Bloc<AbstractCDLTestsEvent, AbstractCDLTestsState> {
  // ───────────────────────────────── DEPENDENCIES ────────────────────────────
  final SharedPreferences _prefs;
  // final AbstractUserRepo _userRepo;
  final FirebaseFirestore _firestore;

  // ───────────────────────────────── INTERNAL STATE ──────────────────────────

  String? _uid; // <—— Получаем из SetUserUidEvent
  String? get uid => _uid;
  List<Question> _quizQuestions = [];
  Map<String, String> _userAnswers = {};
  int _currentQuestionIndex = 0;
  bool _quizCompleted = false;
  String _selectedLanguage = 'en';
  String? _currentQuizId;
  String? _currentSubcategory;
  bool _ignoreProgressLoadOnce = false;

  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  final StreamController<Duration> _timerController =
      StreamController<Duration>.broadcast();

  // ───────────────────────────────── PUBLIC API ──────────────────────────────
  int get currentPage => _currentQuestionIndex;
  Stream<Duration> get timerStream => _timerController.stream;

  // ───────────────────────────────── CONSTRUCTOR ─────────────────────────────
  CDLTestsBloc(this._prefs, this._firestore) : super(CDLTestsInitial()) {
    // Quiz navigation
    on<LoadQuizEvent>(_onLoadQuiz);
    on<AnswerQuestionEvent>(_onAnswerQuestion);
    on<NextQuestionsEvent>(_onNextQuestions);
    on<PreviousQuestionsEvent>(_onPreviousQuestions);

    // Progress
    on<SaveQuizProgressEvent>(_onSaveQuizProgress);
    on<LoadQuizProgressEvent>(_onLoadQuizProgress);
    on<ResetQuizEvent>(_onResetQuiz);

    // Timer
    on<StartTimerEvent>(_onStartTimer);
    on<StopTimerEvent>(_onStopTimer);

    // Auth
    on<SetUserUidEvent>(_onSetUid);
  }

  // ──────────────────────────────── AUTH HANDLER ─────────────────────────────
  void _onSetUid(SetUserUidEvent event, Emitter<AbstractCDLTestsState> emit) {
    _uid = event.uid;
    // При смене пользователя сбрасываем состояние
    _currentQuestionIndex = 0;
    _userAnswers = {};
    _quizCompleted = false;
    _currentSubcategory = null;
    _currentQuizId = null;
    _emitLoaded(emit);
  }

  // ──────────────────────────────── TIMER CONTROL ────────────────────────────
  void _onStartTimer(
    StartTimerEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedTime += const Duration(seconds: 1);
      _timerController.add(_elapsedTime);
    });
  }

  void _onStopTimer(StopTimerEvent event, Emitter<AbstractCDLTestsState> emit) {
    _timer?.cancel();
    _timer = null;
  }

  // ──────────────────────────────── QUIZ RESULTS ─────────────────────────────
  Map<String, dynamic> calculateResults() {
    final totalQuestions = _quizQuestions.length;
    final correctAnswers =
        _quizQuestions
            .where((q) => _userAnswers[q.question] == q.correctOption)
            .length;
    final wrongAnswers = totalQuestions - correctAnswers;
    final percentage =
        totalQuestions == 0 ? 0.0 : (correctAnswers / totalQuestions) * 100;

    return {
      'total': totalQuestions,
      'correct': correctAnswers,
      'wrong': wrongAnswers,
      'percentage': percentage,
      'passed': percentage >= 90,
    };
  }

  // ──────────────────────────────── QUIZ NAVIGATION ──────────────────────────
  void _onPreviousQuestions(
    PreviousQuestionsEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) {
    if (_currentQuestionIndex > 0) _currentQuestionIndex--;
    _emitLoaded(emit);
  }

  void _onNextQuestions(
    NextQuestionsEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) {
    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      _currentQuestionIndex++;
    } else {
      _quizCompleted = true;
      _clearLocalProgress();
    }
    _emitLoaded(emit);
  }

  void _onAnswerQuestion(
    AnswerQuestionEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) {
    _userAnswers = Map<String, String>.from(_userAnswers)
      ..[event.questionId] = event.selectedOption;
    _emitLoaded(emit);
  }

  // ──────────────────────────────── QUIZ LOADING ─────────────────────────────
 void _onLoadQuiz(
  LoadQuizEvent event,
  Emitter<AbstractCDLTestsState> emit,
) async {
  if (event.questions.isEmpty) return;

  // 1. Установить подкатегорию и сгенерировать quizId ДО загрузки
  _currentSubcategory = event.subcategory;
  final quizId = _generateQuizId(event.questions, event.subcategory);
  _currentQuizId = quizId;

   // 2. Эмитим загрузочное состояние, чтобы скрыть старый UI
  emit(QuizProgressLoading());
  _currentQuestionIndex = 0;
  _userAnswers = {};
  _quizCompleted = false;
  _selectedLanguage = 'en'; // если не загрузится, будет по умолчанию

  // 3. Сброс таймера
  _resetTimer();

  // 4. Загрузка прогресса (если доступен)
  if (!_ignoreProgressLoadOnce) {
    await _loadProgress(quizId, event.subcategory);
  } else {
    _ignoreProgressLoadOnce = false;
  }

  // 5. Установка вопросов
  _quizQuestions = event.questions;

  // 6. Защита от выхода за пределы
  if (_currentQuestionIndex >= _quizQuestions.length) {
    _currentQuestionIndex = 0;
  }

  // 7. Эмитим состояние
  _emitLoaded(emit);
}

  void _onResetQuiz(ResetQuizEvent event, Emitter<AbstractCDLTestsState> emit) {
    _currentQuestionIndex = 0;
    _userAnswers = {};
    _quizCompleted = true;
    _elapsedTime = Duration.zero;
    _timerController.add(_elapsedTime);
    _currentSubcategory = null;
    _currentQuizId = null;

    _resetTimer();
    _clearLocalProgress();
    _ignoreProgressLoadOnce = true;

    _emitLoaded(emit);
  }

  // ──────────────────────────────── SAVE/LOAD LOCAL ──────────────────────────
  Future<void> _saveProgressToPrefs() async {
    if (_uid == null || _currentQuizId == null || _currentSubcategory == null)
      return;

    final baseKey = '${_uid!}_${_currentSubcategory!}_${_currentQuizId!}';

    await _prefs.setInt('${baseKey}_currentPage', _currentQuestionIndex);
    await _prefs.setString('${baseKey}_userAnswers', jsonEncode(_userAnswers));
    await _prefs.setString('${baseKey}_language', _selectedLanguage);
    await _prefs.setInt('${baseKey}_elapsedTime', _elapsedTime.inSeconds);
  }

  Future<bool> _loadProgressFromPrefs(String quizId, String subcategory) async {
    if (_uid == null) return false;
    debugPrint(
      '📦 Loading progress for: subcategory=$subcategory, quizId=$quizId',
    );

    final baseKey = '${_uid!}_${subcategory}_$quizId';
    if (!_prefs.containsKey('${baseKey}_currentPage')) return false;

    _currentQuestionIndex = _prefs.getInt('${baseKey}_currentPage') ?? 0;
    final answersString = _prefs.getString('${baseKey}_userAnswers');
    _userAnswers =
        answersString != null
            ? Map<String, String>.from(jsonDecode(answersString))
            : {};
    _selectedLanguage = _prefs.getString('${baseKey}_language') ?? 'en';
    _elapsedTime = Duration(
      seconds: _prefs.getInt('${baseKey}_elapsedTime') ?? 0,
    );
    _timerController.add(_elapsedTime);
    return true;
  }

  void _clearLocalProgress() {
    if (_uid == null || _currentQuizId == null) return;
    final baseKey = '${_uid!}_${_currentSubcategory!}_${_currentQuizId!}';
    _prefs.remove('${baseKey}_currentPage');
    _prefs.remove('${baseKey}_userAnswers');
    _prefs.remove('${baseKey}_language');
    _prefs.remove('${baseKey}_elapsedTime');
  }

  // ───────────────────────────────── SAVE REMOTE ─────────────────────────────
  void _onSaveQuizProgress(
    SaveQuizProgressEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) async {
    debugPrint(
      'Saving progress for: subcategory=$_currentSubcategory, quizId=$_currentQuizId, currentPage=$_currentQuestionIndex',
    );

    await _saveProgressToPrefs();

    if (_uid == null || _currentQuizId == null) return;

    final settingsBloc = GetIt.I<SettingsBloc>();
    final langCode = settingsBloc.currentLangCode;
    final collectionName = _getCollectionNameByLanguage(langCode);

    final data = {
      'quizId': _currentQuizId,
      'answers': _userAnswers,
      'currentPage': _currentQuestionIndex,
      'language': _selectedLanguage,
      'elapsedTime': _elapsedTime.inSeconds,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore
          .collection(collectionName)
          .doc(_uid)
          .collection(collectionName)
          .doc(_currentQuizId)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Ошибка при сохранении прогресса: $e');
    }
  }

  // ───────────────────────────────── LOAD REMOTE ─────────────────────────────
  void _onLoadQuizProgress(
    LoadQuizProgressEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) async {
    await _loadProgress(event.quizId, event.subcategory);
    _emitLoaded(emit);
  }

  Future<void> _loadProgress(String quizId, String subcategory) async {
    // сначала SharedPreferences
    if (await _loadProgressFromPrefs(quizId, subcategory)) return;

    // потом Firestore
    if (_uid == null) return;

    final settingsBloc = GetIt.I<SettingsBloc>();
    final langCode = settingsBloc.currentLangCode;
    final collectionName = _getCollectionNameByLanguage(langCode);

    try {
      final snapshot =
          await _firestore
              .collection(collectionName)
              .doc(_uid)
              .collection(collectionName)
              .doc(quizId)
              .get();

      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      _currentQuestionIndex = data['currentPage'] ?? 0;
      _userAnswers = Map<String, String>.from(data['answers'] ?? {});
      _selectedLanguage = data['language'] ?? 'en';
      _elapsedTime = Duration(seconds: data['elapsedTime'] ?? 0);
      _timerController.add(_elapsedTime);
    } catch (e) {
      debugPrint('Ошибка при загрузке прогресса: $e');
    }
  }

  // ───────────────────────────────── HELPERS ────────────────────────────────
  String _generateQuizId(List<Question> questions, String subcategory) {
    final firstQuestionId =
        questions.isNotEmpty ? questions.first.question.hashCode : 0;
    final lastQuestionId =
        questions.isNotEmpty ? questions.last.question.hashCode : 0;
    return '${subcategory}_${firstQuestionId}_${lastQuestionId}_${questions.length}';
  }

  void _resetTimer() {
    _elapsedTime = Duration.zero;
    _timerController.add(_elapsedTime);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedTime += const Duration(seconds: 1);
      _timerController.add(_elapsedTime);
    });
  }

  void _emitLoaded(Emitter<AbstractCDLTestsState> emit) {
    emit(
      QuizLoadedState(
        allQuestions: _quizQuestions,
        userAnswers: _userAnswers,
        currentPage: _currentQuestionIndex,
        quizCompleted: _quizCompleted,
      ),
    );
  }

  String _getCollectionNameByLanguage(String code) {
    switch (code) {
      case 'ru':
        return 'CDLTestsRu';
      case 'es':
        return 'CDLTestsEs';
      case 'uk':
        return 'CDLTestsUk';
      case 'en':
      default:
        return 'CDLTests';
    }
  }

  // ───────────────────────────────── CLEANUP ────────────────────────────────
  @override
  Future<void> close() {
    _timer?.cancel();
    _timerController.close();
    return super.close();
  }
}
