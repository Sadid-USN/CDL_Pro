import 'package:equatable/equatable.dart';

abstract class AbstractCDLTestsEvent extends Equatable {
  const AbstractCDLTestsEvent();

  @override
  List<Object?> get props => [];
}


class TranslateEvent extends AbstractCDLTestsEvent {
  final String targetLangCode;

  const TranslateEvent(this.targetLangCode);

  @override
  List<Object?> get props => [targetLangCode];
}

