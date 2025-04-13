
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

enum ApiErrorType {
  badGateway, // 502
  notFound, // 404
  success, // 200
  created, // 201
  serverError, // 500
  forbidden, // 403
  unknown, // для других ошибок
  noInternetConnection, // Новое поле для ошибки "нет интернет соединения"
}

class ErrorHandler {
  static ApiErrorType handleStatusCode(int statusCode) {
    switch (statusCode) {
      case 200:
        return ApiErrorType.success;
      case 201:
        return ApiErrorType.created;
      case 404:
        return ApiErrorType.notFound;
      case 502:
        return ApiErrorType.badGateway;
      case 500:
        return ApiErrorType.serverError;
      case 403:
        return ApiErrorType.forbidden;
      default:
        return ApiErrorType.unknown;
    }
  }

  static String getErrorMessage(ApiErrorType errorType) {
    switch (errorType) {
      case ApiErrorType.badGateway:
        return "LocaleKeys.server_side_error.tr()";
      case ApiErrorType.notFound:
        return "LocaleKeys.data_not_found.tr()";
      case ApiErrorType.serverError:
        return "LocaleKeys.internal_server_error.tr()";
      case ApiErrorType.forbidden:
        return "LocaleKeys.access_forbidden.tr()";
      case ApiErrorType.unknown:
        return "LocaleKeys.unknown_error.tr()";
      case ApiErrorType.noInternetConnection: // Новое сообщение для ошибки нет интернет соединения
        return "LocaleKeys.noInternetConnection.tr()";
      default:
        return "LocaleKeys.success_message.tr()";
    }
  }

  static String getErrorIconPath(ApiErrorType errorType) {
    switch (errorType) {
      case ApiErrorType.badGateway:
        return "icons/server_not_found.png";
      case ApiErrorType.notFound:
        return "icons/server_not_found.png";
      case ApiErrorType.serverError:
        return "icons/disabled_location.png";
      case ApiErrorType.forbidden:
        return "icons/forbidden.png";
      case ApiErrorType.unknown:
        return "icons/unknown_error.png";
      case ApiErrorType.noInternetConnection: // Новая иконка для ошибки нет интернет соединения
        return "icons/no_internet_connection.png"; 
      default:
        return "icons/success.png";
    }
  }
}
