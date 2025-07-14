import 'package:cdl_pro/core/utils/enums.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';

extension MyProductExtension on MyProduct {
  String get titleKey {
    switch (this) {
      case MyProduct.weekly:
        return LocaleKeys.oneWeekSubscription;
      case MyProduct.monthly:
        return LocaleKeys.oneMonthSubscription;
      case MyProduct.threeMonths:
        return LocaleKeys.threeMonthsSubscription;
      case MyProduct.sixMonths:
        return LocaleKeys.sixMonthsSubscription;
      case MyProduct.yearly:
        return LocaleKeys.annualSubscription;
    }
  }

  String get price {
    switch (this) {
      case MyProduct.weekly:
        return '\$5.99';
      case MyProduct.monthly:
        return '\$19.99';
      case MyProduct.threeMonths:
        return '\$49.99';
      case MyProduct.sixMonths:
        return '\$79.99';
      case MyProduct.yearly:
        return '\$99.99';
    }
  }

  String get productId {
    switch (this) {
      case MyProduct.weekly:
        return 'one_week_subscription';
      case MyProduct.monthly:
        return 'one_month_subscription';
      case MyProduct.threeMonths:
        return 'three_months_subscription';
      case MyProduct.sixMonths:
        return 'six_months_subscription';
      case MyProduct.yearly:
        return 'annual_subscription';
    }
  }
}
