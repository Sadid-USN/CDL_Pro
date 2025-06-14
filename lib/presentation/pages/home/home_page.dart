import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:cdl_pro/router/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        // Функция для получения правильного типа данных в зависимости от языка
        AppDataType getLocalizedDataType(AppDataType baseType) {
          if (baseType == AppDataType.cdlTests) {
            switch (state.selectedLang) {
              case AppLanguage.russian:
                return AppDataType.cdlTestsRu;
              case AppLanguage.ukrainian:
                return AppDataType.cdlTestsUk;
              case AppLanguage.spanish:
                return AppDataType.cdlTestsEs;
              case AppLanguage.english:
                return AppDataType.cdlTests;
            }
          }
          return baseType; // For other types return as-is
        }

        final collectionTypes = [
          {
            'label': LocaleKeys.cdlTests.tr(),
            'type': getLocalizedDataType(AppDataType.cdlTests),
            'assetImage': AppLogos.cdlTest,
          },
          {
            'label': LocaleKeys.preTripInspection.tr(),
            'type': AppDataType.tripInseption,
            'assetImage': AppLogos.preTripInspection,
          },
          {
            'label': LocaleKeys.roadSigns.tr(),
            'type': AppDataType.roadSign,
            'assetImage': AppLogos.roadSigns,
          },
        ];

        return AnimationLimiter(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 25.h),
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemCount: collectionTypes.length,
            itemBuilder: (context, index) {
              final item = collectionTypes[index];
              final type = item['type'] as AppDataType;
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 600),
                child: FlipAnimation(
                  child: ElevatedContainer(
                    assetImage: item["assetImage"] as String,
                    onTap: () {
                      context.read<SettingsBloc>().add(ChangeType(type));
                      navigateToPage(context, route: MainCategoryRoute());
                    },
                    child: Text(
                      item['label'] as String,

                      style: AppTextStyles.merriweatherBold18.copyWith(
                        color: AppColors.lightBackground,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
