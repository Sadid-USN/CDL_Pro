import 'package:cdl_pro/core/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String description,
  required String cancelText,
  required String confirmText,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
}) async {
  await Alert(
    context: context,
    style: AlertStyle(
      isOverlayTapDismiss: false,
      titleStyle: AppTextStyles.merriweatherBold14,
      descStyle: AppTextStyles.merriweather12,
    ),
    title: "",
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: AppTextStyles.merriweatherBold14),
        const SizedBox(height: 12),
        Text(
          description,
          style: AppTextStyles.merriweather12,
          textAlign: TextAlign.left,
        ),
      ],
    ),
    buttons: [
      DialogButton(
        onPressed: () {
          Navigator.of(context).pop();
          onCancel?.call();
        },
        color: AppColors.lightPrimary,
        child: Text(
          cancelText,
          style: AppTextStyles.merriweather12.copyWith(
            color: AppColors.lightBackground,
          ),
        ),
      ),
      DialogButton(
        onPressed: () {
          Navigator.of(context).pop();
          onConfirm();
        },
        color: AppColors.lightPrimary,
        child: Text(
          confirmText,
          style: AppTextStyles.merriweather12.copyWith(
            color: AppColors.lightBackground,
          ),
        ),
      ),
    ],
  ).show();
}
