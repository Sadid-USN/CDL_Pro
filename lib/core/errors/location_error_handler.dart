

import 'package:geolocator/geolocator.dart';

enum LocationErrorType {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  noInternetConnection, // Заменено с unknown
}

class LocationErrorHandler {
  static LocationErrorType handlePermission(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.denied:
        return LocationErrorType.permissionDenied;
      case LocationPermission.deniedForever:
        return LocationErrorType.permissionDeniedForever;
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        // Разрешение уже есть — ошибка не требуется
        throw Exception('Permission already granted');
      case LocationPermission.unableToDetermine:
        return LocationErrorType.noInternetConnection; // Изменено на noInternetConnection
    }
  }

  static String getErrorMessage(LocationErrorType errorType) {
    switch (errorType) {
      case LocationErrorType.serviceDisabled:
        return "LocaleKeys.location_service_disabled.tr()";
      case LocationErrorType.permissionDenied:
        return "LocaleKeys.location_permission_denied.tr()";
      case LocationErrorType.permissionDeniedForever:
        return "LocaleKeys.location_permission_denied_forever.tr()";
      case LocationErrorType.noInternetConnection: // Новое сообщение
        return "LocaleKeys.noInternetConnection.tr()"; 
    }
  }

  static String getErrorIconPath(LocationErrorType errorType) {
    switch (errorType) {
      case LocationErrorType.serviceDisabled:
        return "icons/location_disabled.png";
      case LocationErrorType.permissionDenied:
        return "icons/location_denied.png";
      case LocationErrorType.permissionDeniedForever:
        return "icons/location_denied_forever.png";
      case LocationErrorType.noInternetConnection: // Новая иконка
        return "icons/no_internet_connection.png"; 
    }
  }
}