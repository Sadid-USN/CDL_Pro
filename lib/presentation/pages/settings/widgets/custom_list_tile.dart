import 'package:cdl_pro/core/core.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final Widget trailingIcon;
  final VoidCallback onTap;

  const CustomListTile({
    super.key,
    required this.title,
    required this.trailingIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0.5,
      // color: AppColors.lightPrimary,
      child: ListTile(
        
        title: Text(
          title,
         style: TextTheme.of(context).bodyMedium,
        ),
        trailing: trailingIcon,
        onTap: onTap,
      ),
    );
  }
}
