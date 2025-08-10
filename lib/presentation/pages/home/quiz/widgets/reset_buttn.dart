import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showResetConfirmationDialog(context);
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),

        elevation: 3,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: SvgPicture.asset(
        AppLogos.reset,
        height: 22.h,
        colorFilter: ColorFilter.mode(
          AppColors.lightBackground,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    ExitConfirmationDialog.showAndHandle(context, resetQuizOnly: true);
  }
}
