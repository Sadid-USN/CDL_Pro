import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/purchase/purchase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class PremiumBottomSheet extends StatelessWidget {
  PremiumBottomSheet({super.key});

  // Основной источник данных: productId → LocaleKey
  final Map<String, String> productIdToLocaleKey = {
    'one_week_subscription': LocaleKeys.oneWeekSubscription,
    'one_month_subscription': LocaleKeys.oneMonthSubscription,
    'three_months_subscription': LocaleKeys.threeMonthsSubscription,
    'six_months_subscription': LocaleKeys.sixMonthsSubscription,
    'annual_subscription': LocaleKeys.annualSubscription,
  };

  // Для UI — отображаемые цены (можно динамически загружать в будущем)
  final Map<String, String> productIdToPrice = {
    'one_week_subscription': '\$5.99',
    'one_month_subscription': '\$19.99',
    'three_months_subscription': '\$49.99',
    'six_months_subscription': '\$79.99',
    'annual_subscription': '\$99.99',
  };

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
          Text(
            LocaleKeys.premiumAccessTitle.tr(),
            style: AppTextStyles.merriweatherBold16.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: productIdToLocaleKey.entries.map((entry) {
                  final productId = entry.key;
                  final titleKey = entry.value;
                  final price = productIdToPrice[productId] ?? '';
                  final isPopular = productId == 'one_month_subscription';
                  final isBestValue = productId == 'annual_subscription';

                  return _buildSubscriptionCard(
                    context,
                    title: titleKey.tr(),
                    price: price,
                    productId: productId,
                    isPopular: isPopular,
                    isBestValue: isBestValue,
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

  Widget _buildSubscriptionCard(
    BuildContext context, {
    required String title,
    required String price,
    required String productId,
    bool isPopular = false,
    bool isBestValue = false,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: BorderSide(
          color: isPopular ? AppColors.goldenSoft : Theme.of(context).dividerColor,
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
              _buildBadge(
                context,
                isPopular: isPopular,
                isBestValue: isBestValue,
              ),
            SizedBox(height: (isPopular || isBestValue) ? 8.h : 0),
            Text(title, style: AppTextStyles.manropeBold14),
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
        onTap: () => _handlePurchase(context, productId, title),
      ),
    );
  }

  Widget _buildBadge(
    BuildContext context, {
    bool isPopular = false,
    bool isBestValue = false,
  }) {
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

  void _handlePurchase(BuildContext context, String productId, String planName) {
    Navigator.pop(context);
    context.read<PurchaseBloc>().add(BuyNonConsumableProduct(productId));

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Purchasing $planName...')),
    // );
  }
}
