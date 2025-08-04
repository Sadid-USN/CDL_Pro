import 'package:cdl_pro/core/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElevatedContainer extends StatelessWidget {
  final VoidCallback onTap;
  final String assetImage;
  final double? height;
  final Widget child;

  const ElevatedContainer({
    super.key,
    required this.onTap,
    required this.assetImage,
    required this.child,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.5,
      borderRadius: BorderRadius.circular(100.r), // Circular shape
      child: InkWell(
        borderRadius: BorderRadius.circular(100.r),
        onTap: onTap,
        child: Container(
          height: height ?? 150.h, // Adjust height as needed
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.greyshade400, AppColors.lightPrimary],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Circular image container

              // Text content
              DefaultTextStyle.merge(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                child: child,
              ),

              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(assetImage),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.white, width: 2.w),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
