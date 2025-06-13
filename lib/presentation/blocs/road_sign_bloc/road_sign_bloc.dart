import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/road_sign_bloc/road_sign.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoadSignBloc extends Bloc<AbstractRoadSignEvent, AbstractRoadSignState> {
  final double _minHeightFactor = 0.5;
  final double _maxHeightFactor = 1.5;
  final double _heightStep = 0.1;

  RoadSignBloc(List<RoadSignModel> initialSigns)
      : super(RoadSignState(
          imageHeightFactor: 1.0,
          signs: initialSigns,
        )) {
    on<ZoomInEvent>(_onZoomIn);
    on<ZoomOutEvent>(_onZoomOut);
    on<ResetZoomEvent>(_onResetZoom);
  }

  void _onZoomIn(ZoomInEvent event, Emitter<AbstractRoadSignState> emit) {
    if (state is! RoadSignState) return;
    final currentState = state as RoadSignState;

    final newFactor = (currentState.imageHeightFactor + _heightStep)
        .clamp(_minHeightFactor, _maxHeightFactor);
    
    emit(currentState.copyWith(imageHeightFactor: newFactor));
  }

  void _onZoomOut(ZoomOutEvent event, Emitter<AbstractRoadSignState> emit) {
    if (state is! RoadSignState) return;
    final currentState = state as RoadSignState;

    final newFactor = (currentState.imageHeightFactor - _heightStep)
        .clamp(_minHeightFactor, _maxHeightFactor);
    
    emit(currentState.copyWith(imageHeightFactor: newFactor));
  }

  void _onResetZoom(ResetZoomEvent event, Emitter<AbstractRoadSignState> emit) {
    if (state is! RoadSignState) return;
    final currentState = state as RoadSignState;

    emit(currentState.copyWith(imageHeightFactor: 1.0));
  }
}


