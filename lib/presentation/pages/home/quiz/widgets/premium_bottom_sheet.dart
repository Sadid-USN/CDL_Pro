import 'package:cdl_pro/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок с иконкой
              Row(
                children: [
                  Icon(Icons.star, color: AppColors.goldenSoft, size: 28.w),
                  SizedBox(width: 8.w),
                  Text(
                    'Premium Access to All Tests',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                'Unlock all CDL test questions, detailed explanations, and advanced features',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              SizedBox(height: 24.h),

              // Карточки подписок
              _buildSubscriptionCard(
                context,
                title: '1 Week Subscription',
                price: '\$5.99',
                isPopular: false,
              ),
              _buildSubscriptionCard(
                context,
                title: '1 Month Subscription',
                price: '\$19.99',
                isPopular: true,
              ),
              _buildSubscriptionCard(
                context,
                title: '3 Months Subscription',
                price: '\$49.99',
                isPopular: false,
              ),
              _buildSubscriptionCard(
                context,
                title: '6 Months Subscription',
                price: '\$79.99',
                isPopular: false,
              ),
              _buildSubscriptionCard(
                context,
                title: 'Annual Subscription',
                price: '\$99.99',
                isPopular: false,
                isBestValue: true,
              ),

              SizedBox(height: 16.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed:
                        () => _showPlaceholder(context, 'Privacy Policy'),
                    child: Text(
                      'Privacy Policy',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                  Text('•', style: TextStyle(fontSize: 12.sp)),
                  TextButton(
                    onPressed:
                        () => _showPlaceholder(context, 'Terms of Service'),
                    child: Text(
                      'Terms of Service',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                ],
              ),
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
            if (isPopular)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.goldenSoft.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'MOST POPULAR',
                  style: AppTextStyles.merriweather10.copyWith(
                    color: AppColors.goldenSoft,
                  ),
                ),
              ),
            if (isBestValue)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.greenSoft.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'BEST VALUE',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.simpleGreen,
                  ),
                ),
              ),
            SizedBox(height: isPopular || isBestValue ? 8.h : 0),
            Text(
              title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              price,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.lightPrimary,
              ),
            ),
            if (isBestValue)
              Text(
                'Save 20%',
                style: TextStyle(fontSize: 12.sp, color: AppColors.simpleGreen),
              ),
          ],
        ),
        onTap: () => _handlePurchase(context, title),
      ),
    );
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
