import 'package:cdl_pro/domain/models/models.dart';
import 'package:equatable/equatable.dart';

class RoadSignState extends Equatable {
  final List<RoadSignModel> signs;
  final Map<String, Map<String, String>> userAnswers;
  final int currentIndex;

  const RoadSignState({
    this.signs = const [],
    this.userAnswers = const {},
    this.currentIndex = 0,
  });

  @override
  List<Object?> get props => [signs, userAnswers, currentIndex];

  RoadSignState copyWith({
    List<RoadSignModel>? signs,
    Map<String, Map<String, String>>? userAnswers,
    int? currentIndex,
  }) {
    return RoadSignState(
      signs: signs ?? this.signs,
      userAnswers: userAnswers ?? this.userAnswers,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

