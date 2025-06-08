import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          // Кнопка "Назад" - показываем всегда, кроме первого вопроса
          if (!isFirstQuestion)
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildPreviousButton(bloc),
              ),
            )
          else
            const Spacer(),

          // Кнопка "Далее" - показываем только при ответе на вопрос
          if (isAnswered)
            Align(
              alignment: Alignment.centerRight,
              child: _buildNextButton(context, bloc),
            ),
        ],
      ),
    );
  }

  Widget _buildPreviousButton(CDLTestsBloc bloc) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      ),
      onPressed: () => bloc.add(PreviousQuestionsEvent()),
      child: const Icon(Icons.arrow_back_ios),
    );
  }

  Widget _buildNextButton(BuildContext context, CDLTestsBloc bloc) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      ),
      onPressed: () {
        if (isLastQuestion) {
          bloc.add(const ResetQuizEvent());
          Navigator.of(context).pop();
        } else {
          bloc.add(const NextQuestionsEvent());
        }
      },
      child: Text(
        isLastQuestion
            ? LocaleKeys.completeTheTest.tr()
            : LocaleKeys.nextQuestion.tr(),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
