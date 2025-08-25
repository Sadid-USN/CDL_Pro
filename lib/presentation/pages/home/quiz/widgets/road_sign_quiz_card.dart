import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/road_sign_bloc/road_sign.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                          bg = AppColors.errorColor;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ElevatedButton(
                          onPressed:
                              !isAnswered
                                  ? () => context.read<RoadSignBloc>().add(
                                    AnswerRoadSignQuestionEvent(
                                      signId: sign.id,
                                      language: language,
                                      selectedOption: optionKey,
                                    ),
                                  )
                                  : null,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(bg),
                            elevation: WidgetStateProperty.all(0),
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.all(12),
                            ),

                            minimumSize: WidgetStateProperty.all(
                              Size(MediaQuery.sizeOf(context).width, 48),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          child: Text(
                            '$optionKey. $optionText',
                            style: AppTextStyles.interBold12.copyWith(
                              color: AppColors.softBlack,
                            ),
                          ),
                        ),
                      );
                    }),
                    // --- Объяснение после ответа ---
                    if (isAnswered) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.explanation.tr(),
                              style: AppTextStyles.interBold12.copyWith(
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.color,
                              ),
                            ),
                            const SizedBox(height: 8), // небольшой отступ
                            Text(
                              quiz.explanation,
                              style: AppTextStyles.interBold12.copyWith(
                                height: 1.5,
                              ),

                              softWrap: true,
                            ),
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
