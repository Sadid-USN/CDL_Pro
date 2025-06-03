import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  CDLTestsBloc() : super(PremiumInitial()) {
    on<CheckPremiumStatus>(_onCheckPremiumStatus);
    on<PurchasePremium>(_onPurchasePremium);
    on<LoadQuizEvent>(_onLoadQuiz);
    on<AnswerQuestionEvent>(_onAnswerQuestion);
    on<NextQuestionsEvent>(_onNextQuestions);
    on<ChangeLanguageEvent>(_onChangeLanguage);
  }

   void _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) {
    if (state is QuizLoadedState) {
      final currentState = state as QuizLoadedState;
      _selectedLanguage = currentState.selectedLanguage == event.languageCode 
          ? 'en' 
          : event.languageCode;

      emit(
        QuizLoadedState(
          selectedLanguage: _selectedLanguage,
          allQuestions: currentState.allQuestions,
          userAnswers: currentState.userAnswers,
          currentPage: currentState.currentPage,
          quizCompleted: currentState.quizCompleted,
        ),
      );
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

  // Новые методы для квиза
   void _onLoadQuiz(LoadQuizEvent event, Emitter<AbstractCDLTestsState> emit) {
    _quizQuestions = event.questions;
    _userAnswers = {};
    _currentQuestionIndex = 0;
    _quizCompleted = false;
   _selectedLanguage = event.initialLanguage; 


    emit(
      QuizLoadedState(
        selectedLanguage: _selectedLanguage, // Используем сохраненный язык
        allQuestions: _quizQuestions,
        userAnswers: _userAnswers,
        currentPage: _currentQuestionIndex,
        quizCompleted: _quizCompleted,
      ),
    );
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
    }

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
}
