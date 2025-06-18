import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

enum FirebaseAuthErrorType {
  wrongPassword,
  userNotFound,
  emailAlreadyInUse,
  invalidEmail,
  weakPassword,
  networkError,
  tooManyRequests,
  unknown,
}

class FirebaseErrorHandler {
  static FirebaseAuthErrorType fromCode(String code) {
    switch (code.toLowerCase()) {
      case 'wrong-password':
        return FirebaseAuthErrorType.wrongPassword;
      case 'invalid-credential':
        return FirebaseAuthErrorType.userNotFound;
      case 'email-already-in-use':
        return FirebaseAuthErrorType.emailAlreadyInUse;
      case 'invalid-email':
        return FirebaseAuthErrorType.invalidEmail;
      case 'weak-password':
        return FirebaseAuthErrorType.weakPassword;
      case 'network-request-failed':
        return FirebaseAuthErrorType.networkError;
      case 'too-many-requests':
        return FirebaseAuthErrorType.tooManyRequests;
      default:
        return FirebaseAuthErrorType.unknown;
    }
  }

  static String getErrorKey(FirebaseAuthErrorType errorType) {

    switch (errorType) {
      case FirebaseAuthErrorType.wrongPassword:
      case FirebaseAuthErrorType.userNotFound:
        return LocaleKeys.incorrectEmailOrPassword.tr();
      case FirebaseAuthErrorType.emailAlreadyInUse:
        return LocaleKeys.emailAlreadyInUse.tr();
      case FirebaseAuthErrorType.invalidEmail:
        return LocaleKeys.invalidEmail.tr();
      case FirebaseAuthErrorType.weakPassword:
        return LocaleKeys.passwordTooShort.tr();
      case FirebaseAuthErrorType.networkError:
        return 'noInternetConnection';
      case FirebaseAuthErrorType.tooManyRequests:
        return 'tooManyAttempts';
      case FirebaseAuthErrorType.unknown:
        return LocaleKeys.loginError.tr();
    }
  }
}
