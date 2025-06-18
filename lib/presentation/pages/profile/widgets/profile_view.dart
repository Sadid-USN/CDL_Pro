import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

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

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    photoUrl != null ? NetworkImage(photoUrl) : null,
                backgroundColor: AppColors.darkPrimary,
                child:
                    photoUrl == null
                        ? Text(
                          initials,
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        )
                        : null,
              ),
              const SizedBox(height: 20),

              Text(
                'Welcome',
                style: AppTextStyles.merriweatherBold16,
                textAlign: TextAlign.center,
              ),
              Text(
                isGoogleUser ? displayName : email,
                style: AppTextStyles.merriweatherBold16,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  context.read<ProfileBloc>().add(SignOut());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: Text(
                  'logout',
                  style: AppTextStyles.manropeBold14.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextButton(
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
                              child: Text(LocaleKeys.cancel.tr()),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(
                                'delete',
                                style: TextStyle(color: AppColors.errorColor),
                              ),
                            ),
                          ],
                        ),
                  );

                  if (confirmed == true) {
                    try {
                      await user.delete();
                      if (context.mounted) {
                        context.read<ProfileBloc>().add(SignOut());
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('deleteAccountError')),
                      );
                    }
                  }
                },
                child: Text(
                  'deleteAccount',
                  style: AppTextStyles.manropeBold14.copyWith(
                    color: AppColors.errorColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
