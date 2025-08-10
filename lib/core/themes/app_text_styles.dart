import 'package:cdl_pro/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Заголовки (Bold)
  static TextStyle bold(double size, {Color color = Colors.black54}) =>
      TextStyle(
        fontSize: size.sp,
        fontWeight: FontWeight.bold,
        color: color,
      );

  static TextStyle regular(double size, {Color color = AppColors.softBlack}) =>
      TextStyle(
        fontSize: size.sp,
        fontWeight: FontWeight.normal,
        color: color,
      );

  // Готовые стили
  static final bold8 = bold(8.sp);
  static final bold12 = bold(12.sp);
  static final bold14 = bold(14.sp);
  static final bold16 = bold(16.sp);
  static final bold18 = bold(18.sp);
  static final bold20 = bold(20.sp);
  static final bold24 = bold(24.sp);

  static final regular8 = regular(8.sp);
  static final regular10 = regular(10.sp);
  static final regular12 = regular(12.sp);
  static final regular14 = regular(14.sp);
  static final regular16 = regular(16.sp);
  static final regular18 = regular(18.sp);
  static final regular20 = regular(20.sp);

  // Стили с GoogleFonts - Merriweather
  static TextStyle merriweather(double size,
          {Color color = AppColors.lightPrimary, FontWeight weight = FontWeight.w400}) =>
      GoogleFonts.merriweather(
        fontSize: size.sp,
        fontWeight: weight,
        color: color,
      );

  static final merriweather8 = merriweather(8.sp);
  static final merriweather10 = merriweather(10.sp);
  static final merriweather12 = merriweather(12.sp);
  static final merriweather14 = merriweather(14.sp);
  static final merriweather16 = merriweather(16.sp);
  static final merriweather18 = merriweather(18.sp);

  static final merriweatherBold12 =
      merriweather(12.sp, weight: FontWeight.bold);
  static final merriweatherBold14 =
      merriweather(14.sp, weight: FontWeight.bold);
  static final merriweatherBold16 =
      merriweather(16.sp, weight: FontWeight.bold);
  static final merriweatherBold18 =
      merriweather(18.sp, weight: FontWeight.bold);
  static final merriweatherBold20 =
      merriweather(20.sp, weight: FontWeight.bold);

  // Стили с GoogleFonts - Roboto Mono
  static TextStyle robotoMono(double size,
          {Color color = AppColors.lightPrimary, FontWeight weight = FontWeight.w400}) =>
      GoogleFonts.robotoMono(
        fontSize: size.sp,
        fontWeight: weight,
        color: color,
      );

  static final robotoMono8 = robotoMono(8.sp);
  static final robotoMono10 = robotoMono(10.sp);
  static final robotoMono12 = robotoMono(12.sp);
  static final robotoMono14 = robotoMono(14.sp);
  static final robotoMono16 = robotoMono(16.sp);
  static final robotoMono18 = robotoMono(18.sp);
  static final robotoMonoBold10 = robotoMono(12.sp, weight: FontWeight.bold);
  static final robotoMonoBold12 = robotoMono(12.sp, weight: FontWeight.bold);
  static final robotoMonoBold14 = robotoMono(14.sp, weight: FontWeight.bold);
  static final robotoMonoBold16 = robotoMono(16.sp, weight: FontWeight.bold);

 // Manrope style
  static TextStyle manrope(double size, {
    Color color = AppColors.lightPrimary, 
    FontWeight weight = FontWeight.w400,
  }) => GoogleFonts.manrope(
    fontSize: size.sp,
    fontWeight: weight,
    color: color,
  );

  // Готовые стили Manrope
  static final manrope8 = manrope(8.sp);
  static final manrope10 = manrope(10.sp);
  static final manrope12 = manrope(12.sp);
  static final manrope14 = manrope(14.sp);
  static final manrope16 = manrope(16.sp);
  static final manrope18 = manrope(18.sp);
  static final manrope20 = manrope(20.sp);

  // Жирные версии
  static final manropeBold12 = manrope(12.sp, weight: FontWeight.bold);
  static final manropeBold14 = manrope(14.sp, weight: FontWeight.bold);
  static final manropeBold16 = manrope(16.sp, weight: FontWeight.bold);
  static final manropeBold18 = manrope(18.sp, weight: FontWeight.bold);
  static final manropeBold20 = manrope(20.sp, weight: FontWeight.bold);

  // Полужирные и другие варианты (по необходимости)
  static final manropeSemiBold14 = manrope(14.sp, weight: FontWeight.w600);
  static final manropeMedium16 = manrope(16.sp, weight: FontWeight.w500);
}

