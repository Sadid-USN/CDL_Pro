import 'package:cdl_pro/core/extensions/extensions.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/road_sign_bloc/road_sign.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    final bloc = context.read<RoadSignBloc>();

    bloc
      ..add(LoadSavedAnswersEvent())
      ..add(LoadRoadSignsEvent(signs));

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return BlocBuilder<RoadSignBloc, RoadSignState>(
          builder: (context, state) {
            return Column(
              children: [
                // Переключатель режимов
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      context.read<RoadSignBloc>().add(
                        ToggleModeEvent(!state.isQuizMode),
                      );
                    },
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double totalWidth = constraints.maxWidth;
                        final double itemWidth = totalWidth / 2;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width:
                              double.infinity, // тянем на всю доступную ширину
                          height: 50,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Stack(
                            children: [
                              // Сдвигающаяся подсветка
                              AnimatedAlign(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                alignment:
                                    state.isQuizMode
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                child: Container(
                                  width: itemWidth,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                              // Тексты
                              Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        LocaleKeys.listOfSigns.tr(),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color:
                                              !state.isQuizMode
                                                  ? Colors.white
                                                  : Colors.black87,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        LocaleKeys.quiz.tr(),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color:
                                              state.isQuizMode
                                                  ? Colors.white
                                                  : Colors.black87,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Отображение в зависимости от режима
                Expanded(
                  child:
                      state.isQuizMode
                          ? _buildQuizMode(
                            context,
                            state,
                            settingsState.selectedLang,
                          )
                          : _buildListMode(
                            context,
                            state,
                            settingsState.selectedLang,
                          ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Режим викторины
  Widget _buildQuizMode(
    BuildContext context,
    RoadSignState state,
    AppLanguage selectedLanguage,
  ) {
    if (state.signs.isEmpty) {
      return const Center(child: Text('No signs available'));
    }

    final sign = state.signs[state.currentIndex];
    final quiz = sign.quiz[selectedLanguage.code];
    if (quiz == null) {
      return Center(
        child: Text('No quiz available for ${selectedLanguage.code}'),
      );
    }

    final userAnswer = state.userAnswers[sign.id]?[selectedLanguage.code];
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
  }

  // В режиме списка знаков
  Widget _buildListMode(
    BuildContext context,
    RoadSignState state,
    AppLanguage selectedLanguage,
  ) {
    return ListView.builder(
      itemCount: state.signs.length,
      itemBuilder: (context, index) {
        final sign = state.signs[index];
        final quiz = sign.quiz[selectedLanguage.code];
        final title = quiz?.signName ?? 'No title';

        // Получаем ответ пользователя и проверяем его правильность
        final userAnswer = state.userAnswers[sign.id]?[selectedLanguage.code];
        final isAnswered = userAnswer != null;
        final isCorrect = isAnswered && userAnswer == quiz?.correctAnswer;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Изображение знака с обработкой ошибок
                SizedBox(
                  width: 60,
                  height: 60,
                  child:
                      sign.imageUrl != null && sign.imageUrl.isNotEmpty
                          ? Image.network(
                            sign.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 40,
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            },
                          )
                          : const Icon(
                            Icons.error_outline,
                            color: Colors.grey,
                            size: 40,
                          ),
                ),
                const SizedBox(width: 16),

                // Название знака
                Expanded(
                  child: Text(title, style: const TextStyle(fontSize: 16)),
                ),

                // Индикатор ответа
                if (isAnswered)
                  isCorrect
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.close, color: Colors.red),
              ],
            ),
          ),
        );
      },
    );
  }
}
