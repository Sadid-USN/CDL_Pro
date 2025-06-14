import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/road_sign_bloc/road_sign.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoadSignBloc extends Bloc<AbstractRoadSignEvent, RoadSignState> {
  final double _minHeightFactor = 0.5;
  final double _maxHeightFactor = 1.5;
  final double _heightStep = 0.1;

  RoadSignBloc(List<RoadSignModel> initialSigns)
      : super(RoadSignState(
          imageHeightFactor: 1.0,
          signs: initialSigns,
          isGridView: false, // Добавляем начальное значение
        )) {
    on<ZoomInEvent>(_onZoomIn);
    on<ZoomOutEvent>(_onZoomOut);
    on<ToggleViewModeEvent>(_onToggleViewMode); // Добавляем обработчик
  }

  void _onZoomIn(ZoomInEvent event, Emitter<RoadSignState> emit) {
    final newFactor = (state.imageHeightFactor + _heightStep).clamp(
      _minHeightFactor,
      _maxHeightFactor,
    );
    emit(state.copyWith(imageHeightFactor: newFactor));
  }

  void _onZoomOut(ZoomOutEvent event, Emitter<RoadSignState> emit) {
    final newFactor = (state.imageHeightFactor - _heightStep).clamp(
      _minHeightFactor,
      _maxHeightFactor,
    );
    emit(state.copyWith(imageHeightFactor: newFactor));
  }

  void _onToggleViewMode(ToggleViewModeEvent event, Emitter<RoadSignState> emit) {
    emit(state.copyWith(isGridView: event.isGridView));
  }
}