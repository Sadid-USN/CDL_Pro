import 'package:cdl_pro/core/constants/constants.dart';
import 'package:cdl_pro/core/themes/themes.dart';
import 'package:cdl_pro/core/utils/navigation_utils.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/router/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';

class CDLTestsView extends StatelessWidget {
  final List<QueryDocumentSnapshot> docs;

  const CDLTestsView({super.key, required this.docs});

  @override
  Widget build(BuildContext context) {
    if (docs.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final data = docs.first.data() as Map<String, dynamic>;
    final model = TestsDataModel.fromJson(data);

    // Создаем список глав с помощью метода расширения
    final chapters = model.chapters.toChapterList(context);

    return AnimationLimiter(
      child: ListView.builder(
        itemCount: chapters.length,
        padding: EdgeInsets.only(right: 8.w, left: 8.w, top: 8.w, bottom: 25.h),
      
        itemBuilder: (context, index) {
          final chapter = chapters[index];
      
          return AnimationConfiguration.staggeredList(
             position: index,
                duration: const Duration(milliseconds: 600),
            child: FlipAnimation(
              child: Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: _CategoryCard(
                  image: chapter.image,
                  title: chapter.title,
                  totalQuestions: chapter.total,
                  freeQuestions: chapter.freeLimit,
                  onTap: () {
                    navigateToPage(
                      context,
                      route: OverviewCategoryRoute(
                        categoryKey: chapter.key,
                        model: model,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Расширение для Chapters, которое преобразует свойства в список
extension ChaptersExtension on Chapters {
  List<ChapterItem> toChapterList(BuildContext context) {
    String getLocalizedTitle(
      BuildContext context,
      String localizedKey,
      String englishTitle,
    ) {
      final currentLocale = context.locale.languageCode;
      if (currentLocale == 'en') {
        return localizedKey;
      } else {
        return '$localizedKey\n$englishTitle';
      }
    }

    return [
      ChapterItem(
        image: AppLogos.generalKnowlage,
        key: 'general_knowledge',
        title: getLocalizedTitle(
          context,
          LocaleKeys.generalKnowledge.tr(),
          'GeneralKnowledge',
        ),
        total: generalKnowledge.total,
        freeLimit: generalKnowledge.freeLimit,
      ),
      ChapterItem(
        image: AppLogos.combination,
        key: 'combination',
        title: getLocalizedTitle(
          context,
          LocaleKeys.combination.tr(),
          "Combination",
        ),

        total: combination.total,
        freeLimit: combination.freeLimit,
      ),
      ChapterItem(
        image: AppLogos.airbrake,
        key: 'airBrakes',
        title: getLocalizedTitle(
          context,
          LocaleKeys.airBrakes.tr(),
          'AirBrakes',
        ),
        total: airBrakes.total,
        freeLimit: airBrakes.freeLimit,
      ),
      ChapterItem(
        image: AppLogos.tanker,
        key: 'tanker',
        title: getLocalizedTitle(context, LocaleKeys.tanker.tr(), 'Tanker'),
        total: tanker.total,
        freeLimit: tanker.freeLimit,
      ),
      ChapterItem(
        image: AppLogos.doubleAndTriple,
        key: 'doubleAndTriple',
        title: getLocalizedTitle(
          context,
          LocaleKeys.doubleAndTriple.tr(),
          'Double&Triple',
        ),
        total: doubleAndTriple.total,
        freeLimit: doubleAndTriple.freeLimit,
      ),
      ChapterItem(
        image: AppLogos.hazMat,
        key: 'hazMat',
        title: getLocalizedTitle(context, LocaleKeys.hazMat.tr(), 'HazMat'),
        total: hazMat.total,
        freeLimit: hazMat.freeLimit,
      ),
    ];
  }
}

// Модель для представления главы
class ChapterItem {
  final String image;
  final String key;
  final String title;
  final int total;
  final int freeLimit;

  ChapterItem({
    required this.image,
    required this.key,
    required this.title,
    required this.total,
    required this.freeLimit,
  });
}

class _CategoryCard extends StatelessWidget {
  final String image;
  final String title;
  final int totalQuestions;
  final int freeQuestions;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.image,

    required this.title,
    required this.totalQuestions,
    required this.freeQuestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.5),
            BlendMode.darken, // или multiply, overlay и др.
          ),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style: AppTextStyles.regular16.copyWith(
                  color: AppColors.lightBackground,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildInfoChip(
                    premium: true,
                    LocaleKeys.total.tr(
                      namedArgs: {"totalQuestions": "$totalQuestions"},
                    ),

                    // 'Total: $totalQuestions'
                    AppColors.darkBackground,
                  ),
                  SizedBox(width: 5.w),
                  _buildInfoChip(
                    LocaleKeys.free.tr(
                      namedArgs: {"freeQuestions": "$freeQuestions"},
                    ),
                    AppColors.darkPrimary,

                    // 'Free: $freeQuestions',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color, {bool premium = false}) {
    return Chip(
      backgroundColor: color,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (premium)
            SvgPicture.asset(
              AppLogos.premium,
              height: 15.h,
              colorFilter: ColorFilter.mode(
                AppColors.goldenSoft,
                BlendMode.srcIn,
              ),
            ),

          // Подстрой цвет под фон
          SizedBox(width: 4.w),
          Text(
            text,
            style: AppTextStyles.robotoMono10.copyWith(
              color: AppColors.lightBackground,
            ),
          ),
        ],
      ),
      side: BorderSide.none,
      // padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
