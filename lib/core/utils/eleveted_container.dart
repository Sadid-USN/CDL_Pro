import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElevatedContainer extends StatelessWidget {
  final VoidCallback onTap;
  final String assetImage;
  final Widget child;

  const ElevatedContainer({
    super.key,
    required this.onTap,
    required this.assetImage,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.5,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.r),
        bottomRight: Radius.circular(20.r),
      ),
      child: InkWell(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 16 / 8,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(assetImage),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20.r),
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
