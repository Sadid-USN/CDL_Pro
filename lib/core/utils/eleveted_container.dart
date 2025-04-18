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
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 2.w),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(assetImage),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.6),
                BlendMode.darken, // или multiply, overlay и др.
              ),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
