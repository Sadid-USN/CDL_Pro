import 'dart:async';
import 'dart:convert';
import 'package:cdl_pro/domain/domain.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CDLTestsBloc extends Bloc<AbstractCDLTestsEvent, AbstractCDLTestsState> {
  final SharedPreferences _prefs;
  final AbstractUserRepo _userRepo;
  final FirebaseFirestore _firestore;

  bool _isPremium = false;
  List<Question> _quizQuestions = [];
  Map<String, String> _userAnswers = {};
  int get currentPage => _currentQuestionIndex;
  int _currentQuestionIndex = 0;
  bool _quizCompleted = false;
  String _selectedLanguage = 'en';
  String? _currentQuizId;
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  final StreamController<Duration> _timerController =
      StreamController<Duration>.broadcast();
  Stream<Duration> get timerStream => _timerController.stream;

  CDLTestsBloc(this._prefs, this._userRepo, this._firestore)
    : super(PremiumInitial()) {
    on<CheckPremiumStatus>(_onCheckPremiumStatus);
    on<PurchasePremium>(_onPurchasePremium);
    on<LoadQuizEvent>(_onLoadQuiz);
    on<AnswerQuestionEvent>(_onAnswerQuestion);
    on<NextQuestionsEvent>(_onNextQuestions);
    on<PreviousQuestionsEvent>(_onPreviousQuestions);

    on<SaveQuizProgressEvent>(_onSaveQuizProgress);
    on<LoadQuizProgressEvent>(_onLoadQuizProgress);
    on<ResetQuizEvent>(_onResetQuiz);
    on<StartTimerEvent>(_onStartTimer);
    on<StopTimerEvent>(_onStopTimer);
  }

  // Add these new methods for timer control
  void _onStartTimer(
    StartTimerEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsedTime += Duration(seconds: 1);
      _timerController.add(_elapsedTime);
    });
  }

  void _onStopTimer(StopTimerEvent event, Emitter<AbstractCDLTestsState> emit) {
    _timer?.cancel();
    _timer = null;
  }

  Map<String, dynamic> calculateResults() {
    int totalQuestions = _quizQuestions.length;
    int correctAnswers = 0;

    for (var question in _quizQuestions) {
      if (_userAnswers[question.question] == question.correctOption) {
        correctAnswers++;
      }
    }

    int wrongAnswers = totalQuestions - correctAnswers;
    double percentage = (correctAnswers / totalQuestions) * 100;

    return {
      'total': totalQuestions,
      'correct': correctAnswers,
      'wrong': wrongAnswers,
      'percentage': percentage,
      'passed': percentage >= 90,
    };
  }

  void _onPreviousQuestions(
    PreviousQuestionsEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
    }

    emit(
      QuizLoadedState(
        allQuestions: _quizQuestions,
        userAnswers: _userAnswers,
        currentPage: _currentQuestionIndex,
        quizCompleted: _quizCompleted,
      ),
    );
  }

  void _onResetQuiz(ResetQuizEvent event, Emitter<AbstractCDLTestsState> emit) {
    _currentQuestionIndex = 0;
    _userAnswers = {};
    _quizCompleted = false;
    _elapsedTime = Duration.zero;
    _timerController.add(_elapsedTime);

    // Cancel and reset timer
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsedTime += Duration(seconds: 1);
      _timerController.add(_elapsedTime);
    });

    // Очищаем сохраненный прогресс
    if (_currentQuizId != null) {
      _prefs.remove('${_currentQuizId}_currentPage');
      _prefs.remove('${_currentQuizId}_userAnswers');
      _prefs.remove('${_currentQuizId}_elapsedTime');
    }

    emit(
      QuizLoadedState(
        allQuestions: _quizQuestions,
        userAnswers: _userAnswers,
        currentPage: _currentQuestionIndex,
        quizCompleted: _quizCompleted,
      ),
    );
  }

  // Update saveProgress to include quizId in the timer key
  Future<void> saveProgress() async {
    if (_currentQuizId == null) return;

    await _prefs.setInt('${_currentQuizId}_currentPage', _currentQuestionIndex);
    await _prefs.setString(
      '${_currentQuizId}_userAnswers',
      jsonEncode(_userAnswers),
    );
    await _prefs.setString('${_currentQuizId}_language', _selectedLanguage);
    await _prefs.setInt(
      '${_currentQuizId}_elapsedTime',
      _elapsedTime.inSeconds,
    );
  }

  Future<void> loadProgress(String quizId) async {
    final uid = _userRepo.currentUid;
    if (uid == null) return;

    final settingsBloc = GetIt.I<SettingsBloc>();
    final langCode = settingsBloc.currentLangCode;
    final collectionName = _getCollectionNameByLanguage(langCode);

    try {
      final snapshot =
          await _firestore
              .collection(collectionName)
              .doc(uid)
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
      print('Ошибка при загрузке прогресса: $e');
    }
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
void _onSaveQuizProgress(
  SaveQuizProgressEvent event,
  Emitter<AbstractCDLTestsState> emit,
) async {
  final uid = _userRepo.currentUid;
  if (uid == null || _currentQuizId == null) return;

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
        .doc(uid)
        .collection(collectionName)
        .doc(_currentQuizId)
        .set(data, SetOptions(merge: true));
  } catch (e) {
    print('Ошибка при сохранении прогресса: $e');
  }
}

  void _onLoadQuizProgress(
    LoadQuizProgressEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) async {
    await loadProgress(event.quizId);
  }

  void _onLoadQuiz(
    LoadQuizEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) async {
    // Generate unique quiz ID based on questions
    final quizId = _generateQuizId(event.questions);

    // If this is a different quiz, reset the timer
    if (_currentQuizId != quizId) {
      _elapsedTime = Duration.zero;
      _timerController.add(_elapsedTime);
      _timer?.cancel();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _elapsedTime += Duration(seconds: 1);
        _timerController.add(_elapsedTime);
      });
    }

    _currentQuizId = quizId;
    await loadProgress(quizId);

    _quizQuestions = event.questions;
    _quizCompleted = false;

    emit(
      QuizLoadedState(
        allQuestions: _quizQuestions,
        userAnswers: _userAnswers,
        currentPage: _currentQuestionIndex,
        quizCompleted: _quizCompleted,
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _timerController.close();
    return super.close();
  }

  String _generateQuizId(List<Question> questions) {
    // Простой способ генерации ID без использования crypto
    return questions
        .map((q) => q.question.hashCode.toString())
        .join('_')
        .hashCode
        .toString();
  }

  Future<void> _onCheckPremiumStatus(
    CheckPremiumStatus event,
    Emitter<AbstractCDLTestsState> emit,
  ) async {
    emit(PremiumLoading());
    await Future.delayed(const Duration(milliseconds: 300));
    final isPremium = event.isPremium ?? _isPremium;
    emit(PremiumLoaded(isPremium));
  }

  Future<void> _onPurchasePremium(
    PurchasePremium event,
    Emitter<AbstractCDLTestsState> emit,
  ) async {
    emit(PremiumLoading());
    await Future.delayed(const Duration(seconds: 1));
    _isPremium = true;
    emit(PremiumLoaded(true));
  }

  void _onAnswerQuestion(
    AnswerQuestionEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) {
    _userAnswers = Map<String, String>.from(_userAnswers)
      ..[event.questionId] = event.selectedOption;

    emit(
      QuizLoadedState(
        allQuestions: _quizQuestions,
        userAnswers: _userAnswers,
        currentPage: _currentQuestionIndex,
        quizCompleted: _quizCompleted,
      ),
    );
  }

  void _onNextQuestions(
    NextQuestionsEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) {
    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      _currentQuestionIndex++;
    } else {
      _quizCompleted = true;
      // Очищаем прогресс при завершении теста
      if (_currentQuizId != null) {
        _prefs.remove('${_currentQuizId}_currentPage');
        _prefs.remove('${_currentQuizId}_userAnswers');
      }
    }

    emit(
      QuizLoadedState(
        allQuestions: _quizQuestions,
        userAnswers: _userAnswers,
        currentPage: _currentQuestionIndex,
        quizCompleted: _quizCompleted,
      ),
    );
  }
}
