import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocalizationWrapper extends StatelessWidget {
  static final List<Locale> locales = [
    const Locale('en'),
    const Locale('ru'),
    const Locale('fr'),
    const Locale('uk'),
  ];
  final Widget child;

  const LocalizationWrapper({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
     
      startLocale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      supportedLocales: locales,
       path: 'assets/translations',
      child: child,
    );
  }
}
