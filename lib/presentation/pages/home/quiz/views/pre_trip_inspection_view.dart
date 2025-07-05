import 'package:cdl_pro/core/themes/themes.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    // Собираем все шаги с привязкой к главам
    final allItems = <Map<String, dynamic>>[];
    for (
      int chapterIndex = 0;
      chapterIndex < model.preTripInspection.length;
      chapterIndex++
    ) {
      final chapter = model.preTripInspection[chapterIndex];
      for (int stepIndex = 0; stepIndex < chapter.steps.length; stepIndex++) {
        allItems.add({
          'chapterIndex': chapterIndex,
          'stepIndex': stepIndex,
          'chapterTitle': chapter.chapterTitle,
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
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ListView.builder(
                  itemCount: pageItems.length,
                  itemBuilder: (context, index) {
                    final itemData = pageItems[index];
                    final chapter =
                        model.preTripInspection[itemData['chapterIndex']];
                    final step = chapter.steps[itemData['stepIndex']];
                    final title = itemData['chapterTitle'] as TitleBlock;

                    final titleTranslated = switch (selectedLang) {
                      AppLanguage.russian => title.ru,
                      AppLanguage.ukrainian => title.uk,
                      AppLanguage.spanish => title.es,
                      _ => title.en,
                    };

                    final mainText = switch (selectedLang) {
                      AppLanguage.russian => step.ru,
                      AppLanguage.ukrainian => step.uk,
                      AppLanguage.spanish => step.es,
                      _ => step.en,
                    };

                    final showEnglish = selectedLang != AppLanguage.english;

                    return BlocBuilder<SettingsBloc, SettingsState>(
                      builder: (context, state) {
                        return Card(
                          color: state.isDarkMode ? AppColors.softBlack : null,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  titleTranslated,
                                  style: AppTextStyles.merriweatherBold12,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  mainText,
                                  style: AppTextStyles.merriweather12,
                                ),
                                const SizedBox(height: 8),
                                if (showEnglish)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        step.en,
                                        style: AppTextStyles.merriweatherBold12
                                            .copyWith(
                                              color:
                                                  state.isDarkMode
                                                      ? AppColors
                                                          .lightBackground
                                                      : AppColors.softBlack,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),

                                if (showEnglish &&
                                    step.pronunciation.trim().isNotEmpty)
                                  Divider(thickness: 0.5),
                                Text(
                                  step.pronunciation,
                                  style: AppTextStyles.merriweather12.copyWith(
                                    color:
                                        state.isDarkMode
                                            ? AppColors.lightBackground
                                            : AppColors.darkBackground,

                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Divider(thickness: 0.5),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
        // Индикаторы страниц
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              totalPages,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: currentIndex == index ? 18 : 14,
                    fontWeight:
                        currentIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                    color:
                        currentIndex == index
                            ? AppColors.lightPrimary
                            : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 50),
      ],
    );
  }
}
