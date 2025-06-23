import 'dart:ui';
import 'package:cdl_pro/core/utils/enums.dart';

extension AppLanguageExt on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.russian:
        return 'ru';
      case AppLanguage.ukrainian:
        return 'uk';
      case AppLanguage.spanish:
        return 'es';
    }
  }

  Locale get locale => Locale(code);
}
