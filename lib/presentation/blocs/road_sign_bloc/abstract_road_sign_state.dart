import 'package:cdl_pro/domain/models/models.dart';
import 'package:equatable/equatable.dart';

// Конкретное состояние
class RoadSignState extends Equatable {
  final double imageHeightFactor;
  final List<RoadSignModel> signs;
  final bool isGridView; 

  const RoadSignState({
     this.isGridView = false,
    required this.imageHeightFactor, required this.signs});

  @override
  List<Object?> get props => [imageHeightFactor, signs, isGridView];

  RoadSignState copyWith({
    double? imageHeightFactor,
    List<RoadSignModel>? signs,
    bool ? isGridView ,
  }) {
    return RoadSignState(
      isGridView: isGridView ?? this.isGridView,
      imageHeightFactor: imageHeightFactor ?? this.imageHeightFactor,
      signs: signs ?? this.signs,
    );
  }
}
