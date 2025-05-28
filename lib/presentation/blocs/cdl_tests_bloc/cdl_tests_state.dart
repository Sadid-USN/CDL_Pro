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
  final int currentPage;
  final bool quizCompleted;
  final String selectedLanguage; // <- Новое поле

  const QuizLoadedState({
    required this.allQuestions,
    required this.userAnswers,
    required this.currentPage,
    required this.quizCompleted,
    required this.selectedLanguage,
  });

  Question get currentQuestion => allQuestions[currentPage];

  bool get isCurrentQuestionAnswered => userAnswers.containsKey(currentQuestion.question);

  bool get isLastQuestion => currentPage == allQuestions.length - 1;

  QuizLoadedState copyWith({
    List<Question>? allQuestions,
    Map<String, String>? userAnswers,
    int? currentPage,
    bool? quizCompleted,
    String? selectedLanguage,
  }) {
    return QuizLoadedState(
      allQuestions: allQuestions ?? this.allQuestions,
      userAnswers: userAnswers ?? this.userAnswers,
      currentPage: currentPage ?? this.currentPage,
      quizCompleted: quizCompleted ?? this.quizCompleted,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object?> get props =>
      [allQuestions, userAnswers, currentPage, quizCompleted, selectedLanguage];
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
