import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings_bloc.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings_state.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/widgets/widgets.dart';
import 'package:cdl_pro/router/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        const colorizeColors = [
          AppColors.lightPrimary,
          AppColors.darkPrimary,
          AppColors.goldenSoft,
          AppColors.greenSoft,
        ];
        return AutoTabsRouter(
          routes: [HomeRoute(), ProfileRoute(), SettingsRoute()],
          builder: (context, child) {
            final List<String> svgPictures = [
              AppLogos.home,

              AppLogos.profile,
              AppLogos.settings,
            ];
            final tabsRouter = AutoTabsRouter.of(context);
            final titles = [
              LocaleKeys.home.tr(),

              LocaleKeys.profile.tr(),
              LocaleKeys.settings.tr(),
            ];

            return AppScaffold(
              canPop: true,
              appBar: AppBar(
                centerTitle: true,
                title: Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'CDL Pro',
                        textStyle: AppTextStyles.merriweatherBold20,

                        colors: colorizeColors,
                      ),
                    ],
                    isRepeatingAnimation: true,
                    totalRepeatCount: 3,
                  ),
                ),
              ),
              body: child,
              bottomNavigationBar: AppBottomNavigationBar(
                titles: titles,
                isDark: state.isDarkMode,
                tabsRouter: tabsRouter,
                svgPictures: svgPictures,
              ),
            );
          },
        );
      },
    );
  }
}
