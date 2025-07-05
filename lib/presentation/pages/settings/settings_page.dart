import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:cdl_pro/presentation/pages/settings/widgets/widgets.dart';
import 'package:cdl_pro/router/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final settingsBloc = context.watch<SettingsBloc>();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Settings Section
              _buildSectionHeader(context, LocaleKeys.settings.tr()),
              _buildSettingsCard(
                children: [
                  LangChangeButton(localBloc: settingsBloc),

                  CustomListTile(
                    isDarkMode: state.isDarkMode,
                    title:
                        state.isDarkMode
                            ? LocaleKeys.dark.tr()
                            : LocaleKeys.light.tr(),
                    trailingIcon: Icon(
                      state.isDarkMode
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      color: AppColors.whiteColor,
                    ),
                    onTap: () {
                      settingsBloc.add(
                        ChangeTheme(isDarkMode: !state.isDarkMode),
                      );
                    },
                  ),
                ],
              ),

              // Help & Support Section
              const SizedBox(height: 20),
              _buildSectionHeader(context, LocaleKeys.helpAndSupport.tr()),
              _buildSettingsCard(
                children: List.generate(
                  4,
                  (index) => Column(
                    children: [
                      CustomListTile(
                        isDarkMode: state.isDarkMode,
                        title: _getHelpTitle(index),
                        trailingIcon: _getHelpIcon(
                          index,
                          AppColors.lightBackground,
                        ),
                        onTap: () {
                          _handleHelpTap(index, context);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // App Info Section
              // const SizedBox(height: 24),
              _buildSettingsCard(
                children: [
                  FutureBuilder<String>(
                    future: AppVersionUtil.getAppVersion(),
                    builder: (context, snapshot) {
                      return CustomListTile(
                        isDarkMode: state.isDarkMode,
                        title: LocaleKeys.version.tr(),
                        trailingIcon: Text(
                          snapshot.data ?? '1.0.0',
                          style: AppTextStyles.robotoMono12.copyWith(
                            color: AppColors.lightBackground,
                          ),
                        ),
                        onTap: null,
                      );
                    },
                  ),
                ],
              ),

              // GestureDetector(
              //   onTap: () {
              //     settingsBloc.add(IncrementTapCount());
              //   },
              //   child: SizedBox(
              //     height: 55,
              //     //   width: double.infinity / 2,
              //     child: Center(
              //       child: Text(
              //         "${state.tapCount}/7",
              //         style: const TextStyle(
              //           color: Colors.transparent,
              //           fontSize: 15,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              // if (state.tapCount >= 7) ...[
              //   DropdownButton<AppDataType>(
              //     value: state.selectedType,
              //     onChanged: (newType) {
              //       if (newType != null) {
              //         settingsBloc.add(ChangeType(newType));
              //       }
              //     },
              //     items:
              //         AppDataType.values.map((language) {
              //           return DropdownMenuItem<AppDataType>(
              //             value: language,
              //             child: Text(
              //               language.name.toUpperCase(),
              //               style: const TextStyle(color: Colors.black54),
              //             ),
              //           );
              //         }).toList(),
              //   ),
              //   const SizedBox(height: 20),
              //   ElevatedButton(
              //     onPressed: () {
              //       settingsBloc.add(UploadData());
              //     },
              //     child: const Text("Загрузить данные"),
              //   ),
              //   if (state.loadingStatus == LoadingStatus.loading)
              //     const CircularProgressIndicator(),
              //   if (state.loadingStatus == LoadingStatus.completed)
              //     const Text(
              //       "Данные успешно загружены!",
              //       style: TextStyle(color: Colors.green, fontSize: 16),
              //     ),
              //   if (state.loadingStatus == LoadingStatus.error)
              //     const SelectableText(
              //       "Ошибка загрузки данных",
              //       style: TextStyle(color: Colors.red, fontSize: 16),
              //     ),
              // ],
              // SizedBox(height: 50,)
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 16),
      child: Text(title, style: AppTextStyles.merriweatherBold14),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // side: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
      ),
      child: Column(children: children),
    );
  }

  String _getHelpTitle(int index) {
    switch (index) {
      case 0:
        return LocaleKeys.rateUs.tr();
      case 1:
        return LocaleKeys.contactUs.tr();
      case 2:
        return LocaleKeys.termsOfUse.tr();
      case 3:
        return LocaleKeys.privacyPolicy.tr();
      default:
        return '';
    }
  }

  Widget _getHelpIcon(int index, Color color) {
    switch (index) {
      case 0:
        return Icon(Icons.star_border_outlined, color: color);
      case 1:
        return Icon(Icons.email_outlined, color: color);
      case 2:
        return Icon(Icons.description_outlined, color: color);

      // SvgPicture.asset(AppLogos.privacyIcon, height: 20, colorFilter: const ColorFilter.mode(
      //                             AppColors.whiteColor,
      //                             BlendMode.srcIn,
      //                           ),);
      case 3:
        return Icon(Icons.privacy_tip_outlined, color: color);
      default:
        return Icon(Icons.help_outline, color: color);
    }
  }

  void _handleHelpTap(int index, BuildContext context) {
    // Здесь можно добавить обработку нажатий
    switch (index) {
      case 0:
        AppLauncher.launchStore();
        break;
      case 1:
        AppLauncher.contactUs();
        break;
      case 2:
        navigateToPage(
          context,
          route: PolicyRoute(type: PolicyType.termsOfUse),
        );
        break;
      case 3:
        navigateToPage(
          context,
          route: PolicyRoute(type: PolicyType.privacyPolicy),
        );
        break;
    }
  }
}





//TODO ТОЛЬКО ОТЛАДКА - удалить перед выпуском в продакшн
                // GestureDetector(
                //   onTap: () {
                //     settingsBloc.add(IncrementTapCount());
                //   },
                //   child: SizedBox(
                //     height: 55,
                //     //   width: double.infinity / 2,
                //     child: Center(
                //       child: Text(
                //         "${state.tapCount}/7",
                //         style: const TextStyle(
                //           color: Colors.transparent,
                //           fontSize: 15,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // if (state.tapCount >= 7) ...[
                //   DropdownButton<AppDataType>(
                //     value: state.selectedType,
                //     onChanged: (newType) {
                //       if (newType != null) {
                //         settingsBloc.add(ChangeType(newType));
                //       }
                //     },
                //     items:
                //         AppDataType.values.map((language) {
                //           return DropdownMenuItem<AppDataType>(
                //             value: language,
                //             child: Text(
                //               language.name.toUpperCase(),
                //               style: const TextStyle(color: Colors.black54),
                //             ),
                //           );
                //         }).toList(),
                //   ),
                //   const SizedBox(height: 20),
                //   ElevatedButton(
                //     onPressed: () {
                //       settingsBloc.add(UploadData());
                //     },
                //     child: const Text("Загрузить данные"),
                //   ),
                //   if (state.loadingStatus == LoadingStatus.loading)
                //     const CircularProgressIndicator(),
                //   if (state.loadingStatus == LoadingStatus.completed)
                //     const Text(
                //       "Данные успешно загружены!",
                //       style: TextStyle(color: Colors.green, fontSize: 16),
                //     ),
                //   if (state.loadingStatus == LoadingStatus.error)
                //     const SelectableText(
                //       "Ошибка загрузки данных",
                //       style: TextStyle(color: Colors.red, fontSize: 16),
                //     ),
                // ],
            