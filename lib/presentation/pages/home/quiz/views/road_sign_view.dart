import 'package:cdl_pro/core/extensions/extensions.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/road_sign_bloc/road_sign.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoadSignView extends StatelessWidget {
  final List<QueryDocumentSnapshot> docs;

  const RoadSignView({super.key, required this.docs});

  List<RoadSignModel> _processDocs(List<QueryDocumentSnapshot> docs) {
    if (docs.isEmpty) return [];
    final data = docs.first.data() as Map<String, dynamic>;
    final signsMap = data['signs'] as Map<String, dynamic>? ?? {};
    return signsMap.entries.map((entry) {
        final value = entry.value as Map<String, dynamic>;
        return RoadSignModel.fromJson(entry.key, value);
      }).toList()
      ..sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
  }

  @override
  Widget build(BuildContext context) {
    final signs = _processDocs(docs);

    if (signs.isEmpty) {
      return const Center(child: Text('No signs available'));
    }

    return BlocProvider(
      create: (_) {
        final bloc = RoadSignBloc(GetIt.I<SharedPreferences>(), signs);
        bloc.add(LoadSavedAnswersEvent());
        return bloc;
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          final selectedLanguage = settingsState.selectedLang;

          return BlocBuilder<RoadSignBloc, RoadSignState>(
            builder: (context, state) {
              if (state.signs.isEmpty) {
                return const Center(child: Text('No signs available'));
              }

              final sign = state.signs[state.currentIndex];
              final quiz = sign.quiz[selectedLanguage.code];
              if (quiz == null) {
                return Center(
                  child: Text('No quiz available for $selectedLanguage'),
                );
              }

              final userAnswer =
                  state.userAnswers[sign.id]?[selectedLanguage.code];
              final isAnswered = userAnswer != null;

              return RoadSignQuizCard(
                onPressed: () {
                  context.read<RoadSignBloc>().add(ResetQuizEvent());
                  Navigator.of(context).pop();
                },
                state: state,
                sign: sign,
                quiz: quiz,
                userAnswer: userAnswer,
                isAnswered: isAnswered,
                language: selectedLanguage.code,
              );
            },
          );
        },
      ),
    );
  }
}
