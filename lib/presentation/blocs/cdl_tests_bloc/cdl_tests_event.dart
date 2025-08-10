import 'package:cdl_pro/domain/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class AbstractCDLTestsEvent extends Equatable {
  const AbstractCDLTestsEvent();

  @override
  List<Object?> get props => [];
}



class WorkOnMistakesEvent extends AbstractCDLTestsEvent {}

class PreviousQuestionsEvent extends AbstractCDLTestsEvent {}

class StartTimerEvent extends AbstractCDLTestsEvent {}

class StopTimerEvent extends AbstractCDLTestsEvent {}



class ResetQuizEvent extends AbstractCDLTestsEvent {
  const ResetQuizEvent();

  @override
  List<Object?> get props => [];
}

class SaveQuizProgressEvent extends AbstractCDLTestsEvent {
  const SaveQuizProgressEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuizProgressEvent extends AbstractCDLTestsEvent {
  final String quizId;
  final String subcategory;

  const LoadQuizProgressEvent(this.quizId, this.subcategory);

  @override
  List<Object?> get props => [quizId, subcategory];
}

class LoadQuizEvent extends AbstractCDLTestsEvent {
  final List<Question> questions;
  final String initialLanguage;
  final String subcategory;

  const LoadQuizEvent(
    this.questions, {

    this.initialLanguage = 'en',
    required this.subcategory,
  });

  @override
  List<Object?> get props => [questions, initialLanguage, subcategory];
}

class AnswerQuestionEvent extends AbstractCDLTestsEvent {
  final String questionId;
  final String selectedOption;
  const AnswerQuestionEvent(this.questionId, this.selectedOption);

  @override
  List<Object?> get props => [questionId, selectedOption];
}

class NextQuestionsEvent extends AbstractCDLTestsEvent {
  const NextQuestionsEvent();

  @override
  List<Object?> get props => [];
}
