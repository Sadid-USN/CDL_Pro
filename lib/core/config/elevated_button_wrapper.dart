import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElevatedButtonWrapper extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;

  const ElevatedButtonWrapper({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            // topRight: Radius.circular(8.r),
            // bottomLeft: Radius.circular(8.r),
            bottomRight: Radius.circular(20.r),
          ),
        ),
      ),
      child: child,
    );
  }
}
