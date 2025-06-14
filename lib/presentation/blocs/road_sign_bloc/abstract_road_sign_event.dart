import 'package:equatable/equatable.dart';

abstract class AbstractRoadSignEvent extends Equatable {
  const AbstractRoadSignEvent();

  @override
  List<Object?> get props => [];
}

class ToggleViewModeEvent extends AbstractRoadSignEvent {
  final bool isGridView;

  const ToggleViewModeEvent({required this.isGridView});

  @override
  List<Object> get props => [isGridView];
}

// Конкретные события
class ZoomInEvent extends AbstractRoadSignEvent {
  const ZoomInEvent();
}

class ZoomOutEvent extends AbstractRoadSignEvent {
  const ZoomOutEvent();
}

