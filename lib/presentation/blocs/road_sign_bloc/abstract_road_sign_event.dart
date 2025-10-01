import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class AbstractRoadSignEvent extends Equatable {
  const AbstractRoadSignEvent();
  @override
  List<Object?> get props => [];
}

class ToggleModeEvent extends AbstractRoadSignEvent {
  final bool isQuizMode;
  const ToggleModeEvent(this.isQuizMode);

  @override
  List<Object?> get props => [isQuizMode];
}

class LoadRoadSignsEvent extends AbstractRoadSignEvent {
  final List<RoadSignModel> signs;
  const LoadRoadSignsEvent(this.signs);

  @override
  List<Object?> get props => [signs];
}

class AnswerRoadSignQuestionEvent extends AbstractRoadSignEvent {
  final String signId;
  final String language;
  final String selectedOption;

  const AnswerRoadSignQuestionEvent({
    required this.signId,
    required this.language,
    required this.selectedOption,
  });

  @override
  List<Object?> get props => [signId, language, selectedOption];
}

class NextSignEvent extends AbstractRoadSignEvent {}

class PreviousSignEvent extends AbstractRoadSignEvent {}

class LoadSavedAnswersEvent extends AbstractRoadSignEvent {}
class ResetQuizEvent extends AbstractRoadSignEvent {}

