import 'dart:convert';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/road_sign_bloc/road_sign.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoadSignBloc extends Bloc<AbstractRoadSignEvent, RoadSignState> {
  static const _prefsKey = 'road_sign_answers';
  static const _indexKey = 'road_sign_current_index';
  final SharedPreferences prefs;

  RoadSignBloc(this.prefs, List<RoadSignModel> signs)
      : super(RoadSignState(signs: signs, currentIndex: 0)) {
    on<AnswerRoadSignQuestionEvent>((event, emit) async {
      final answers = Map<String, Map<String, String>>.from(state.userAnswers);
      answers[event.signId] = Map<String, String>.from(
        answers[event.signId] ?? {},
      );
      answers[event.signId]![event.language] = event.selectedOption;

      emit(state.copyWith(userAnswers: answers));
      await _saveAnswers(answers);
    });

    on<NextSignEvent>((event, emit) async {
      if (state.currentIndex < state.signs.length - 1) {
        final newIndex = state.currentIndex + 1;
        emit(state.copyWith(currentIndex: newIndex));
        await prefs.setInt(_indexKey, newIndex); // сохраняем текущий индекс
      }
    });

    on<PreviousSignEvent>((event, emit) async {
      if (state.currentIndex > 0) {
        final newIndex = state.currentIndex - 1;
        emit(state.copyWith(currentIndex: newIndex));
        await prefs.setInt(_indexKey, newIndex); // сохраняем текущий индекс
      }
    });

    on<LoadSavedAnswersEvent>((event, emit) async {
      final savedAnswers = _loadAnswers() ?? {};
      final savedIndex = prefs.getInt(_indexKey) ?? 0;
      emit(state.copyWith(userAnswers: savedAnswers, currentIndex: savedIndex));
    });

    on<ResetQuizEvent>((event, emit) async {
      emit(state.copyWith(userAnswers: {}, currentIndex: 0));
      await _clearAnswers();
      await prefs.remove(_indexKey); // сброс индекса
    });
  }

  Future<void> _saveAnswers(Map<String, Map<String, String>> answers) async {
    prefs.setString(_prefsKey, jsonEncode(answers));
  }

  Map<String, Map<String, String>>? _loadAnswers() {
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString == null) return null;

    final Map<String, dynamic> map = jsonDecode(jsonString);
    return map.map(
      (key, value) => MapEntry(
        key,
        (value as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, v.toString()),
        ),
      ),
    );
  }

  Future<void> _clearAnswers() async {
    await prefs.remove(_prefsKey);
  }
}
