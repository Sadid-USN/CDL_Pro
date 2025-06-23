import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/core/errors/error.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:cdl_pro/presentation/pages/pages.dart';
import 'package:cdl_pro/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginView extends StatelessWidget {
  const LoginView({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.error,
    required this.state,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FirebaseAuthErrorType? error;
  final ProfileState state;

  @override
  Widget build(BuildContext context) {
    final errorText = switch (error) {
      FirebaseAuthErrorType.wrongPassword ||
      FirebaseAuthErrorType.userNotFound ||
      FirebaseAuthErrorType
          .invalidEmail => FirebaseErrorHandler.getErrorKey(error!),
      _ => null,
    };

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
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    LocaleKeys.login.tr(),
                    style: AppTextStyles.merriweatherBold16,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  if (errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        errorText,
                        style: AppTextStyles.manrope14.copyWith(
                          color: AppColors.errorColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  AppTextFormField(
                    textStyle: AppTextStyles.merriweather14,
                    
                    controller: emailController,
                    hint: LocaleKeys.enterEmail.tr(),
                    textInputType: TextInputType.emailAddress,
                    validate:
                        (value) =>
                            value == null || value.isEmpty
                                ? LocaleKeys.enterEmail.tr()
                                : null,
                  ),
                  const SizedBox(height: 12),

                  AppTextFormField(
                     textStyle: AppTextStyles.merriweather14,
                    controller: passwordController,
                    hint: LocaleKeys.password.tr(),
                    obscureText: true,
                    validate:
                        (value) =>
                            value == null || value.isEmpty
                                ? LocaleKeys.enterPassword.tr()
                                : null,
                  ),

                  //?------------ RememberMeButton -----------//
                  SizedBox(height: 5.h),
                  RememberMeButton(),
                  SizedBox(height: 12.h),

                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<ProfileBloc>().add(
                          SignInWithEmailAndPassword(
                            emailController.text,
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
                            context.read<ProfileBloc>().add(
                              SignInWithAppleEvent(),
                            );
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
}
