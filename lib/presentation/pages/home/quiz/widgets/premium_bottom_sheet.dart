import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class PremiumBottomSheet extends StatelessWidget {
  final VoidCallback onPurchasePressed;

  const PremiumBottomSheet({super.key, required this.onPurchasePressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Заголовок с иконкой
              Lottie.asset(AppLogos.premiumCrown, height: 60.h),
              SizedBox(width: 8.w),
              Text(
                LocaleKeys.premiumAccessTitle.tr(),
                style: AppTextStyles.merriweatherBold14,
              ),

              SizedBox(height: 24.h),

              // Карточки подписок
              _buildSubscriptionCard(
                context,
                title: LocaleKeys.oneWeekSubscription.tr(),
                price: '\$5.99',
                isPopular: false,
              ),
              _buildSubscriptionCard(
                context,
                title: LocaleKeys.oneMonthSubscription.tr(),
                price: '\$19.99',
                isPopular: true,
              ),
              _buildSubscriptionCard(
                context,
                title: LocaleKeys.threeMonthsSubscription.tr(),
                price: '\$49.99',
                isPopular: false,
              ),
              _buildSubscriptionCard(
                context,
                title: LocaleKeys.sixMonthsSubscription.tr(),
                price: '\$79.99',
                isPopular: false,
              ),
              _buildSubscriptionCard(
                context,
                title: LocaleKeys.annualSubscription.tr(),
                price: '\$99.99',
                isPopular: false,
                isBestValue: true,
              ),

              SizedBox(height: 16.h),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     TextButton(
              //       onPressed:
              //           () => _showPlaceholder(context, 'Privacy Policy'),
              //       child: Text(
              //         'Privacy Policy',
              //         style: TextStyle(fontSize: 12.sp),
              //       ),
              //     ),
              //     Text('•', style: TextStyle(fontSize: 12.sp)),
              //     TextButton(
              //       onPressed:
              //           () => _showPlaceholder(context, 'Terms of Service'),
              //       child: Text(
              //         'Terms of Service',
              //         style: TextStyle(fontSize: 12.sp),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(
    BuildContext context, {
    required String title,
    required String price,
    bool isPopular = false,
    bool isBestValue = false,
  }) {
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
              _buildBadge(
                context,
                isPopular: isPopular,
                isBestValue: isBestValue,
              ),
            SizedBox(height: (isPopular || isBestValue) ? 8.h : 0),
            Text(title, style: AppTextStyles.manropeBold14),
          ],
        ),
        subtitle:
            isBestValue
                ? Text(
                  LocaleKeys.saveDiscount.tr(),
                  style: AppTextStyles.manrope8.copyWith(
                    color: AppColors.simpleGreen,
                  ),
                )
                : null,
        trailing: Text(price, style: AppTextStyles.robotoMonoBold14),
        onTap: () => _handlePurchase(context, title),
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

  void _handlePurchase(BuildContext context, String plan) {
    // TODO: Реализовать логику покупки через in_app_purchase
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Purchasing $plan (will be implemented)')),
    );
  }

  void _showPlaceholder(BuildContext context, String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title (will be implemented)')));
  }
}
