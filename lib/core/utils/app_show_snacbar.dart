import 'dart:io';
import 'package:cdl_pro/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppShowSnackBar {
  static void show(BuildContext context, String message) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          insetAnimationCurve: Curves.easeIn,
          title: Text("LocaleKeys.attention.tr()"),
          content: Text(
            message,
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                "ОК",
                style: AppTextStyles.merriweather(10.sp,
                    // color: AppColors.blueColor
                    
                    ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.darkBackground.withValues(alpha: 0.5),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          elevation: 10,
        ),
      );
    }
  }
}
