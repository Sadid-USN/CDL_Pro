import 'package:cdl_pro/core/themes/themes.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NextBackButtons extends StatelessWidget {
  final bool isFirstQuestion;
  final bool isLastQuestion;
  final bool isAnswered;

  const NextBackButtons({
    super.key,
    required this.isFirstQuestion,
    required this.isLastQuestion,
    required this.isAnswered,
  });

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
    final results = bloc.calculateResults();
    final passed = results['passed'] as bool;

    Alert(
      context: context,
      type: passed ? AlertType.success : AlertType.error,
      title:
          passed
              ? LocaleKeys.congratulations.tr()
              : LocaleKeys.sorryYouFailed.tr(),
      style: AlertStyle(
        titleStyle:
            results['passed']
                ? AppTextStyles.merriweather12
                : AppTextStyles.merriweather12.copyWith(
                  color: AppColors.errorColor,
                ),
        descStyle: AppTextStyles.regular12,
      ),
      desc: results['passed'] ? '' : LocaleKeys.youNeedMorePractice.tr(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            '${LocaleKeys.totalQuestions.tr()}: ${results['total']}',
            style: AppTextStyles.merriweatherBold12,
          ),
          Text(
            '${LocaleKeys.correctAnswers.tr()}: ${results['correct']}',
            style: AppTextStyles.regular12.copyWith(
              color: AppColors.simpleGreen,
            ),
          ),
          Text(
            '${LocaleKeys.wrongAnswers.tr()}: ${results['wrong']}',
            style: AppTextStyles.regular12.copyWith(
              color: AppColors.errorColor,
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            bloc.add(const ResetQuizEvent());
            Navigator.of(context).pop();
          },
          color: AppColors.lightPrimary,
          child: Text(
            LocaleKeys.startAgain.tr(),
            style: AppTextStyles.merriweather10.copyWith(
              color: AppColors.lightBackground,
            ),
          ),
        ),
        DialogButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            context.read<CDLTestsBloc>().add(ResetQuizEvent());
          },
          color: AppColors.lightPrimary,
          child: Text(
            LocaleKeys.returnToHome.tr(),
            style: AppTextStyles.merriweather10.copyWith(
              color: AppColors.lightBackground,
            ),
          ),
        ),
      ],
    ).show();
  }
}
