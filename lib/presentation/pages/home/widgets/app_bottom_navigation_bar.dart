import 'package:cdl_pro/core/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final TabsRouter tabsRouter;
  final List<String> svgPictures;
  final List<String> titles;
  final bool isDark;

  const AppBottomNavigationBar({
    super.key,
    this.isDark = false,
    required this.tabsRouter,
    required this.svgPictures,
    required this.titles,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(12.r),
        margin: EdgeInsets.symmetric(horizontal: 24.r),
        decoration: BoxDecoration(
          // color: isDark ? AppColors.darkPrimaryColor : AppColors.lightCardColor,
          borderRadius: BorderRadius.all(Radius.circular(24.r)),
          // boxShadow: [
          //   BoxShadow(
          //     color: AppColors.darkPrimaryColor.withValues(alpha: 0.3),
          //     offset: const Offset(0, 20),
          //     blurRadius: 20,
          //   ),
          // ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(svgPictures.length, (index) {
            return GestureDetector(
              onTap: () {
                tabsRouter.setActiveIndex(index);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    svgPictures[index],
                    height: index == tabsRouter.activeIndex ? 30.h : 25.h,
                    colorFilter: ColorFilter.mode(
                      index == tabsRouter.activeIndex
                          ? (isDark
                              ? AppColors.lightBackground
                              : AppColors
                                  .lightPrimary) // Яркий цвет для текущего индекса
                          : (isDark
                              ? AppColors.greyshade400.withValues(alpha: 0.4)
                              : AppColors
                                  .greyshade400), // Тусклый цвет для остальных индексов
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    titles[index],
                    style: AppTextStyles.merriweather8.copyWith(
                      color:
                          isDark
                              ? AppColors.lightBackground
                              : AppColors.darkBackground,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
