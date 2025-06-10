import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/main_category_page.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/quiz.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/quiz_page.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/views/views.dart';
import 'package:cdl_pro/presentation/pages/pages.dart';
import 'package:flutter/material.dart';

import '../presentation/pages/home/quiz/main_page.dart';
part 'routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: MainRoute.page,
      path: "/",
      initial: true,
      children: [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ],
    ),
    AutoRoute(page: MainCategoryRoute.page),
    AutoRoute(page: OverviewCategoryRoute.page),
    AutoRoute(page: QuizRoute.page),
    AutoRoute(page: ImagesRoute.page),
  ];
}
