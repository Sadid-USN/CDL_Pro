import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/constants/constants.dart';
import 'package:cdl_pro/core/themes/themes.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';

import 'package:cdl_pro/router/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/svg.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.user != null) {
          // Очистим поля только при успешной авторизации
          emailController.clear();
          passwordController.clear();
        }

        // if (state.user == null && state.errorMessage == null) {
        //   context.router.replaceAll([const ProfileRoute()]);
        // }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state.user == null) {
          return _buildLoginForm(context, state.errorMessage);
        }
        return _buildProfileView(context, state.user!);
      },
    );
  }

  Widget _buildLoginForm(BuildContext context, String? errorMessage) {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    LocaleKeys.login.tr(),
                    style: AppTextStyles.merriweatherBold16,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        errorMessage,
                        style: AppTextStyles.manrope14.copyWith(
                          color: AppColors.errorColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  AppTextFormField(
                    controller: emailController,
                    hint: LocaleKeys.enterEmail.tr(),
                    textInputType: TextInputType.emailAddress,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return LocaleKeys.enterEmail.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  AppTextFormField(
                    controller: passwordController,
                    hint: LocaleKeys.password.tr(),
                    obscureText: true,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return LocaleKeys.enterPassword.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ProfileBloc>().add(
                          SignInWithEmailAndPassword(
                            emailController.text.trim(),
                            passwordController.text,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(LocaleKeys.login.tr()),
                  ),
                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {},
                    child: Text(
                      LocaleKeys.forgotPassword.tr(),
                      style: AppTextStyles.manropeBold12,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.router.push(const SignUpRoute());
                    },
                    child: Text(
                      LocaleKeys.signUp.tr(),
                      style: AppTextStyles.manropeBold12,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<ProfileBloc>().add(SignInWithGoogle());
                          },
                          icon: SvgPicture.asset(
                            AppLogos.googleIcon,
                            height: 24,
                          ),
                          label: Text(
                            "Google",
                            style: AppTextStyles.regular12.copyWith(
                              color: AppColors.darkBackground,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            backgroundColor: AppColors.whiteColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<ProfileBloc>().add(SignInWithApple());
                          },
                          icon: SvgPicture.asset(
                            AppLogos.appleIcon,
                            height: 24,
                          ),
                          label: Text(
                            "Apple ID",
                            style: AppTextStyles.regular12.copyWith(
                              color: AppColors.darkBackground,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            backgroundColor: AppColors.whiteColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileView(BuildContext context, User user) {
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
                          content: Text(
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
                        SnackBar(content: Text('deleteAccountError')),
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
