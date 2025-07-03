import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/purchase/purchase.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/widgets/widgets.dart';
import 'package:cdl_pro/router/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class OverviewCategoryPage extends StatefulWidget {
  final String? categoryKey;
  final TestsDataModel? model;

  const OverviewCategoryPage({
    super.key,
    required this.categoryKey,
    required this.model,
  });

  @override
  State<OverviewCategoryPage> createState() => _OverviewCategoryPageState();
}

class _OverviewCategoryPageState extends State<OverviewCategoryPage> {
  @override
  void initState() {
    context.read<PurchaseBloc>().add(CheckPastPurchases());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final category = _getCategoryByKey(
      widget.model!.chapters,
      widget.categoryKey!,
    );
    if (category == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error'), centerTitle: true),
        body: const Center(child: Text('Category not found')),
      );
    }

    final title = _getLocalizedTitle(widget.categoryKey!);
    final questionsMap = category.questions as Map<String, dynamic>;
    final totalQuestions = questionsMap.length;
    final freeLimit = category.freeLimit;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.router.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Text(title, style: AppTextStyles.merriweatherBold12),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<PurchaseBloc, PurchaseState>(
        builder: (context, purchaseState) {
          final isPremium = purchaseState is PurchaseSuccess;

          final cards = _generateCardItems(
            title,
            totalQuestions,
            freeLimit,
            isPremium,
          );

          return (purchaseState is PremiumLoading)
              ? Center(
                child: Lottie.asset(
                  "assets/lottie/truck_loader.json",
                  height: 70.h,
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.only(bottom: 50.h),
                itemCount: cards.length + 1,
                itemBuilder: (context, index) {
                  if (index == cards.length) {
                    return Card(
                      child: ListTile(
                        leading: Text(
                          "#$totalQuestions",
                          style: AppTextStyles.robotoMonoBold12,
                        ),
                        title: Text(LocaleKeys.allQuestions.tr()),
                        subtitle: Text(
                          '1-$totalQuestions',
                          style: AppTextStyles.robotoMono10,
                        ),
                        trailing:
                            !isPremium
                                ? SvgPicture.asset(
                                  AppLogos.lockClosed,
                                  height: 25.h,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.softBlack,
                                    BlendMode.srcIn,
                                  ),
                                )
                                : const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          if (isPremium) {
                            navigateToPage(
                              context,
                              route: QuizRoute(
                                chapterTitle: title,
                                startIndex: 1,
                                questions: _getQuestionsForRange(
                                  questionsMap,
                                  1,
                                  totalQuestions,
                                ),
                                categoryKey: widget.categoryKey!,
                                model: widget.model!,
                              ),
                              replace: true,
                            );
                          } else {
                            _showPremiumSheet(context);
                          }
                        },
                      ),
                    );
                  }

                  final card = cards[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Text(
                        '#${index + 1}',
                        style: AppTextStyles.robotoMono12,
                      ),
                      title: Text(card.title),
                      subtitle: Text(
                        card.range,
                        style: AppTextStyles.robotoMono10,
                      ),
                      trailing:
                          card.isLocked
                              ? SvgPicture.asset(
                                AppLogos.lockClosed,
                                height: 25.h,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.lightPrimary,
                                  BlendMode.srcIn,
                                ),
                              )
                              : const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        if (!card.isLocked) {
                          navigateToPage(
                            context,
                            route: QuizRoute(
                              chapterTitle: title,
                              startIndex: card.startIndex,
                              questions: _getQuestionsForRange(
                                questionsMap,
                                card.startIndex,
                                card.endIndex,
                              ),
                              categoryKey: widget.categoryKey!,
                              model: widget.model!,
                            ),
                            replace: true,
                          );
                        } else {
                          _showPremiumSheet(context);
                        }
                      },
                    ),
                  );
                },
              );
        },
      ),
    );
  }

  List<Question> _getQuestionsForRange(
    Map<String, dynamic> questionsMap,
    int startIndex,
    int endIndex,
  ) {
    final questionIds = questionsMap.keys.toList();
    final limitedIds = questionIds.sublist(startIndex - 1, endIndex);
    return limitedIds.map((id) {
      final questionData = questionsMap[id];
      if (questionData is Map<String, dynamic>) {
        return Question.fromJson(questionData);
      } else if (questionData is Question) {
        return questionData;
      } else {
        throw Exception('Invalid question data format for id $id');
      }
    }).toList();
  }

  dynamic _getCategoryByKey(Chapters chapters, String key) {
    switch (key) {
      case 'general_knowledge':
        return chapters.generalKnowledge;
      case 'combination':
        return chapters.combination;
      case 'airBrakes':
        return chapters.airBrakes;
      case 'tanker':
        return chapters.tanker;
      case 'doubleAndTriple':
        return chapters.doubleAndTriple;
      case 'hazMat':
        return chapters.hazMat;
      default:
        return null;
    }
  }

  String _getLocalizedTitle(String key) {
    switch (key) {
      case 'general_knowledge':
        return LocaleKeys.generalKnowledge.tr();
      case 'combination':
        return LocaleKeys.combination.tr();
      case 'airBrakes':
        return LocaleKeys.airBrakes.tr();
      case 'tanker':
        return LocaleKeys.tanker.tr();
      case 'doubleAndTriple':
        return LocaleKeys.doubleAndTriple.tr();
      case 'hazMat':
        return LocaleKeys.hazMat.tr();
      default:
        return key;
    }
  }

  void _showPremiumSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PremiumBottomSheet(),
    );
  }

  List<CardItem> _generateCardItems(
    String title,
    int total,
    int freeLimit,
    bool isPremium,
  ) {
    final int chunkSize = freeLimit;
    final int chunkCount = (total / chunkSize).ceil();
    return List.generate(chunkCount, (index) {
      final start = index * chunkSize + 1;
      final end = ((index + 1) * chunkSize).clamp(0, total);
      final isLocked = !isPremium && index != 0;
      return CardItem(
        title: title,
        range: '$start–$end',
        isLocked: isLocked,
        startIndex: start,
        endIndex: end,
      );
    });
  }
}

class CardItem {
  final String title;
  final String range;
  final bool isLocked;
  final int startIndex;
  final int endIndex;

  CardItem({
    required this.title,
    required this.range,
    required this.isLocked,
    required this.startIndex,
    required this.endIndex,
  });
}
