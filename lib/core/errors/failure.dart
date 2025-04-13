

import 'package:cdl_pro/core/errors/error.dart';

sealed class Failure {}

class ApiFailure extends Failure {
  final ApiErrorType error;
  ApiFailure(this.error);
}

class LocationFailure extends Failure {
  final LocationErrorType error;
  LocationFailure(this.error);
}

class UnknownFailure extends Failure {}
