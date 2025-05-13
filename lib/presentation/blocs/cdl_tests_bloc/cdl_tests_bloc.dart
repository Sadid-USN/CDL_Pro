import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CDLTestsBloc extends Bloc<AbstractCDLTestsEvent, AbstractCDLTestsState> {
  bool _isPremium = false;
  List<Question> _quizQuestions = [];
  Map<String, String> _userAnswers = {};
  int get currentPage => _currentQuestionIndex;
  int _currentQuestionIndex = 0;
  bool _quizCompleted = false;

  CDLTestsBloc() : super(PremiumInitial()) {
    on<CheckPremiumStatus>(_onCheckPremiumStatus);
    on<PurchasePremium>(_onPurchasePremium);
    on<LoadQuizEvent>(_onLoadQuiz);
    on<AnswerQuestionEvent>(_onAnswerQuestion);
    on<NextQuestionsEvent>(_onNextQuestions);
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
    _currentQuestionIndex = 0; // Сбрасываем индекс текущего вопроса
    _quizCompleted = false;

    emit(
      QuizLoadedState(
        allQuestions: _quizQuestions,
        userAnswers: _userAnswers,
        currentPage:
            _currentQuestionIndex, // Теперь используем currentQuestionIndex
        quizCompleted: _quizCompleted,
      ),
    );
  }

  void _onAnswerQuestion(
    AnswerQuestionEvent event,
    Emitter<AbstractCDLTestsState> emit,
  ) {
    _userAnswers[event.questionId] = event.selectedOption;

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
    // Переходим к следующему вопросу, если это не последний вопрос
    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      _currentQuestionIndex++;
    } else {
      _quizCompleted = true;
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
