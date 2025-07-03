import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:cdl_pro/presentation/pages/settings/widgets/widgets.dart';
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
        final theme = Theme.of(context);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Settings Section
              _buildSectionHeader(context, LocaleKeys.settings.tr()),
              _buildSettingsCard(
                children: [
                  LangChangeButton(localBloc: settingsBloc),

                  CustomListTile(
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
                        title: _getHelpTitle(index),
                        trailingIcon: Icon(
                          _getHelpIcon(index),
                          color: AppColors.whiteColor,
                          size: 20,
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
              const SizedBox(height: 24),
              _buildSettingsCard(
                children: [
                  CustomListTile(
                    title: LocaleKeys.version.tr(),
                    trailingIcon: Text(
                      '1.0.0',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                    onTap: null,
                  ),
                ],
              ),
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

  IconData _getHelpIcon(int index) {
    switch (index) {
      case 0:
        return Icons.star_border_outlined;
      case 1:
        return Icons.email_outlined;
      case 2:
        return Icons.description_outlined;
      case 3:
        return Icons.privacy_tip_outlined;
      default:
        return Icons.help_outline;
    }
  }

  void _handleHelpTap(int index, BuildContext context) {
    // Здесь можно добавить обработку нажатий
    switch (index) {
      case 0:
        AppLauncher.launchStore();
        break;
      case 1:
        // Открыть контакты
        break;
      case 2:
        // Открыть условия использования
        break;
      case 3:
        // Открыть политику конфиденциальности
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
            