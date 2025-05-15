import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';

void navigateToPage(
  BuildContext context, {
  PageRouteInfo? route,
  String? routeName,
  bool replace = false,
  bool clearStack = false,
  bool popUntilNamed = false,
}) {
  assert(
    !(popUntilNamed && (route != null || replace || clearStack)),
    'Cannot use popUntilNamed with other navigation modes',
  );
  assert(
    !(route == null && routeName == null && !popUntilNamed),
    'Must provide either route or routeName',
  );

  final router = AutoRouter.of(context);

  if (popUntilNamed) {
    if (routeName != null) {
      router.popUntilRouteWithName(routeName);
    }
    return;
  }

  if (route != null) {
    if (clearStack) {
      router.replaceAll([route]);
    } else if (replace) {
      router.replace(route);
    } else {
      router.push(route);
    }
  }
}

