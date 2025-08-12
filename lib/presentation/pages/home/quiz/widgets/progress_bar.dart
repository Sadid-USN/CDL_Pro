import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressBar extends StatelessWidget {
  final int questionNumber;
  final int allQuestions;
  final int incorrectCount;
  final int correctCount;

  const ProgressBar({
    super.key,
    required this.questionNumber,
    required this.allQuestions,
    required this.incorrectCount,
    required this.correctCount,
  });

  @override
  Widget build(BuildContext context) {
    final progress = allQuestions > 0 ? (questionNumber - 1) / allQuestions : 0;
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.only(left: 8.w, bottom: 2.h, top: 2.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
      child: StreamBuilder(
        stream: context.read<CDLTestsBloc>().timerStream,
        initialData: Duration.zero,
        builder: (context, snapshot) {
          final elapsedTime = snapshot.data ?? Duration.zero;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //${LocaleKeys.outOf.tr()}
                  //Text('Q ', style: AppTextStyles.manropeBold14),
                  Text(
                    'Q $questionNumber/$allQuestions',
                    style: AppTextStyles.manropeBold14,
                  ),

                  Text(
                    DateFormatters.formatDuration(elapsedTime),
                    style: AppTextStyles.robotoMonoBold14,
                  ),

                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          color: AppColors.simpleGreen.withValues(alpha: 0.5), // фон
                          borderRadius: BorderRadius.circular(
                            90,
                          ), // делает форму "пилюли"
                        ),
                        child: Text(
                          '$correctCount',
                          style: AppTextStyles.robotoMonoBold14.copyWith(
                            color: AppColors.lightBackground,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w,),
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          color: AppColors.errorColor..withValues(alpha: 0.2), // фон
                          borderRadius: BorderRadius.circular(
                            90,
                          ), // делает форму "пилюли"
                        ),
                        child: Text(
                          '$incorrectCount',
                          style: AppTextStyles.robotoMonoBold14.copyWith(
                            color: AppColors.lightBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5.h),

              TweenAnimationBuilder(
                tween: Tween<double>(
                  begin: progress.toDouble(),
                  end: progress.toDouble(),
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: AppColors.subtleBlack,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.simpleGreen,
                    ),
                    minHeight: 4.h,
                    borderRadius: BorderRadius.circular(4.r),
                  );
                },
              ),

              SizedBox(height: 5.h),
            ],
          );
        },
      ),
    );
  }
}
