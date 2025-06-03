import 'package:cdl_pro/domain/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class AbstractCDLTestsEvent extends Equatable {
  const AbstractCDLTestsEvent();
  
  @override
  List<Object?> get props => [];
}
class ChangeLanguageEvent extends AbstractCDLTestsEvent {
  final String languageCode; // 'ru', 'es', и т.д.
  const ChangeLanguageEvent(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}
class LoadQuizEvent extends AbstractCDLTestsEvent {
  final List<Question> questions;
  final String initialLanguage;

  const LoadQuizEvent(this.questions, {this.initialLanguage = 'en'});
}

class AnswerQuestionEvent extends AbstractCDLTestsEvent {
  final String questionId;
  final String selectedOption;
  const AnswerQuestionEvent(this.questionId, this.selectedOption);

  @override
  List<Object?> get props => [questionId, selectedOption];
}

class NextQuestionsEvent extends AbstractCDLTestsEvent {
  const NextQuestionsEvent();

  @override
  List<Object?> get props => [];
}

class CheckPremiumStatus extends AbstractCDLTestsEvent {
  final bool? isPremium; // Временное упрощение
  
  const CheckPremiumStatus({this.isPremium});
  
  @override
  List<Object?> get props => [isPremium];
}

class PurchasePremium extends AbstractCDLTestsEvent {
  const PurchasePremium();
  
  @override
  List<Object?> get props => [];
}
class TranslateEvent extends AbstractCDLTestsEvent {
  final String targetLangCode;

  const TranslateEvent(this.targetLangCode);

  @override
  List<Object?> get props => [targetLangCode];
}

