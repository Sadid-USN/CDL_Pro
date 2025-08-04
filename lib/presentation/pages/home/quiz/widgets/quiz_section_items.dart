import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/quiz.dart';
import 'package:cdl_pro/router/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class QuizSectionItems extends StatelessWidget {
  final bool isPremium;
  final String title;
  final String categoryKey;
  final Map<String, dynamic> questionsMap;
  final int totalQuestions;
  final List<CardItem> cards;
  final int index;
  final TestsDataModel model;
  final BuildContext context;

  const QuizSectionItems({
    super.key,
    required this.isPremium,
    required this.title,
    required this.categoryKey,
    required this.questionsMap,
    required this.totalQuestions,
    required this.cards,
    required this.index,
    required this.model,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    if (index == cards.length) {
      return _buildAllQuestionsItem();
    }
    return _buildQuestionRangeItem();
  }

  Widget _buildAllQuestionsItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.greyshade400, AppColors.lightPrimary],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(60.r),
          onTap: () {
            if (isPremium) {
              final questions = _getQuestionsForRange(1, totalQuestions);
              _navigateToQuiz(questions, 1);
            } else {
              _showPremiumSheet();
            }
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Text(
                  "#$totalQuestions",
                  style: AppTextStyles.robotoMonoBold12.copyWith(
                    color: AppColors.lightBackground,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.allQuestions.tr(),
                        style: AppTextStyles.regular16.copyWith(
                          color: AppColors.lightBackground,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '1-$totalQuestions',
                        style: AppTextStyles.robotoMono10.copyWith(
                          color: AppColors.lightBackground,
                        ),
                      ),
                    ],
                  ),
                ),
                !isPremium
                    ? SvgPicture.asset(
                      AppLogos.lockClosed,
                      height: 25.h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.lightBackground,
                        BlendMode.srcIn,
                      ),
                    )
                    : Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.lightBackground,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionRangeItem() {
    final card = cards[index];
    final questions = _getQuestionsForRange(card.startIndex, card.endIndex);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.greyshade400, AppColors.lightPrimary],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(60.r),
          onTap: () {
            if (!card.isLocked) {
              _navigateToQuiz(questions, card.startIndex);
            } else {
              _showPremiumSheet();
            }
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Text(
                  '#${index + 1}',
                  style: AppTextStyles.robotoMono12.copyWith(
                    color: AppColors.lightBackground,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title,
                        style: AppTextStyles.regular16.copyWith(
                          color: AppColors.lightBackground,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                            card.range,
                            style: AppTextStyles.robotoMono10.copyWith(
                              color: AppColors.lightBackground,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          BuildProgressIndicator(
                            subcategory: categoryKey,
                            questions: questions,
                            categoryKey: categoryKey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                card.isLocked
                    ? SvgPicture.asset(
                      AppLogos.lockClosed,
                      height: 25.h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.lightBackground,
                        BlendMode.srcIn,
                      ),
                    )
                    : Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.lightBackground,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Question> _getQuestionsForRange(int startIndex, int endIndex) {
    final questionIds = questionsMap.keys.toList();
    final limitedIds = questionIds.sublist(startIndex - 1, endIndex);
    return limitedIds.map((id) {
      final questionData = questionsMap[id];
      if (questionData is Map<String, dynamic>) {
        return Question.fromJson(questionData, key: '');
      } else if (questionData is Question) {
        return questionData;
      }
      throw Exception('Invalid question data format for id $id');
    }).toList();
  }

  void _navigateToQuiz(List<Question> questions, int startIndex) {
    navigateToPage(
      context,
      route: QuizRoute(
        chapterTitle: title,
        startIndex: startIndex,
        questions: questions,
        categoryKey: categoryKey,
        model: model,
      ),
      replace: true,
    );
  }

  void _showPremiumSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PremiumBottomSheet(),
    );
  }
}
