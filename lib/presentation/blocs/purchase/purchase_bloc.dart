import 'dart:async';
import 'package:cdl_pro/presentation/blocs/purchase/purchase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final InAppPurchase _iap = InAppPurchase.instance;
  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  PurchaseBloc() : super(PurchaseInitial()) {
    on<InitializePurchase>(_onInit);
    on<RestorePurchase>(_onRestore);
    on<BuyNonConsumableProduct>(_onBuyNonConsumable);
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

  void _onCancelLoading(CancelLoading event, Emitter<PurchaseState> emit) {
    emit(PurchaseInitial());
  }

  Future<void> _onCheckPastPurchases(
    CheckPastPurchases event,
    Emitter<PurchaseState> emit,
  ) async {
    final available = await _iap.isAvailable();
    if (!available) return;

    emit(PremiumLoading());

    // 🔽 Используем Android-specific API
    final InAppPurchaseAndroidPlatformAddition androidAddition =
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

    emit(PurchaseInitial());
  }

  Future<void> _onInit(
    InitializePurchase event,
    Emitter<PurchaseState> emit,
  ) async {
    final available = await _iap.isAvailable();
    if (!available) return;

    await _iap.restorePurchases();

    _subscription = _iap.purchaseStream.listen(
      (purchases) {
        add(HandlePurchaseUpdate(purchases));
      },
      onError: (error) {
        emit(PurchaseFailure('Stream error: $error'));
      },
    );
  }

  Future<void> _onRestore(
    RestorePurchase event,
    Emitter<PurchaseState> emit,
  ) async {
    try {
      await _iap.restorePurchases();
      emit(PurchaseRestored());
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
          emit(PurchaseSuccess());
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
