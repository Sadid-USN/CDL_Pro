import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/utils/enums.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/pages/home/initial_page.dart';
import 'package:cdl_pro/presentation/pages/home/onbording_page.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/quiz.dart';
import 'package:cdl_pro/presentation/pages/pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../presentation/pages/home/quiz/main_page.dart';
part 'routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      page: InitialRoute.page,
      initial: true,
      children: [
        AutoRoute(path: 'onboarding', page: OnBoardingRoute.page),
        AutoRoute(path: 'main', page: MainRoute.page),
      ],
    ),
    AutoRoute(
      page: MainRoute.page,
      path: "/main",
      children: [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ],
    ),
    AutoRoute(page: MainCategoryRoute.page),
    AutoRoute(page: OverviewCategoryRoute.page),
    AutoRoute(page: QuizRoute.page),
    AutoRoute(page: ImagesRoute.page),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: PolicyRoute.page),
  ];
}
