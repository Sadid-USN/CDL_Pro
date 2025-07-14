import 'package:cdl_pro/domain/models/models.dart';

class RuntimeCache {
  static final RuntimeCache _instance = RuntimeCache._();

  factory RuntimeCache() => _instance;

  RuntimeCache._();

  /// Единственный экземпляр TestsDataModel в памяти
  TestsDataModel? testsDataModel;
}