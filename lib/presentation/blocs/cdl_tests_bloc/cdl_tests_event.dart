import 'package:cdl_pro/domain/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class AbstractCDLTestsEvent extends Equatable {
  const AbstractCDLTestsEvent();

  @override
  List<Object?> get props => [];
}

class PreviousQuestionsEvent extends AbstractCDLTestsEvent {}

class StartTimerEvent extends AbstractCDLTestsEvent {}

class StopTimerEvent extends AbstractCDLTestsEvent {}

class SetUserUidEvent extends AbstractCDLTestsEvent {
  final String? uid; // null → пользователь вышел
  const SetUserUidEvent(this.uid);
}

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

  const LoadQuizProgressEvent(this.quizId);

  @override
  List<Object?> get props => [quizId];
}

class LoadQuizEvent extends AbstractCDLTestsEvent {
  final List<Question> questions;
  final String initialLanguage;

  const LoadQuizEvent(this.questions, {this.initialLanguage = 'en'});
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
