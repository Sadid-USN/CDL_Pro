import 'package:cdl_pro/core/core.dart';
import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final String text;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? backgroundColor;
  final void Function()? onTap;
  final bool isDestructive;

  const CustomActionButton({
    super.key,
    required this.text,
    this.leadingIcon,
    this.trailingIcon,
    this.backgroundColor,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: leadingIcon != null
          ? Icon(leadingIcon, color: AppColors.greyshade600)
          : null,
      title: Text(
        text,
        style: AppTextStyles.regular12.copyWith(
          color: isDestructive
              ? AppColors.errorColor.withValues(alpha: 0.9)
              : AppColors.lightPrimary,
        ),
      ),
      trailing: trailingIcon != null
          ? Icon(trailingIcon, color: AppColors.greyshade600)
          : null,
      tileColor: Colors.transparent, // <-- убираем фон
      hoverColor: Colors.transparent, // <-- убираем подсветку при наведении (Web/Desktop)
      splashColor: Colors.transparent, // <-- убираем ripple-эффект
    
    );
  }
}
