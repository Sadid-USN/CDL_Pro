import 'package:cdl_pro/core/themes/themes.dart';
import 'package:cdl_pro/core/utils/navigation_utils.dart';
import 'package:cdl_pro/domain/models/tests_data_model.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:cdl_pro/router/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NextBackButtons extends StatelessWidget {
  final bool isFirstQuestion;
  final bool isLastQuestion;
  final bool isAnswered;

  // Навигационные параметры
  final String chapterTitle;
  final String categoryKey;
  final TestsDataModel model;

  // Добавляем все вопросы и ответы пользователя
  final List<Question> allQuestions;
  final Map<String, String> userAnswers;

  const NextBackButtons({
    super.key,
    required this.isFirstQuestion,
    required this.isLastQuestion,
    required this.isAnswered,
    required this.chapterTitle,
    required this.categoryKey,
    required this.model,
    required this.allQuestions,
    required this.userAnswers,
  });

  int _countWrongAnswers() {
    int wrong = 0;
    for (var question in allQuestions) {
      final answer = userAnswers[question.question];
      if (answer != null && answer != question.correctOption) {
        wrong++;
      }
    }
    return wrong;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CDLTestsBloc>();

    return Padding(
      padding: EdgeInsets.only(bottom: 40.h, right: 12.w, left: 12.w),
      child: Row(
        children: [
          // Кнопка "Назад"
          if (!isFirstQuestion)
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                  onPressed: () => bloc.add(PreviousQuestionsEvent()),
                  child: const Icon(Icons.arrow_back_ios),
                ),
              ),
            )
          else
            const Spacer(),

          // Кнопка "Далее/Завершить"
          if (isAnswered)
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  _handleNextPressed(context, bloc);
                },
                child: Text(
                  isLastQuestion
                      ? LocaleKeys.completeTheTest.tr()
                      : LocaleKeys.nextQuestion.tr(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleNextPressed(BuildContext context, CDLTestsBloc bloc) {
    if (isLastQuestion) {
      _showResultsDialog(context, bloc);
    } else {
      bloc.add(const NextQuestionsEvent());
    }
  }

  void _showResultsDialog(BuildContext context, CDLTestsBloc bloc) {
    final total = allQuestions.length;
    final wrong = _countWrongAnswers();
    final errorRate = total > 0 ? wrong / total : 0;
    final passed = errorRate <= 0.1; // Прошел, если ошибок ≤ 10%

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
              scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      passed
                          ? Icons.emoji_events_rounded
                          : Icons.error_outline_rounded,
                      size: 70.sp,
                      color: passed ? AppColors.simpleGreen : AppColors.errorColor,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      passed
                          ? LocaleKeys.congratulations.tr()
                          : LocaleKeys.sorryYouFailed.tr(),
                      style: passed
                          ? AppTextStyles.merriweatherBold16.copyWith(
                              color: AppColors.simpleGreen,
                            )
                          : AppTextStyles.merriweatherBold16.copyWith(
                              color: AppColors.errorColor,
                            ),
                      textAlign: TextAlign.center,
                    ),
                    if (!passed) ...[
                      SizedBox(height: 8.h),
                      Text(
                        LocaleKeys.youNeedMorePractice.tr(),
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.greyshade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    SizedBox(height: 20.h),
                    _buildResultRow(
                      LocaleKeys.totalQuestions.tr(),
                      total.toString(),
                      AppColors.softBlack,
                    ),
                    _buildResultRow(
                      LocaleKeys.correctAnswers.tr(),
                      (total - wrong).toString(),
                      AppColors.simpleGreen,
                    ),
                    _buildResultRow(
                      LocaleKeys.wrongAnswers.tr(),
                      wrong.toString(),
                      AppColors.errorColor,
                    ),
                    SizedBox(height: 24.h),

                    // Кнопка "Work on Mistakes"
                    if (!passed && errorRate > 0.1)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final mistakeQuestions = allQuestions.where((q) {
                              final ans = userAnswers[q.question];
                              return ans != null && ans != q.correctOption;
                            }).toList();

                            if (mistakeQuestions.isEmpty) return;

                            navigateToPage(
                              context,
                              route: QuizRoute(
                                chapterTitle: chapterTitle,
                                questions: mistakeQuestions,
                                startIndex: 0,
                                categoryKey: categoryKey,
                                model: model,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.errorColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Text(
                            LocaleKeys.workOnMistakes.tr(),
                            style: AppTextStyles.bold12.copyWith(
                              color: AppColors.lightBackground,
                            ),
                          ),
                        ),
                      ),

                    SizedBox(height: 12.h),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              bloc.add(const ResetQuizEvent());
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lightPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            child: Text(
                              LocaleKeys.startAgain.tr(),
                              style: AppTextStyles.bold12.copyWith(
                                color: AppColors.lightBackground,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              bloc.add(ResetQuizEvent());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lightPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            child: Text(
                              LocaleKeys.returnToHome.tr(),
                              style: AppTextStyles.bold12.copyWith(
                                color: AppColors.lightBackground,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }

  Widget _buildResultRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.regular12),
          Text(
            value,
            style: AppTextStyles.robotoMonoBold12.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
