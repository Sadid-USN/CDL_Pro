import 'package:equatable/equatable.dart';

abstract class PurchaseState extends Equatable {
  final bool isPremium;

  const PurchaseState({this.isPremium = false});

  @override
  List<Object?> get props => [isPremium];
}

class PurchaseInitial extends PurchaseState {
  const PurchaseInitial() : super(isPremium: false);
}

class PremiumLoading extends PurchaseState {
  const PremiumLoading() : super(isPremium: false);
}

class PurchaseSuccess extends PurchaseState {
  const PurchaseSuccess() : super(isPremium: true);
}

class PurchaseFailure extends PurchaseState {
  final String message;
  const PurchaseFailure(this.message) : super(isPremium: false);

  @override
  List<Object?> get props => [message, isPremium];
}

class PurchaseRestored extends PurchaseState {
  const PurchaseRestored() : super(isPremium: true);
}
