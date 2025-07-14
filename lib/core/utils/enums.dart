enum LoadingStatus { loading, completed, error }

enum AppDataType {
  cdlTests,
  cdlTestsRu,
  cdlTestsUk,
  cdlTestsEs,
  roadSign,
  tripInseption,
  termsOfUse,
  privacyPolicy,
}

extension AppDataTypeX on AppDataType {
  /// Название коллекции в Firestore
  String get collectionName {
    switch (this) {
      case AppDataType.cdlTests:
        return 'CDLTests';
      case AppDataType.cdlTestsRu:
        return 'CDLTestsRu';
      case AppDataType.cdlTestsUk:
        return 'CDLTestsUk';
      case AppDataType.cdlTestsEs:
        return 'CDLTestsEs';
      case AppDataType.roadSign:
        return 'RoadSign';
      case AppDataType.tripInseption:
        return 'PreTripInseption';
      case AppDataType.termsOfUse:
        return 'termsOfUse';
      case AppDataType.privacyPolicy:
        return 'PrivacyPolicy';
    }
  }

  /// Ключ для кэша в SharedPreferences
  String get cacheKey {
    switch (this) {
      case AppDataType.cdlTests:
        return 'cdl_tests_cache';
      case AppDataType.cdlTestsRu:
        return 'cdl_tests_ru_cache';
      case AppDataType.cdlTestsUk:
        return 'cdl_tests_uk_cache';
      case AppDataType.cdlTestsEs:
        return 'cdl_tests_es_cache';
      case AppDataType.roadSign:
        return 'road_signs_cache';
      case AppDataType.tripInseption:
        return 'trip_inseption_cache';
      case AppDataType.termsOfUse:
        return 'terms_of_use_cache';
      case AppDataType.privacyPolicy:
        return 'privacy_policy_cache';
    }
  }

  /// Путь к JSON-файлам в assets
  String get assetPath {
    switch (this) {
      case AppDataType.cdlTests:
        return 'assets/DB/tests';
      case AppDataType.cdlTestsRu:
        return 'assets/DB/tests_ru';
      case AppDataType.cdlTestsUk:
        return 'assets/DB/tests_uk';
      case AppDataType.cdlTestsEs:
        return 'assets/DB/tests_es';
      case AppDataType.roadSign:
        return 'assets/DB/road_signs';
      case AppDataType.tripInseption:
        return 'assets/DB/trip_inspection';
      case AppDataType.termsOfUse:
        return 'assets/DB/terms_of_use';
      case AppDataType.privacyPolicy:
        return 'assets/DB/privacy_policy';
    }
  }
}

enum AppLanguage { english, russian, ukrainian, spanish }
enum PrayerTimeStatus { initial, loading, loaded, error }
enum PolicyType {termsOfUse,privacyPolicy,
}
enum MyProduct {
  weekly,
  monthly,
  threeMonths,
  sixMonths,
  yearly,
}