import 'package:cdl_pro/core/constants/constants.dart';
import 'package:cdl_pro/core/themes/themes.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GalleryButton extends StatelessWidget {
  final List<String>? images;
  const GalleryButton({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    if (images == null || images!.isEmpty) return const SizedBox.shrink();

    return ElevatedButton(
      onPressed: () {
        context.pushRoute(ImagesRoute(imageUrls: images!));
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.view.tr(),
            style: AppTextStyles.merriweather10.copyWith(
              color: AppColors.lightBackground,
            ),
          ),
          SizedBox(width: 8.w),
          SvgPicture.asset(
            AppLogos.gallery,
            height: 16.h,
            colorFilter: const ColorFilter.mode(
              AppColors.lightBackground,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
