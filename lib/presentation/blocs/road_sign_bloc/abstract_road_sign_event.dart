import 'package:equatable/equatable.dart';

abstract class AbstractRoadSignEvent extends Equatable {
  const AbstractRoadSignEvent();

  @override
  List<Object?> get props => [];
}

// Конкретные события
class ZoomInEvent extends AbstractRoadSignEvent {
  const ZoomInEvent();
}

class ZoomOutEvent extends AbstractRoadSignEvent {
  const ZoomOutEvent();
}

class ResetZoomEvent extends AbstractRoadSignEvent {
  const ResetZoomEvent();
}