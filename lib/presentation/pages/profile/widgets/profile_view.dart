import 'dart:io';
import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:cdl_pro/presentation/pages/profile/widgets/widgets.dart';
import 'package:cdl_pro/presentation/pages/settings/widgets/widgets.dart';
import 'package:cdl_pro/router/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProfileView extends StatelessWidget {
  final User user;

  const ProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final email = user.email ?? '';

    return Column(
      children: [
        VersionUpdateBanner(),

        UserProfileHeader(
          photoUrl: user.photoURL,
          displayName: user.displayName ?? '',
          email: user.email ?? '',
          uid: user.uid,
          isGoogleUser: user.providerData.any(
            (info) => info.providerId == 'google.com',
          ),
          initials:
              email.isNotEmpty ? email.substring(0, 2).toUpperCase() : 'US',
        ),
        SizedBox(height: 16.h),

        Column(
          children: [
            CustomActionButton(
              text: LocaleKeys.privacyPolicy.tr(),
              leadingIcon: Icons.privacy_tip_outlined,
              onTap: () {
                navigateToPage(
                  context,
                  route: PolicyRoute(type: PolicyType.privacyPolicy),
                );
              },
            ),
            CustomActionButton(
              text: LocaleKeys.termsOfUse.tr(),
              leadingIcon: Icons.description_outlined,
              onTap: () {
                navigateToPage(
                  context,
                  route: PolicyRoute(type: PolicyType.termsOfUse),
                );
              },
            ),
            CustomActionButton(
              text: LocaleKeys.contactUs.tr(),
              leadingIcon: Icons.email_outlined,
              onTap: () {
                AppLauncher.contactUs();
              },
            ),
            CustomActionButton(
              text: LocaleKeys.logOut.tr(),
              leadingIcon: Icons.logout,
              onTap: () {
                context.read<ProfileBloc>().add(SignOut());
                _showPlatformSnackBar(context);
              },
            ),
            CustomActionButton(
              text: LocaleKeys.deleteAccount.tr(),
              leadingIcon: Icons.delete_outline,
              isDestructive: true,
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text(
                          LocaleKeys.attention.tr(),
                          style: AppTextStyles.regular14.copyWith(
                            color: AppColors.errorColor,
                          ),
                        ),
                        content: Text(
                          LocaleKeys.deleteAccountAlert.tr(),
                          style: AppTextStyles.regular12,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(LocaleKeys.cancel.tr()),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: Text(LocaleKeys.delete.tr()),
                          ),
                        ],
                      ),
                );

                if (confirmed == true && context.mounted) {
                  context.read<ProfileBloc>().add(DeleteAccount());
                }
              },
            ),
          ],
        ),
        const Spacer(),

        Center(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width / 5,
            child: FutureBuilder<String>(
              future: AppVersionUtil.getAppVersion(),
              builder: (context, snapshot) {
                return CustomActionButton(
                  text: snapshot.data ?? '--',
                  trailingIcon: null,
                  onTap: null,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showPlatformSnackBar(BuildContext context) {
    if (Platform.isIOS) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: LocaleKeys.loggedOutText.tr(),
          backgroundColor: AppColors.lightPrimary,
          textStyle: const TextStyle(color: Colors.white),
        ),
      );
    } else {
      showTopSnackBar(
        snackBarPosition: SnackBarPosition.bottom,
        Overlay.of(context),
        CustomSnackBar.success(
          message: LocaleKeys.loggedOutText.tr(),
          backgroundColor: AppColors.lightPrimary,
          textStyle: const TextStyle(color: Colors.white),
        ),
      );
    }
  }
}

/// Custom clipper for the curved bottom edge of the header
