import 'dart:convert';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class CDLTestsBloc extends Bloc<AbstractCDLTestsEvent, AbstractCDLTestsState> {
  final GoogleTranslator _translator = GoogleTranslator();
  bool _isPremium = false;
  List<Question> _quizQuestions = [];
  Map<String, String> _userAnswers = {};
  int get currentPage => _currentQuestionIndex;
  int _currentQuestionIndex = 0;
  bool _quizCompleted = false;
  String _selectedLanguage = 'en';
  final SharedPreferences _prefs;
  String? _currentQuizId;

  CDLTestsBloc(this._prefs) : super(PremiumInitial()) {
    on<CheckPremiumStatus>(_onCheckPremiumStatus);
    on<PurchasePremium>(_onPurchasePremium);
    on<LoadQuizEvent>(_onLoadQuiz);
    on<AnswerQuestionEvent>(_onAnswerQuestion);
    on<NextQuestionsEvent>(_onNextQuestions);
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<SaveQuizProgressEvent>(_onSaveQuizProgress);
    on<LoadQuizProgressEvent>(_onLoadQuizProgress);
      on<ResetQuizEvent>(_onResetQuiz);
  }


void _onResetQuiz(
    ResetQuizEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) {
    _currentQuestionIndex = 0;
    _userAnswers = {};
    _quizCompleted = false;

    // Очищаем сохраненный прогресс
    if (_currentQuizId != null) {
      _prefs.remove('${_currentQuizId}_currentPage');
      _prefs.remove('${_currentQuizId}_userAnswers');
    }

    emit(
      QuizLoadedState(
        selectedLanguage: _selectedLanguage,
        allQuestions: _quizQuestions,
        userAnswers: _userAnswers,
        currentPage: _currentQuestionIndex,
        quizCompleted: _quizCompleted,
      ),
    );
  }
  Future<void> saveProgress() async {
    if (_currentQuizId == null) return;

    await _prefs.setInt('${_currentQuizId}_currentPage', _currentQuestionIndex);
    await _prefs.setString(
      '${_currentQuizId}_userAnswers',
      jsonEncode(_userAnswers),
    );
    await _prefs.setString('${_currentQuizId}_language', _selectedLanguage);
  }

  Future<void> loadProgress(String quizId) async {
    _currentQuizId = quizId;

    final page = _prefs.getInt('${quizId}_currentPage') ?? 0;
    final answersJson = _prefs.getString('${quizId}_userAnswers');
    final language = _prefs.getString('${quizId}_language') ?? 'en';

    _currentQuestionIndex = page;
    _selectedLanguage = language;
    _userAnswers =
        answersJson != null
            ? Map<String, String>.from(jsonDecode(answersJson))
            : {};
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
    // Генерируем уникальный ID квиза на основе вопросов
    final quizId = _generateQuizId(event.questions);
    _currentQuizId = quizId;

    // Загружаем сохраненный прогресс
    await loadProgress(quizId);

    _quizQuestions = event.questions;
    _quizCompleted = false;

    emit(
      QuizLoadedState(
        selectedLanguage: _selectedLanguage,
        allQuestions: _quizQuestions,
        userAnswers: _userAnswers,
        currentPage: _currentQuestionIndex,
        quizCompleted: _quizCompleted,
      ),
    );
  }

  String _generateQuizId(List<Question> questions) {
    // Простой способ генерации ID без использования crypto
    return questions
        .map((q) => q.question.hashCode.toString())
        .join('_')
        .hashCode
        .toString();
  }

  void _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) async {
    if (state is QuizLoadedState) {
      final currentState = state as QuizLoadedState;
      // Сохраняем новый язык
      _selectedLanguage =
          currentState.selectedLanguage == event.languageCode
              ? 'en'
              : event.languageCode;

      // Создаем копию текущего состояния с новым языком
      final newState = QuizLoadedState(
        selectedLanguage: _selectedLanguage,
        allQuestions: currentState.allQuestions,
        userAnswers: currentState.userAnswers,
        currentPage: currentState.currentPage,
        quizCompleted: currentState.quizCompleted,
      );

      // Эмитим новое состояние
      emit(newState);

      // Принудительно обновляем переводы
      await _precacheTranslations(newState);
    }
  }

  Future<void> _precacheTranslations(QuizLoadedState state) async {
    try {
      // Предзагружаем перевод текущего вопроса
      final currentQuestion = state.allQuestions[state.currentPage];
      await translateText(currentQuestion.question, state.selectedLanguage);

      // Предзагружаем перевод вариантов ответов
      for (final option in currentQuestion.options.values) {
        await translateText(option, state.selectedLanguage);
      }

      // Предзагружаем перевод описания (если вопрос отвечен)
      if (state.userAnswers.containsKey(currentQuestion.question)) {
        await translateText(
          currentQuestion.description,
          state.selectedLanguage,
        );
      }
    } catch (e) {
      debugPrint('Precache translations error: $e');
    }
  }

  Future<String> translateText(String text, String? targetLanguage) async {
    // Если язык не выбран или выбран английский - возвращаем оригинальный текст
    if (text.isEmpty || targetLanguage == null || targetLanguage == 'en') {
      return text;
    }

    try {
      final translation = await _translator.translate(text, to: targetLanguage);
      return translation.text;
    } catch (e) {
      debugPrint('Translation error: $e');
      return text;
    }
  }

  // Существующие методы...
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
        selectedLanguage: _selectedLanguage, // Сохраняем язык
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
        selectedLanguage: _selectedLanguage,
        allQuestions: _quizQuestions,
        userAnswers: _userAnswers,
        currentPage: _currentQuestionIndex,
        quizCompleted: _quizCompleted,
      ),
    );
  }
}
