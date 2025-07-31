import 'dart:async';
import 'dart:io';
import 'package:cdl_pro/presentation/blocs/purchase/purchase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final InAppPurchase _iap = InAppPurchase.instance;
  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  PurchaseBloc() : super(PurchaseInitial()) {
    on<InitializePurchase>(_onInit);
    on<RestorePurchase>(_onRestore);
    on<BuyNonConsumableProduct>(_onBuyNonConsumable);
    on<BuySubscriptionProduct>(_onBuySubscription);

    on<HandlePurchaseUpdate>(_onHandlePurchaseUpdate);
    on<CheckPastPurchases>(_onCheckPastPurchases);
    on<CancelLoading>(_onCancelLoading);
  }

  final Set<String> productIds = {
    'annual_subscription',
    'one_month_subscription',
    'one_week_subscription',
    'six_months_subscription',
    'three_months_subscription',
  };

  Future<void> _onBuySubscription(
    BuySubscriptionProduct event,
    Emitter<PurchaseState> emit,
  ) async {
    try {
      emit(PremiumLoading());

      final response = await _iap.queryProductDetails({event.productId});
      if (response.notFoundIDs.isNotEmpty) {
        emit(PurchaseFailure('Subscription not found'));
        return;
      }

      final productDetails = response.productDetails.first;
      final purchaseParam = PurchaseParam(productDetails: productDetails);

      // Для подписок используется buyNonConsumable
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);

      Future.delayed(const Duration(seconds: 1), () {
        if (state is PremiumLoading) {
          add(CancelLoading());
        }
      });
    } catch (e) {
      emit(PurchaseFailure('Subscription purchase failed: $e'));
    }
  }

  void _onCancelLoading(CancelLoading event, Emitter<PurchaseState> emit) {
    emit(PurchaseInitial());
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    // Базовая проверка для App Store: наличие локальных данных
    return purchase.verificationData.localVerificationData.isNotEmpty;
  }

  Future<void> _onCheckPastPurchases(
    CheckPastPurchases event,
    Emitter<PurchaseState> emit,
  ) async {
    final available = await _iap.isAvailable();
    if (!available) return;

    emit(PremiumLoading());

    try {
      if (Platform.isAndroid) {
        final androidAddition =
            _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        final purchasesResponse = await androidAddition.queryPastPurchases();

        for (final purchase in purchasesResponse.pastPurchases) {
          if (productIds.contains(purchase.productID) &&
              (purchase.status == PurchaseStatus.purchased ||
                  purchase.status == PurchaseStatus.restored)) {
            emit(PurchaseSuccess());
            return;
          }
        }
      } else if (Platform.isIOS) {
        final completer = Completer<bool>();
        late final StreamSubscription sub;

        sub = _iap.purchaseStream.listen((purchases) {
          bool found = false;

          for (final purchase in purchases) {
            if (productIds.contains(purchase.productID) &&
                (purchase.status == PurchaseStatus.purchased ||
                    purchase.status == PurchaseStatus.restored)) {
              found = true;
              break;
            }
          }

          if (!completer.isCompleted) {
            completer.complete(found);
            sub.cancel();
          }
        });

        await _iap.restorePurchases();

        final hasPurchases = await completer.future.timeout(
          const Duration(seconds: 5),
          onTimeout: () => false,
        );

        if (hasPurchases) {
          emit(PurchaseSuccess());
          return;
        }

        await sub.cancel();
      }
    } catch (e) {
      debugPrint('Error checking past purchases: $e');
    }

    emit(PurchaseInitial());
  }

  Future<void> _onInit(
    InitializePurchase event,
    Emitter<PurchaseState> emit,
  ) async {
    final available = await _iap.isAvailable();
    if (!available) {
      emit(PurchaseFailure('In-app purchases not available'));
      return;
    }

    _subscription = _iap.purchaseStream.listen(
      (purchases) {
        add(HandlePurchaseUpdate(purchases));
      },
      onError: (error) {
        emit(PurchaseFailure('Stream error: $error'));
      },
    );

    if (Platform.isIOS) {
      try {
        final storeKitAddition =
            _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await storeKitAddition.setDelegate(_ExamplePaymentQueueDelegate());

        emit(PremiumLoading());

        final completer = Completer<bool>();
        late final StreamSubscription tempSub;

        tempSub = _iap.purchaseStream.listen((purchases) {
          bool found = false;

          for (final purchase in purchases) {
            if (productIds.contains(purchase.productID) &&
                (purchase.status == PurchaseStatus.purchased ||
                    purchase.status == PurchaseStatus.restored)) {
              found = true;
              break;
            }
          }

          if (!completer.isCompleted) {
            completer.complete(found);
            tempSub.cancel();
          }
        });

        await _iap.restorePurchases();

        final hasPurchases = await completer.future.timeout(
          const Duration(seconds: 5),
          onTimeout: () => false,
        );

        if (hasPurchases) {
          emit(PurchaseSuccess());
        } else {
          emit(PurchaseInitial());
        }

        await tempSub.cancel();
      } catch (e) {
        debugPrint('Error during iOS purchase initialization: $e');
        emit(PurchaseInitial());
      }
    }
  }

  Future<void> _onRestore(
    RestorePurchase event,
    Emitter<PurchaseState> emit,
  ) async {
    try {
      emit(PremiumLoading());
      await _iap.restorePurchases();
    } catch (e) {
      emit(PurchaseFailure('Restore failed: $e'));
    }
  }

  Future<void> _onBuyNonConsumable(
    BuyNonConsumableProduct event,
    Emitter<PurchaseState> emit,
  ) async {
    try {
      emit(PremiumLoading());

      final response = await _iap.queryProductDetails({event.productId});
      if (response.notFoundIDs.isNotEmpty) {
        emit(PurchaseFailure('Product not found'));
        return;
      }

      final productDetails = response.productDetails.first;
      final purchaseParam = PurchaseParam(productDetails: productDetails);

      await _iap.buyNonConsumable(purchaseParam: purchaseParam);

      Future.delayed(const Duration(seconds: 1), () {
        if (state is PremiumLoading) {
          add(CancelLoading());
        }
      });
    } catch (e) {
      emit(PurchaseFailure('Purchase failed: $e'));
    }
  }

  Future<void> _onHandlePurchaseUpdate(
    HandlePurchaseUpdate event,
    Emitter<PurchaseState> emit,
  ) async {
    for (final purchase in event.purchases) {
      if (!productIds.contains(purchase.productID)) continue;

      switch (purchase.status) {
        case PurchaseStatus.pending:
          emit(PremiumLoading());
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final isValid = await _verifyPurchase(purchase);
          if (isValid) {
            emit(PurchaseSuccess());
          } else {
            emit(PurchaseFailure('Invalid purchase'));
          }
          break;

        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          emit(PurchaseFailure('Purchase ${purchase.status.name}'));
          break;
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}

/// Делегат для iOS (StoreKit)
class _ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true; // Разрешаем все транзакции
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
