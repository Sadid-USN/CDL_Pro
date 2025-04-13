
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
      elevation: 0.5,
      // color: AppColors.primaryBackground,
      child: ListTile(
        title: Text(
          title,
         // style: AppTextStyles.merriweather12,
        ),
        trailing: trailingIcon,
        onTap: onTap,
      ),
    );
  }
}
