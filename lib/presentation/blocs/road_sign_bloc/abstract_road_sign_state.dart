import 'package:cdl_pro/domain/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class AbstractRoadSignState extends Equatable {
  const AbstractRoadSignState();

  @override
  List<Object?> get props => [];
}

// Конкретное состояние
class RoadSignState extends AbstractRoadSignState {
  final double imageHeightFactor;
  final List<RoadSignModel> signs;

  const RoadSignState({
    required this.imageHeightFactor,
    required this.signs,
  });

  @override
  List<Object?> get props => [imageHeightFactor, signs];

  RoadSignState copyWith({
    double? imageHeightFactor,
    List<RoadSignModel>? signs,
  }) {
    return RoadSignState(
      imageHeightFactor: imageHeightFactor ?? this.imageHeightFactor,
      signs: signs ?? this.signs,
    );
  }
}
