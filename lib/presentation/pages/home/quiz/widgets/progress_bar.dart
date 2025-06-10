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
      child: Row(
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
                style: AppTextStyles.robotoMono16.copyWith(color: Colors.red),
              ),
              Text(
                '/$correctCount',
                style: AppTextStyles.robotoMono16.copyWith(color: Colors.green),
              ),
            ],
          ),

          const ResetButton(),
        ],
      ),
    );
  }
}
