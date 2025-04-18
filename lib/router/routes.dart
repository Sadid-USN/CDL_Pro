import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/utils/enums.dart';
import 'package:cdl_pro/presentation/pages/pages.dart';
import 'package:flutter/material.dart';
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
    AutoRoute(page: CategoryRoute.page),
  ];
}
