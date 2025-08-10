import 'dart:convert';
import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuildProgressIndicator extends StatelessWidget {
  final String subcategory;
  final List<Question> questions;
  final String categoryKey;

  const BuildProgressIndicator({
    super.key,
    required this.subcategory,
    required this.questions,
    required this.categoryKey,
  });

  @override
  Widget build(BuildContext context) {
    final userHolder = GetIt.I<UserHolder>();
    final cdlTestsBloc = context.read<CDLTestsBloc>();

    if (userHolder.uid == null) {
      return SizedBox.shrink();
    }

    final quizId = cdlTestsBloc.generateQuizIdForQuestions(
      questions,
      subcategory,
    );
    final baseKey = '${userHolder.uid}_${subcategory}_$quizId';

    final prefs = GetIt.I<SharedPreferences>();
    final hasProgress = prefs.containsKey('${baseKey}_currentPage');

    if (!hasProgress) {
      return SizedBox.shrink();
    }

    final answersString = prefs.getString('${baseKey}_userAnswers');
    if (answersString == null) {
      return SizedBox.shrink();
    }

    final userAnswers = Map<String, String>.from(jsonDecode(answersString));
    final totalQuestions = questions.length;
    final correctCount =
        questions
            .where((q) => userAnswers[q.question] == q.correctOption)
            .length;
    final wrongCount = userAnswers.length - correctCount;

    if (correctCount == 0 && wrongCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.grey.shade200,
      ),
      height: 25,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: '🕗 ', style: AppTextStyles.robotoMono10),
            TextSpan(
              text: '$totalQuestions / ',
              style: AppTextStyles.robotoMono10,
            ),
            TextSpan(
              text: '$wrongCount ',
              style: AppTextStyles.robotoMono10.copyWith(color: Colors.red),
            ),
            TextSpan(text:'/', style: AppTextStyles.robotoMono10),
            TextSpan(
              text: ' $correctCount',
              style: AppTextStyles.robotoMono10.copyWith(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
