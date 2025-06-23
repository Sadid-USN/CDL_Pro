import 'package:cdl_pro/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// **Светлая тема**
ThemeData lightThemeData() {
  return ThemeData.light().copyWith(
    cardColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.lightPrimary,
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(AppColors.lightPrimary),
      checkColor: WidgetStateProperty.all(Colors.white),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      centerTitle: true,
      titleTextStyle: AppTextStyles.merriweatherBold18.copyWith(
        color: AppColors.lightPrimary,
      ),
      iconTheme: IconThemeData(color: AppColors.lightPrimary),
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        elevation: 1.2,
      ),
    ),
    iconTheme: IconThemeData(color: AppColors.whiteColor),
    textTheme: TextTheme(
      displaySmall: AppTextStyles.robotoMono10.copyWith(
        color: AppColors.whiteColor,
      ),
      labelSmall: AppTextStyles.merriweather8.copyWith(
        color: AppColors.whiteColor,
      ),
      bodyLarge: AppTextStyles.merriweather14.copyWith(
        color: AppColors.whiteColor,
      ),
      bodyMedium: AppTextStyles.merriweather12.copyWith(
        color: AppColors.whiteColor,
      ),
      bodySmall: AppTextStyles.merriweather10.copyWith(
        color: AppColors.lightPrimary,
      ),
      titleLarge: AppTextStyles.merriweatherBold20.copyWith(
        color: AppColors.lightPrimary,
      ),
    ),
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightPrimary,
      error: AppColors.errorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightBackground,
      selectedItemColor: AppColors.lightPrimary,
      unselectedItemColor: AppColors.lightPrimary.withValues(alpha: 0.6),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.lightBackground,
      textStyle: AppTextStyles.merriweather10.copyWith(
        color: AppColors.lightPrimary,
      ),
    ),
  );
}

ThemeData darkThemeData() {
  return ThemeData.dark().copyWith(
    cardColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.darkPrimary,
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(AppColors.darkPrimary),
      checkColor: WidgetStateProperty.all(Colors.white),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      centerTitle: true,
      titleTextStyle: AppTextStyles.merriweatherBold18.copyWith(
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: AppColors.whiteColor),
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkPrimary.withValues(alpha: 0.1),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        elevation: 1.2,
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.lightPrimary),
    textTheme: TextTheme(
      displaySmall: AppTextStyles.robotoMono10.copyWith(color: Colors.white),
      labelSmall: AppTextStyles.merriweather8.copyWith(color: Colors.white),
      bodyLarge: AppTextStyles.merriweather14.copyWith(color: Colors.white),
      bodyMedium: AppTextStyles.merriweather12.copyWith(color: Colors.white),
      bodySmall: AppTextStyles.merriweather10.copyWith(color: Colors.white),
      titleLarge: AppTextStyles.merriweatherBold20.copyWith(
        color: Colors.white,
      ),
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkPrimary,
      error: AppColors.errorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkBackground,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withValues(alpha: 0.6),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.darkPrimary,
      textStyle: AppTextStyles.merriweather12.copyWith(color: Colors.white),
    ),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.darkPrimary),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(8),
        shadowColor: WidgetStateProperty.all(Colors.black45),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
  );
}
