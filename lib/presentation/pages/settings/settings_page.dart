import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/widgets/widgets.dart';
import 'package:cdl_pro/presentation/pages/profile/widgets/widgets.dart';
import 'package:cdl_pro/presentation/pages/settings/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final settingsBloc = context.watch<SettingsBloc>();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              CustomActionButton(
                text: LocaleKeys.purchasePremium.tr(),
                leadingIcon: null,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => PremiumBottomSheet(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12.r),
                      ),
                    ),
                  );
                },
                trailingIcon: Icons.workspace_premium_outlined,
              ),

              LangChangeButton(localBloc: settingsBloc),

              CustomActionButton(
                text:
                    state.isDarkMode
                        ? LocaleKeys.dark.tr()
                        : LocaleKeys.light.tr(),
                trailingIcon:
                    state.isDarkMode
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                onTap: () {
                  settingsBloc.add(ChangeTheme(isDarkMode: !state.isDarkMode));
                },
              ),

              //   _buildSectionHeader(context, LocaleKeys.helpAndSupport.tr()),
              // _buildSettingsCard(
              //   children: List.generate(
              //     4,
              //     (index) => Column(
              //       children: [
              //         CustomListTile(
              //           isDarkMode: state.isDarkMode,
              //           title: _getHelpTitle(index),
              //           trailingIcon: _getHelpIcon(
              //             index,
              //             AppColors.lightBackground,
              //           ),
              //           onTap: () {
              //             _handleHelpTap(index, context);
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // _buildSettingsCard(
              //   children: [
              //     FutureBuilder<String>(
              //       future: AppVersionUtil.getAppVersion(),
              //       builder: (context, snapshot) {
              //         return CustomListTile(
              //           isDarkMode: state.isDarkMode,
              //           title: LocaleKeys.version.tr(),
              //           trailingIcon: Text(
              //             snapshot.data ?? '1.0.0',
              //             style: AppTextStyles.robotoMono12.copyWith(
              //               color: AppColors.lightBackground,
              //             ),
              //           ),
              //           onTap: null,
              //         );
              //       },
              //     ),
              //   ],
              // ),

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
              // SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }
}
