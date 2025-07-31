import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/core/extensions/extensions.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/purchase/purchase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class PremiumBottomSheet extends StatelessWidget {
  PremiumBottomSheet({super.key});

  final List<MyProduct> products = [
    MyProduct.weekly,
    MyProduct.monthly,
    MyProduct.threeMonths,
    MyProduct.sixMonths,
    MyProduct.yearly,
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Column(
        children: [
          Lottie.asset(
            AppLogos.premiumCrown,
            height: 70.h,
            fit: BoxFit.contain,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  LocaleKeys.premiumAccessTitle.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.merriweather16,
                ),
              ),
            ],
          ),

            TextButton(
              onPressed: () {
                context.read<PurchaseBloc>().add(RestorePurchase());
              },
              child: Text(
                LocaleKeys.restorePurchases.tr(),
                style: AppTextStyles.merriweather14.copyWith(
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          SizedBox(height: 8.h),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children:
                    products.map((product) {
                      final isPopular = product == MyProduct.monthly;
                      final isBestValue = product == MyProduct.yearly;

                      return SubscriptionOptionCard(
                        title: product.titleKey.tr(),
                        price: product.price,
                        productId: product.productId,
                        isPopular: isPopular,
                        isBestValue: isBestValue,
                        onPurchase: _handlePurchase,
                      );
                    }).toList(),
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  void _handlePurchase(
    BuildContext context,
    String productId,
    String planName,
  ) {
  
     context.read<PurchaseBloc>().add(BuySubscriptionProduct(productId));
  }
}

class SubscriptionOptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String productId;
  final bool isPopular;
  final bool isBestValue;
  final void Function(BuildContext context, String productId, String title)
  onPurchase;

  const SubscriptionOptionCard({
    super.key,
    required this.title,
    required this.price,
    required this.productId,
    this.isPopular = false,
    this.isBestValue = false,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: BorderSide(
          color:
              isPopular ? AppColors.goldenSoft : Theme.of(context).dividerColor,
          width: isPopular ? 1.5 : 0.5,
        ),
      ),
      elevation: 0,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPopular || isBestValue)
              SubscriptionBadge(isPopular: isPopular, isBestValue: isBestValue),
            SizedBox(height: (isPopular || isBestValue) ? 8.h : 0),
            Text(title, style: AppTextStyles.merriweatherBold12),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isBestValue)
              Text(
                LocaleKeys.saveDiscount.tr(),
                style: AppTextStyles.manrope8.copyWith(
                  color: AppColors.simpleGreen,
                ),
              ),
            Text(
              LocaleKeys.subscriptionAutoRenew.tr(),
              style: AppTextStyles.manrope8,
            ),
          
          ],
        ),
        trailing: Text(price, style: AppTextStyles.robotoMonoBold14),
        onTap: () => onPurchase(context, productId, title),
      ),
    );
  }
}

class SubscriptionBadge extends StatelessWidget {
  final bool isPopular;
  final bool isBestValue;

  const SubscriptionBadge({
    super.key,
    this.isPopular = false,
    this.isBestValue = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isPopular) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppColors.goldenSoft.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text(
          LocaleKeys.mostPopularBadge.tr(),
          style: AppTextStyles.merriweather10.copyWith(
            color: AppColors.goldenSoft,
          ),
        ),
      );
    } else if (isBestValue) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppColors.greenSoft.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text(
          LocaleKeys.bestValueBadge.tr(),
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.simpleGreen,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
