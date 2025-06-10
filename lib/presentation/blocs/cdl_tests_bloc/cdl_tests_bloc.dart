import 'dart:async';
import 'dart:convert';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CDLTestsBloc extends Bloc<AbstractCDLTestsEvent, AbstractCDLTestsState> {
  bool _isPremium = false;
  List<Question> _quizQuestions = [];
  Map<String, String> _userAnswers = {};
  int get currentPage => _currentQuestionIndex;
  int _currentQuestionIndex = 0;
  bool _quizCompleted = false;
  String _selectedLanguage = 'en';
  final SharedPreferences _prefs;
  String? _currentQuizId;
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  final StreamController<Duration> _timerController =
      StreamController<Duration>.broadcast();
  Stream<Duration> get timerStream => _timerController.stream;

  CDLTestsBloc(this._prefs) : super(PremiumInitial()) {
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

  // Update loadProgress to load timer state for specific quiz
  Future<void> loadProgress(String quizId) async {
    _currentQuizId = quizId;

    final page = _prefs.getInt('${quizId}_currentPage') ?? 0;
    final answersJson = _prefs.getString('${quizId}_userAnswers');
    final language = _prefs.getString('${quizId}_language') ?? 'en';
    final elapsedSeconds = _prefs.getInt('${quizId}_elapsedTime') ?? 0;

    _currentQuestionIndex = page;
    _selectedLanguage = language;
    _userAnswers =
        answersJson != null
            ? Map<String, String>.from(jsonDecode(answersJson))
            : {};
    _elapsedTime = Duration(seconds: elapsedSeconds);
    _timerController.add(_elapsedTime);
  }

  void _onSaveQuizProgress(
    SaveQuizProgressEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) async {
    await saveProgress();
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
