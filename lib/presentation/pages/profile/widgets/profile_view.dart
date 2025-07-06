import 'dart:io';
import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
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
                    backgroundColor: AppColors.lightPrimary,
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
                Text(
                  LocaleKeys.welcome.tr(
                    namedArgs: {"email": isGoogleUser ? displayName : email},
                  ),
                  style: AppTextStyles.merriweatherBold16.copyWith(
                    height:
                        1.7, // Умножает высоту строки на 1.5 (рекомендуется 1.2-1.5)
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 16.h),

                CustomActionButton(
                  backgroundColor: AppColors.lightPrimary,
                  text: LocaleKeys.logOut.tr(),
                  icon: Icons.logout,
                  onPressed: () {
                    context.read<ProfileBloc>().add(SignOut());
                    _showPlatformSnackBar(context);
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
                // BlocBuilder<CDLTestsBloc, AbstractCDLTestsState>(
                //   builder: (context, state) {
                //     final mistakesCount =
                //         context.read<CDLTestsBloc>().getMistakesCount();
                //     if (mistakesCount == 0) return SizedBox.shrink();

                //     return Container(
                //       width: double.infinity,
                //       margin: EdgeInsets.symmetric(vertical: 8),
                //       child: ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.white,
                //           foregroundColor: AppColors.lightPrimary,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(20),
                //             side: BorderSide(color: AppColors.errorColor),
                //           ),
                //           padding: EdgeInsets.symmetric(vertical: 12),
                //         ),
                //         onPressed: () {
                //           final bloc = context.read<CDLTestsBloc>();
                //           final mistakes = bloc.getMistakes();

                //           // Создаем Map вопросов с ключами в формате "mistake_$index"
                //           final mistakesMap = {
                //             for (int i = 0; i < mistakes.length; i++)
                //               'mistake_$i': mistakes[i],
                //           };

                //           // Создаем временную главу для ошибок
                //           final mistakesChapter = TestChapter(
                //             freeLimit: mistakes.length, // Все вопросы доступны
                //             total: mistakes.length,
                //             questions: mistakesMap,
                //           );

                //           // Создаем временную структуру глав с одной заполненной главой
                //           final tempChapters = Chapters(
                //             generalKnowledge: mistakesChapter,
                //             combination: TestChapter(
                //               freeLimit: 0,
                //               total: 0,
                //               questions: {},
                //             ),
                //             airBrakes: TestChapter(
                //               freeLimit: 0,
                //               total: 0,
                //               questions: {},
                //             ),
                //             tanker: TestChapter(
                //               freeLimit: 0,
                //               total: 0,
                //               questions: {},
                //             ),
                //             doubleAndTriple: TestChapter(
                //               freeLimit: 0,
                //               total: 0,
                //               questions: {},
                //             ),
                //             hazMat: TestChapter(
                //               freeLimit: 0,
                //               total: 0,
                //               questions: {},
                //             ),
                //           );

                //           // Создаем временную модель данных
                //           final tempModel = TestsDataModel(
                //             chapters: tempChapters,
                //           );

                //           navigateToPage(
                //             context,
                //             route: QuizRoute(
                //               chapterTitle: 'workOnMistakes',
                //               questions: mistakes,
                //               startIndex: 0,
                //               categoryKey: 'mistakes',
                //               model: tempModel,
                //             ),
                //           );
                //         },
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               'workOnMistakes',
                //               style: AppTextStyles.merriweatherBold16.copyWith(
                //                 color: AppColors.lightPrimary,
                //               ),
                //             ),
                //             Container(
                //               padding: EdgeInsets.all(8),
                //               decoration: BoxDecoration(
                //                 color: AppColors.errorColor,
                //                 shape: BoxShape.circle,
                //               ),
                //               child: Text(
                //                 mistakesCount.toString(),
                //                 style: AppTextStyles.merriweatherBold16
                //                     .copyWith(color: Colors.white),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     );
                //   },
                // ),
              
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPlatformSnackBar(BuildContext context) {
    if (Platform.isIOS) {
      // iOS-style Toast (вверху экрана)
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: LocaleKeys.loggedOutText.tr(),
          backgroundColor: AppColors.lightPrimary,
          textStyle: TextStyle(color: Colors.white),
        ),
      );
    } else {
      // Android-style SnackBar (внизу)
      showTopSnackBar(
        snackBarPosition: SnackBarPosition.bottom,
        Overlay.of(context),
        CustomSnackBar.success(
          message: LocaleKeys.loggedOutText.tr(),
          backgroundColor: AppColors.lightPrimary,
          textStyle: TextStyle(color: Colors.white),
        ),
      );
    }
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
