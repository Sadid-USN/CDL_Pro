import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/presentation/blocs/onboarding/onboarding.dart';
import 'package:cdl_pro/presentation/pages/home/onbording_page.dart';
import 'package:cdl_pro/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lottie/lottie.dart';

@RoutePage()
class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingRequired) {
          return const OnBoardingPage();
        } else if (state is OnboardingCompleted) {
          // Используем AutoRouter для навигации на MainRoute

          navigateToPage(context, route: MainRoute(), clearStack: true);

          return Scaffold(
            body: Center(
              child: LottieBuilder.asset('assets/lottie/tire_loading.json'),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: LottieBuilder.asset('assets/lottie/tire_loading.json'),
            ),
          );
        }
      },
    );
  }
}
