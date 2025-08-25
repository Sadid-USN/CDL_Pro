import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/road_sign_bloc/road_sign.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoadSignQuizCard extends StatelessWidget {
  final void Function()? onPressed;
  final RoadSignState state;
  final RoadSignModel sign;
  final QuizModel quiz;
  final String? userAnswer;
  final bool isAnswered;
  final String language;

  const RoadSignQuizCard({
    super.key,
    required this.onPressed,
    required this.state,
    required this.sign,
    required this.quiz,
    required this.userAnswer,
    required this.isAnswered,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final canGoBack = state.currentIndex > 0;
    final canGoNext = isAnswered;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ВЕСЬ ПРОКРУЧИВАЕМЫЙ КОНТЕНТ
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Прогресс ---
                    // --- Прогресс с кнопкой сброса ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Q ${state.currentIndex + 1}/${state.signs.length}",
                          style: AppTextStyles.interBold14,
                        ),
                        TextButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text(LocaleKeys.reset.tr()),
                                    content: Text(
                                      LocaleKeys.startTheQuizOverText.tr(),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: onPressed,
                                        child: Text(LocaleKeys.cancel.tr()),
                                      ),
                                      TextButton(
                                        onPressed: onPressed,
                                        child: Text(LocaleKeys.confirm.tr()),
                                      ),
                                    ],
                                  ),
                            );
                          },
                          icon: const Icon(Icons.refresh, size: 18),
                          label: Text(LocaleKeys.reset.tr()),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // --- Вопрос ---
                    Text(
                      quiz.question,
                      style: AppTextStyles.interBold14.copyWith(
                        color: AppColors.softBlack,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- КАРТИНКА С ОКРУГЛЁННЫМИ КРАЯМИ ---
                    if (sign.imageUrl.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: 1, // квадратный блок под знак
                          child: Image.network(
                            sign.imageUrl,
                            fit: BoxFit.cover,
                            // placeholder во время загрузки
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey.shade200,
                                alignment: Alignment.center,
                                child: const SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            // обработка ошибки
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey.shade200,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 48,
                                  ),
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // --- Варианты ответов ---
                    ...quiz.options.entries.map((entry) {
                      final optionKey = entry.key;
                      final optionText = entry.value;

                      Color bg = Colors.white;
                      if (isAnswered) {
                        if (optionKey == quiz.correctAnswer) {
                          bg = Colors.green.shade200;
                        } else if (optionKey == userAnswer) {
                          bg = Colors.red.shade200;
                        }
                      }

                      return InkWell(
                        onTap:
                            !isAnswered
                                ? () => context.read<RoadSignBloc>().add(
                                  AnswerRoadSignQuestionEvent(
                                    signId: sign.id,
                                    language: language,
                                    selectedOption: optionKey,
                                  ),
                                )
                                : null,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Text('$optionKey. $optionText'),
                        ),
                      );
                    }),

                    // --- Объяснение после ответа ---
                    if (isAnswered) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.explanation.tr(),
                              style: AppTextStyles.merriweatherBold14.copyWith(
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.color,
                              ),
                            ),
                            const SizedBox(width: 8), // небольшой отступ
                            Text(quiz.explanation, softWrap: true),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 12), // нижний отступ для скролла
                  ],
                ),
              ),
            ),

            // ПАНЕЛЬ КНОПОК (НЕ СКРОЛЛИТСЯ)
            Row(
              children: [
                if (canGoBack)
                  ElevatedButton(
                    onPressed:
                        () => context.read<RoadSignBloc>().add(
                          PreviousSignEvent(),
                        ),
                    child: Text(LocaleKeys.previous.tr()),
                  ),
                if (!canGoBack) const SizedBox(width: 0),

                const Spacer(),

                if (canGoNext)
                  ElevatedButton(
                    onPressed:
                        () => context.read<RoadSignBloc>().add(NextSignEvent()),
                    child: Text(LocaleKeys.next.tr()),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
