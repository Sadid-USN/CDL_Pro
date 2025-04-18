import 'package:cdl_pro/core/constants/constants.dart';
import 'package:cdl_pro/core/themes/themes.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    return ListView.builder(
      itemCount: chapters.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final chapter = chapters[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _CategoryCard(
            index: index + 1,
            title: chapter.title,
            totalQuestions: chapter.total,
            freeQuestions: chapter.freeLimit,
            onTap: () {
              // _navigateToTestPage(context, chapter.key);
            },
          ),
        );
      },
    );
  }
}

// Расширение для Chapters, которое преобразует свойства в список
extension ChaptersExtension on Chapters {
  List<ChapterItem> toChapterList(BuildContext context) {
    return [
      ChapterItem(
        key: 'general_knowledge',
        title: LocaleKeys.generalKnowledge.tr(),
        total: generalKnowledge.total,
        freeLimit: generalKnowledge.freeLimit,
      ),
      ChapterItem(
        key: 'combination',
        title: LocaleKeys.combination.tr(),
        total: combination.total,
        freeLimit: combination.freeLimit,
      ),
      ChapterItem(
        key: 'airBrakes',
        title: LocaleKeys.airBrakes.tr(),
        total: airBrakes.total,
        freeLimit: airBrakes.freeLimit,
      ),
      ChapterItem(
        key: 'tanker',
        title: LocaleKeys.tanker.tr(),
        total: tanker.total,
        freeLimit: tanker.freeLimit,
      ),
      ChapterItem(
        key: 'doubleAndTriple',
        title: LocaleKeys.doubleAndTriple.tr(),
        total: doubleAndTriple.total,
        freeLimit: doubleAndTriple.freeLimit,
      ),
      ChapterItem(
        key: 'hazMat',
        title: LocaleKeys.hazMat.tr(),
        total: hazMat.total,
        freeLimit: hazMat.freeLimit,
      ),
    ];
  }
}

// Модель для представления главы
class ChapterItem {
  final String key;
  final String title;
  final int total;
  final int freeLimit;

  ChapterItem({
    required this.key,
    required this.title,
    required this.total,
    required this.freeLimit,
  });
}

class _CategoryCard extends StatelessWidget {
  final int index;
  final String title;
  final int totalQuestions;
  final int freeQuestions;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.index,
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
          image: AssetImage(AppLogos.generalKnowlage),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$index $title",
                style: AppTextStyles.regular16.copyWith(
                  color: AppColors.lightBackground,
                ),
              ),
              const SizedBox(height: 8),
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
          if (premium) SvgPicture.asset(AppLogos.premium, height: 15.h,
           colorFilter: ColorFilter.mode(
              AppColors.goldenSoft,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 4.w),
          // Подстрой цвет под фон
          SizedBox(width: 4.w),
          Text(text, style: AppTextStyles.robotoMono10.copyWith(color: AppColors.lightBackground)),
        ],
      ),
      side: BorderSide.none,
      // padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
