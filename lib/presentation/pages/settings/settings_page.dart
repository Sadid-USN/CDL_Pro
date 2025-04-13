import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/utils/enums.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/bloc.dart';
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

        return Column(
          children: [
            LangChangeButton(localBloc: settingsBloc),
            CustomListTile(
              title:
                  state.isDarkMode
                      ? LocaleKeys.dark.tr()
                      : LocaleKeys.light.tr(),
              trailingIcon: Icon(
                state.isDarkMode ? Icons.nightlight : Icons.wb_sunny,
              ),
              onTap: () {
                settingsBloc.add(ChangeTheme(isDarkMode: !state.isDarkMode));
              },
            ),
            GestureDetector(
              onTap: () {
                settingsBloc.add(IncrementTapCount());
              },
              child: SizedBox(
                height: 55,
                //   width: double.infinity / 2,
                child: Center(
                  child: Text(
                    "${state.tapCount}/7",
                    style: const TextStyle(
                      color: Colors.transparent,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            if (state.tapCount >= 7) ...[
              DropdownButton<AppDataType>(
                value: state.selectedType,
                onChanged: (newType) {
                  if (newType != null) {
                    settingsBloc.add(ChangeType(newType));
                  }
                },
                items:
                    AppDataType.values.map((language) {
                      return DropdownMenuItem<AppDataType>(
                        value: language,
                        child: Text(
                          language.name.toUpperCase(),
                          style: const TextStyle(color: Colors.black54),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  settingsBloc.add(UploadData());
                },
                child: const Text("Загрузить данные"),
              ),
              if (state.loadingStatus == LoadingStatus.loading)
                const CircularProgressIndicator(),
              if (state.loadingStatus == LoadingStatus.completed)
                const Text(
                  "Данные успешно загружены!",
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              if (state.loadingStatus == LoadingStatus.error)
                const SelectableText(
                  "Ошибка загрузки данных",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
            ],
          ],
        );
      },
    );
  }
}
