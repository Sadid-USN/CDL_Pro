import 'package:cdl_pro/core/themes/themes.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UserProfileHeader extends StatelessWidget {
  final String? photoUrl;
  final String displayName;
  final String email;
  final String uid;
  final bool isGoogleUser;
  final String initials;

  const UserProfileHeader({
    super.key,
    required this.photoUrl,
    required this.displayName,
    required this.email,
    required this.uid,
    required this.isGoogleUser,
    required this.initials,
  });

  void _showCopySuccessNotification(BuildContext context) {
    final overlay = Overlay.of(context);

    showTopSnackBar(
      overlay,
      CustomSnackBar.info(
        message: LocaleKeys.copied.tr(),
        backgroundColor: AppColors.lightPrimary.withValues(alpha: 0.5),
        textStyle: AppTextStyles.merriweatherBold14.copyWith(
          color: AppColors.lightBackground,
        ),
      ),
      snackBarPosition: SnackBarPosition.bottom,
      animationDuration: Duration(milliseconds: 300),
      displayDuration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: uid));
        _showCopySuccessNotification(context);
      },
      child: Stack(
        children: [
          // Curved gradient header background
          ClipPath(
            clipper: _HeaderClipper(),
            child: Container(
              height: 150.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.lightPrimary, AppColors.lightPrimary],
                ),
              ),
            ),
          ),

          // User info overlay
          Positioned(
            top: 25.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // User avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 47,
                    backgroundImage:
                        photoUrl != null ? NetworkImage(photoUrl!) : null,
                    backgroundColor: AppColors.softBlack,
                    child:
                        photoUrl == null
                            ? Text(
                              initials,
                              style: AppTextStyles.merriweatherBold20.copyWith(
                                color: AppColors.lightBackground,
                              ),
                            )
                            : null,
                  ),
                ),

                SizedBox(height: 8.h),

                // User name/email
                Text(
                  isGoogleUser ? displayName : email,
                  style: AppTextStyles.merriweather12.copyWith(
                    height: 1.6,
                    color: AppColors.lightBackground,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                // User ID with copy icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ID: ',
                      style: AppTextStyles.regular8.copyWith(
                        color: AppColors.lightBackground,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      uid,
                      style: AppTextStyles.regular8.copyWith(
                        color: AppColors.lightBackground,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.copy, size: 12.h),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 0);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
