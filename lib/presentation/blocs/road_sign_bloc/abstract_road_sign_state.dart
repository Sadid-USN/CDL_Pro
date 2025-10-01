import 'package:cdl_pro/domain/models/models.dart';
import 'package:equatable/equatable.dart';

class RoadSignState extends Equatable {
  final List<RoadSignModel> signs;
  final Map<String, Map<String, String>> userAnswers;
  final int currentIndex;
  final bool isQuizMode;

  const RoadSignState({
    this.signs = const [],
    this.userAnswers = const {},
    this.currentIndex = 0,
    this.isQuizMode = true,
  });

  @override
  List<Object?> get props => [signs, userAnswers, currentIndex, isQuizMode];

  RoadSignState copyWith({
    List<RoadSignModel>? signs,
    Map<String, Map<String, String>>? userAnswers,
    int? currentIndex,
    bool? isQuizMode,
  }) {
    return RoadSignState(
      signs: signs ?? this.signs,
      userAnswers: userAnswers ?? this.userAnswers,
      currentIndex: currentIndex ?? this.currentIndex,
      isQuizMode: isQuizMode ?? this.isQuizMode,
    );
  }
}
