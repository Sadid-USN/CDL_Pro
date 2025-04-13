// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _ru = {
  "home": "Главная",
  "tests": "Тесты",
  "profile": "Профиль",
  "settings": "Настройки",
  "light": "Светлая",
  "dark": "Тёмная"
};
static const Map<String,dynamic> _uk = {
  "home": "Головна",
  "tests": "Тести",
  "profile": "Профіль",
  "settings": "Налаштування",
  "light": "Світла",
  "dark": "Темна"
};
static const Map<String,dynamic> _en = {
  "home": "Home",
  "tests": "Tests",
  "profile": "Profile",
  "settings": "Settings",
  "light": "Light",
  "dark": "Dark"
};
static const Map<String,dynamic> _fr = {
  "home": "Асосӣ",
  "tests": "Тестҳо",
  "profile": "Профил",
  "settings": "Танзимот",
  "light": "Равшан",
  "dark": "Торик"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ru": _ru, "uk": _uk, "en": _en, "fr": _fr};
}
