import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/constants/constants.dart';
import 'package:cdl_pro/core/themes/app_colors.dart';
import 'package:cdl_pro/core/themes/app_text_styles.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/onboarding/onboarding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';

@RoutePage()
class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          titleWidget: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              LocaleKeys.welcomeTitle.tr(),
              style: AppTextStyles.merriweatherBold14.copyWith(
                color: AppColors.softBlack,
              ),
            ),
          ),
          bodyWidget: Center(child: Text(LocaleKeys.welcomeBody.tr())),
          image: Image.asset(AppLogos.truck),
        ),
        PageViewModel(
          titleWidget: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              LocaleKeys.registerTitle.tr(),
              style: AppTextStyles.merriweatherBold14.copyWith(
                color: AppColors.softBlack,
              ),
            ),
          ),
          bodyWidget: Center(child: Text(LocaleKeys.registerBody.tr())),
          image: Center(child: Image.asset(AppLogos.truck)),
        ),
        PageViewModel(
          titleWidget: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              LocaleKeys.startTitle.tr(),
              style: AppTextStyles.merriweatherBold14.copyWith(
                color: AppColors.softBlack,
              ),
            ),
          ),
          bodyWidget: Text(LocaleKeys.startBody.tr()),
          image: Center(child: Image.asset(AppLogos.truck)),
        ),
      ],
      onDone: () {
        context.read<OnboardingCubit>().completeOnboarding();
      },
      showSkipButton: true,
      skip: const Text("Пропустить"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Готово", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
