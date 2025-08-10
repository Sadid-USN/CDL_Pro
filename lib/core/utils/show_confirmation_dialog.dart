import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:cdl_pro/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExitConfirmationDialog extends StatelessWidget {
  final bool resetQuizOnly;
  const ExitConfirmationDialog({super.key, this.resetQuizOnly = false});

  static Future<void> showAndHandle(
    BuildContext context, {
    bool resetQuizOnly = false,
  }) async {
    // Достаём данные до async gap
    final bloc = context.read<CDLTestsBloc>();
    final uid = bloc.uid;
    final bool isLoggedIn = uid != null;

    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
              scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
              child: ExitConfirmationDialog(resetQuizOnly: resetQuizOnly),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );

    final bool confirmed = result ?? false;
    if (!context.mounted) return;

    if (confirmed) {
      if (resetQuizOnly) {
        bloc.add(ResetQuizEvent());
        return; // без навигации
      }

      if (isLoggedIn) {
        bloc.add(SaveQuizProgressEvent());
        navigateToPage(
          context,
          routeName: 'MainCategoryRoute',
          popUntilNamed: true,
        );
      } else {
        navigateToPage(context, route: const ProfileRoute(), clearStack: true);
      }
    } else {
      if (!isLoggedIn && !resetQuizOnly) {
        navigateToPage(
          context,
          routeName: 'MainCategoryRoute',
          popUntilNamed: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = context.read<CDLTestsBloc>().uid;
    final bool isLoggedIn = uid != null;

    late final String titleText;
    late final String descriptionText;
    late final String confirmText;
    late final String cancelText;
    late final IconData icon;

    if (resetQuizOnly) {
      // Сценарий сброса викторины
      icon = Icons.refresh_rounded;
      titleText = LocaleKeys.resetQuiz.tr();
      descriptionText =
          LocaleKeys.areYouSureYouWantToRestartQuiz.tr(); // "Вы уверены, что хотите начать викторину с начала?"
      confirmText = LocaleKeys.yes.tr();
      cancelText = LocaleKeys.no.tr();
    } else if (isLoggedIn) {
      // Сценарий выхода залогиненного пользователя
      icon = Icons.exit_to_app_rounded;
      titleText = LocaleKeys.exit.tr();
      descriptionText = LocaleKeys.areYouSureYouWantToExit.tr();
      confirmText = LocaleKeys.yes.tr();
      cancelText = LocaleKeys.no.tr();
    } else {
      // Сценарий выхода незалогиненного пользователя
      icon = Icons.exit_to_app_rounded;
      titleText = LocaleKeys.dontLoseProgress.tr();
      descriptionText = ''; // можно без подзаголовка
      confirmText = LocaleKeys.login.tr();
      cancelText = LocaleKeys.exit.tr();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 50.sp,
            color: AppColors.lightPrimary,
          ),
          SizedBox(height: 16.h),
          Text(
            titleText,
            style: AppTextStyles.merriweatherBold16.copyWith(
              color: AppColors.softBlack,
            ),
            textAlign: TextAlign.center,
          ),
          if (descriptionText.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              descriptionText,
              style: AppTextStyles.merriweather12.copyWith(
                color: AppColors.greyshade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    cancelText,
                    style: AppTextStyles.bold12.copyWith(
                      color: AppColors.lightBackground,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    confirmText,
                    style: AppTextStyles.bold12.copyWith(
                      color: AppColors.lightBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
