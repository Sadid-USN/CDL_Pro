import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColorDark,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '$questionNumber ${LocaleKeys.outOf.tr()} $allQuestions/',
                    style: AppTextStyles.robotoMono16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$incorrectCount',
                    style: AppTextStyles.robotoMono16.copyWith(
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    '/$correctCount',
                    style: AppTextStyles.robotoMono16.copyWith(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              const ResetButton(),
            ],
          ),
          SizedBox(height: 5.h,),

          Padding(
            padding:  EdgeInsets.only(right: 8.w),
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: progress.toDouble(), end: progress.toDouble()),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: AppColors.subtleBlack,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.simpleGreen),
                  minHeight: 6.h,
                  borderRadius: BorderRadius.circular(4.r),
                );
              },
            ),
          ),
        
        
        ],
      ),
    );
  }
}
