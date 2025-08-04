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
        return '$localizedKey $englishTitle';
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
    return Material(
      elevation: 1.5,
      borderRadius: BorderRadius.circular(100.r), // Circular shape
      child: InkWell(
        borderRadius: BorderRadius.circular(100.r),
        onTap: onTap,
        child: Container(
          height: 100.h, // Match the height of ElevatedContainer
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.greyshade400, AppColors.lightPrimary],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
        
              Container(
                margin: EdgeInsets.only(left: 10.w, right: 10.w),
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.white, width: 2.w),
                ),
              ),

             SizedBox(width: 10.w,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: AppTextStyles.merriweather14.copyWith(
                        color: AppColors.lightBackground,
                      ),
                    ),
                
                    SizedBox(height: 10.h),
                
                    // Chips row
                    Row(
                      children: [
                        _buildInfoChip(
                          premium: true,
                          LocaleKeys.total.tr(
                            namedArgs: {"totalQuestions": "$totalQuestions"},
                          ),
                          AppColors.black54
                        ),
                        SizedBox(width: 5.w),
                        _buildInfoChip(
                          LocaleKeys.free.tr(
                            namedArgs: {"freeQuestions": "$freeQuestions"},
                          ),
                       AppColors.black54
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10.w),
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
              height: 12.h,
              colorFilter: ColorFilter.mode(
                AppColors.goldenSoft,
                BlendMode.srcIn,
              ),
            ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: AppTextStyles.bold8.copyWith(
              color: AppColors.lightBackground,
            ),
          ),
        ],
      ),
      side: BorderSide.none,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
