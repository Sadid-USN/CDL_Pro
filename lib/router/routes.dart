import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/presentation/pages/pages.dart';
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
        AutoRoute(page: TestingRoute.page),
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ],
    ),
  ];
}
