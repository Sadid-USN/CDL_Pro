import 'package:cdl_pro/core/utils/utils.dart';
import 'package:equatable/equatable.dart';

abstract class AbstractSettingsEvent extends Equatable {
  const AbstractSettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavedLanguage extends AbstractSettingsEvent {}
class IncrementTapCount extends AbstractSettingsEvent {}

class ChangeLanguage extends AbstractSettingsEvent {
  final AppLanguage newLanguage;

  const ChangeLanguage(
    this.newLanguage,
  );

  @override
  List<Object?> get props => [newLanguage];
}


class ChangeType extends AbstractSettingsEvent {
  final AppDataType newType;

  const ChangeType(
    this.newType,
  );

  @override
  List<Object?> get props => [newType];
}



class UploadData extends AbstractSettingsEvent {}

class LoadData extends AbstractSettingsEvent {
  const LoadData();

  @override
  List<Object?> get props => [];
}

class InitializeSettings extends AbstractSettingsEvent {}

class ChangeTheme extends AbstractSettingsEvent {
  final bool isDarkMode;
  const ChangeTheme({required this.isDarkMode});

  @override
  List<Object?> get props => [isDarkMode];
}
