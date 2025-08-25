import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 5.w),
      child: TextButton(
        onPressed: () {
          _showResetConfirmationDialog(context);
        },
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary, // цвет текста
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: Text(
          LocaleKeys.reset.tr(),
          style: AppTextStyles.merriweatherBold12,
        ),
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    ExitConfirmationDialog.showAndHandle(context, resetQuizOnly: true);
  }
}
