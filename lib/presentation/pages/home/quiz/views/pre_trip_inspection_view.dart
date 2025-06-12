import 'package:cdl_pro/core/themes/themes.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreTripInspectionView extends StatefulWidget {
  final List<QueryDocumentSnapshot> docs;

  const PreTripInspectionView({super.key, required this.docs});

  @override
  State<PreTripInspectionView> createState() => _PreTripInspectionViewState();
}

class _PreTripInspectionViewState extends State<PreTripInspectionView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedLang = context.select<SettingsBloc, AppLanguage>(
      (bloc) => bloc.state.selectedLang,
    );

    final data = widget.docs.first.data() as Map<String, dynamic>;
    final model = PreTripInspectionListModel.fromJson(data);

    // Собираем все правила с сохранением индексов секций и элементов
    final allItems = <Map<String, dynamic>>[];
    for (
      int sectionIndex = 0;
      sectionIndex < model.preTripInspection.length;
      sectionIndex++
    ) {
      final section = model.preTripInspection[sectionIndex];
      final title = section.content.first;

      for (int i = 1; i < section.content.length; i++) {
        allItems.add({
          'sectionIndex': sectionIndex,
          'itemIndex': i,
          'titleEn': title.enTitle,
          'titleTranslated': switch (selectedLang) {
            AppLanguage.russian => title.ruTitle,
            AppLanguage.ukrainian => title.ukTitle,
            AppLanguage.spanish => title.esTitle,
            _ => null,
          },
        });
      }
    }

    final totalPages = (allItems.length / 4).ceil();

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: totalPages,
            controller: PageController(initialPage: currentIndex),
            onPageChanged: (index) => setState(() => currentIndex = index),
            itemBuilder: (context, pageIndex) {
              final pageItems = allItems.skip(pageIndex * 4).take(4).toList();
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: ListView.builder(
                  itemCount: pageItems.length,
                  itemBuilder: (context, index) {
                    final itemData = pageItems[index];
                    final section =
                        model.preTripInspection[itemData['sectionIndex']];
                    final item = section.content[itemData['itemIndex']];

                    String? translatedText;
                    switch (selectedLang) {
                      case AppLanguage.russian:
                        translatedText = item.ruText;
                        break;
                      case AppLanguage.ukrainian:
                        translatedText = item.ukText;
                        break;
                      case AppLanguage.spanish:
                        translatedText = item.esText;
                        break;
                      default:
                        translatedText = null;
                    }

                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemData['titleEn'] ?? '',
                              style: AppTextStyles.merriweatherBold12,
                            ),

                            if (itemData['titleTranslated'] != null)
                              Text(
                                itemData['titleTranslated'],
                                style: AppTextStyles.merriweatherBold12,
                              ),

                            SizedBox(height: 8.h),
                            Text(
                              item.enText ?? '',
                              style: AppTextStyles.merriweather12,
                            ),
                            SizedBox(height: 8.h),
                            if (selectedLang == AppLanguage.russian &&
                                (item.pronunciation?.trim().isNotEmpty ??
                                    false))
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  item.pronunciation!,
                                  style: AppTextStyles.merriweather12.copyWith(
                                    color: Colors.grey.shade900,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            SizedBox(height: 8.h),
                            if (translatedText != null)
                              Text(
                                translatedText,
                                style: AppTextStyles.merriweather12,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            totalPages,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: CircleAvatar(
                radius: currentIndex == index ? 10 : 6,
                backgroundColor:
                    currentIndex == index ? AppColors.darkPrimary : Colors.grey,
              ),
            ),
          ),
        ),
        SizedBox(height: 50.h),
      ],
    );
  }
}
