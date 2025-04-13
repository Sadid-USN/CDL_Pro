import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

void navigateToPage(BuildContext context, {PageRouteInfo? route}) {
  if (route != null) {
    // ✅ Если передан маршрут напрямую — открываем его
    AutoRouter.of(context).push(route);
    return;
  }
}
