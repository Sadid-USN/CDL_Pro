import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:cdl_pro/presentation/pages/profile/widgets/widgets.dart';
import 'package:cdl_pro/presentation/pages/settings/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LangChangeButton extends StatelessWidget {
  final SettingsBloc localBloc;

  const LangChangeButton({super.key, required this.localBloc});

  Future<void> _onLanguageSelected(
    AppLanguage language,
    BuildContext context,
  ) async {
    localBloc.add(ChangeLanguage(language));
    await context.setLocale(Locale(SettingsBloc.getLanguageCode(language)));
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> languages = [
      {"lang": "English", "language": AppLanguage.english},
      {"lang": "Русский", "language": AppLanguage.russian},
      {"lang": "Українська", "language": AppLanguage.ukrainian},
      {"lang": "Español", "language": AppLanguage.spanish},
    ];

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return CustomActionButton(

          text: LocaleKeys.language.tr(),
          trailingIcon: Icons.language_outlined,
          onTap: () {
            showMenu<AppLanguage>(
           
              context: context,
              position: PopupMenuPositionHelper.getPopupPosition(context),
              items:
                  languages.map((lang) {
                    return PopupMenuItem<AppLanguage>(
                      value: lang["language"],
                      child: Text(lang["lang"]),
                    );
                  }).toList(),
            ).then((language) {
              if (language != null && context.mounted) {
                _onLanguageSelected(language, context);
              }
            });
          },
        );
      },
    );
  }
}

// class LangChangeButton extends StatelessWidget {
//   final SettingsBloc localBloc;

//   const LangChangeButton({super.key, required this.localBloc});

//   // Убираем BuildContext из этого метода
//   Future<void> _onLanguageSelected(
//     AppLanguage language,
//     BuildContext context,
//   ) async {
//     localBloc.add(ChangeLanguage(language));
//     await context.setLocale(Locale(SettingsBloc.getLanguageCode(language)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> languages = [
//       {"lang": "English", "language": AppLanguage.english},
//       {"lang": "Русский", "language": AppLanguage.russian},
//       {"lang": "Українська", "language": AppLanguage.ukrainian},
//       {"lang": "Español", "language": AppLanguage.spanish},
//     ];

//     return BlocBuilder<SettingsBloc, SettingsState>(
//       builder: (context, state) {
//         return CustomListTile(
//           title: localBloc.getSelectedLangTitle(state.selectedLang),
//           trailingIcon: SvgPicture.asset(
//             AppLogos.language,
//             height: 15.h,
//             colorFilter: ColorFilter.mode(
//               AppColors.whiteColor,
//               BlendMode.srcIn,
//             ),
//           ),
//           onTap: () {
//             showMenu<AppLanguage>(
//               context: context,
//               position: PopupMenuPositionHelper.getPopupPosition(context),
//               items:
//                   languages.map((lang) {
//                     return PopupMenuItem<AppLanguage>(
//                       value: lang["language"],
//                       child: Text(lang["lang"], ),
//                     );
//                   }).toList(),
//             ).then((language) {
//               if (language != null && context.mounted) {
//                 // Передаем context здесь, а не в асинхронном методе
//                 _onLanguageSelected(language, context);
//               }
//             });
//           },
//         );
//       },
//     );
//   }
// }
