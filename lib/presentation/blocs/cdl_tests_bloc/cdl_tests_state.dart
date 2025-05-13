import 'package:cdl_pro/domain/models/models.dart';
import 'package:equatable/equatable.dart';


abstract class AbstractCDLTestsState extends Equatable {
  const AbstractCDLTestsState();
  
  @override
  List<Object?> get props => [];
}

class QuizInitialState extends AbstractCDLTestsState {
  const QuizInitialState();

  @override
  List<Object?> get props => [];
}

class QuizLoadedState extends AbstractCDLTestsState {
  final List<Question> allQuestions;
  final Map<String, String> userAnswers;
  final int currentPage; // Теперь это индекс текущего вопроса
  final bool quizCompleted;

  const QuizLoadedState({
    required this.allQuestions,
    required this.userAnswers,
    required this.currentPage,
    required this.quizCompleted,
  });

  // Возвращаем только текущий вопрос
  Question get currentQuestion {
    return allQuestions[currentPage];
  }

  // Проверяем, ответил ли пользователь на текущий вопрос
  bool get isCurrentQuestionAnswered {
    return userAnswers.containsKey(currentQuestion.question);
  }

  // Проверяем, это последний вопрос
  bool get isLastQuestion {
    return currentPage == allQuestions.length - 1;
  }

  @override
  List<Object?> get props => [allQuestions, userAnswers, currentPage, quizCompleted];
}
class PremiumInitial extends AbstractCDLTestsState {
  const PremiumInitial();
}

class PremiumLoading extends AbstractCDLTestsState {
  const PremiumLoading();
}

class PremiumLoaded extends AbstractCDLTestsState {
  final bool isPremium;
  
  const PremiumLoaded(this.isPremium);
  
  @override
  List<Object?> get props => [isPremium];
}

class PremiumError extends AbstractCDLTestsState {
  final String message;
  
  const PremiumError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class TranslateState extends AbstractCDLTestsState {
  final String codeCountry;
  final String translatedText;

  const TranslateState({
    required this.codeCountry,
    required this.translatedText,
  });

  factory TranslateState.initial() {
    return const TranslateState(
      codeCountry: 'en',
      translatedText: '',
    );
  }

  TranslateState copyWith({
    String? codeCountry,
    String? translatedText,
  }) {
    return TranslateState(
      codeCountry: codeCountry ?? this.codeCountry,
      translatedText: translatedText ?? this.translatedText,
    );
  }

  @override
  List<Object?> get props => [codeCountry, translatedText];
}
