import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileView extends StatelessWidget {
  final User user;

  const ProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final email = user.email ?? '';
    final displayName = user.displayName ?? '';
    final photoUrl = user.photoURL;
    final isGoogleUser = user.providerData.any(
      (info) => info.providerId == 'google.com',
    );

    final initials =
        email.isNotEmpty ? email.substring(0, 2).toUpperCase() : 'US';

    return Stack(
      children: [
        /// Curved gradient header
        ClipPath(
          clipper: _HeaderClipper(),
          child: Container(
            height: 180.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF80D0C7), // Светлый бирюзовый
                  Color(0xFF0093E9), // Чистый голубой
                ],
              ),
            ),
          ),
        ),

        /// Main content
        Positioned.fill(
          top: 55.h,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                /// Avatar (overlaps the header)
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 96,
                    backgroundImage:
                        photoUrl != null ? NetworkImage(photoUrl) : null,
                    backgroundColor: AppColors.darkPrimary,
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
                SizedBox(height: 24.h),

                /// Name & tagline
                Text(
                  isGoogleUser ? displayName : email,
                  style: AppTextStyles.merriweatherBold16,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16.h),

                CustomActionButton(
                  text: LocaleKeys.logOut.tr(),
                  icon: Icons.logout,
                  onPressed: () {
                    context.read<ProfileBloc>().add(SignOut());
                  },
                ),

                SizedBox(height: 5.h),

                CustomActionButton(
                  backgroundColor: AppColors.errorColor,
                  text: LocaleKeys.deleteAccount.tr(),
                  icon: Icons.delete_outline,

                  isDestructive: true,
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text(LocaleKeys.confirm.tr()),
                            content: const Text(
                              'Are you sure you want to delete your account?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Delete'),
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
          ),
        ),
      ],
    );
  }
}

/// Custom clipper for the curved bottom edge of the header
class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CustomActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color? backgroundColor;
  final VoidCallback onPressed;
  final bool isDestructive;

  const CustomActionButton({
    super.key,
    required this.text,
    required this.icon,
    this.backgroundColor,
    required this.onPressed,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 8,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: backgroundColor ?? AppColors.darkPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
