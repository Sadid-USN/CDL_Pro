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
  final bool isLoadingProgress; // Новое поле для индикации загрузки

  const QuizLoadedState({
    required this.allQuestions,
    required this.userAnswers,
    required this.currentPage,
    required this.quizCompleted,
    this.isLoadingProgress = false, // По умолчанию false
  });

  QuizLoadedState copyWith({
    List<Question>? allQuestions,
    Map<String, String>? userAnswers,
    int? currentPage,
    bool? quizCompleted,
    bool? isLoadingProgress,
  }) {
    return QuizLoadedState(
      allQuestions: allQuestions ?? this.allQuestions,
      userAnswers: userAnswers ?? this.userAnswers,
      currentPage: currentPage ?? this.currentPage,
      quizCompleted: quizCompleted ?? this.quizCompleted,
      isLoadingProgress: isLoadingProgress ?? this.isLoadingProgress,
    );
  }

  @override
  List<Object?> get props => [
    allQuestions,
    userAnswers,
    currentPage,
    quizCompleted,
    isLoadingProgress,
  ];
}

class QuizProgressLoading extends AbstractCDLTestsState {}

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
