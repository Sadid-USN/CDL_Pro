import 'package:cdl_pro/core/core.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isDarkMode;
  final Widget? leadingIcon;
  final Widget trailingIcon;
  final void Function()? onTap;

  const CustomListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.isDarkMode = false,
    required this.trailingIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: isDarkMode ? AppColors.softBlack : AppColors.lightPrimary,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        minLeadingWidth: 24,
        leading: leadingIcon,
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.whiteColor,
          ),
        ),
        subtitle:
            subtitle != null
                ? Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.lightBackground,
                  ),
                )
                : null,
        trailing: trailingIcon,
        onTap: onTap,
      ),
    );
  }
}
