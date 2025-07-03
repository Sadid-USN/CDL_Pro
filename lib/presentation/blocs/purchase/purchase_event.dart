import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

abstract class PurchaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}



class InitializePurchase extends PurchaseEvent {}



class RestorePurchase extends PurchaseEvent {}
class CancelLoading extends PurchaseEvent {}


class BuyNonConsumableProduct extends PurchaseEvent {
  final String productId;
  BuyNonConsumableProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}

class HandlePurchaseUpdate extends PurchaseEvent {
  final List<PurchaseDetails> purchases;
  HandlePurchaseUpdate(this.purchases);

  @override
  List<Object?> get props => [purchases];
}

/// 🔄 Новый event
class CheckPastPurchases extends PurchaseEvent {}

