import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/errors/error.dart';
import 'package:cdl_pro/core/themes/themes.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:cdl_pro/router/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _signUpFormKey = GlobalKey<FormState>();
  final signUpemailController = TextEditingController();
  final signUppasswordController = TextEditingController();

  bool _shouldNavigateToProfile(ProfileState state) {
    return !state.isLoading && state.user != null && state.errorMessage == null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (_shouldNavigateToProfile(state)) {
          _handleNavigation(context, state);
        } else {
          _showPlatformSpecificMessages(context, state);
        }
      },
      builder: (context, state) {
        return _buildSignUpForm(
          context,
          state,
          signUpemailController,
          signUppasswordController,
        );
      },
    );
  }

  void _handleNavigation(BuildContext context, ProfileState state) {
    if (_shouldNavigateToProfile(state)) {
      navigateToPage(context, clearStack: true, route: ProfileRoute());
    }
  }

  void _showPlatformSpecificMessages(BuildContext context, ProfileState state) {
    final error = state.errorMessage;
    if (error != null && !state.isLoading && state.user == null) {
      final email = signUpemailController.text.trim();
      final String message =
          error == FirebaseAuthErrorType.emailAlreadyInUse
              ? LocaleKeys.emailAlreadyInUse.tr(namedArgs: {'email': email})
              : FirebaseErrorHandler.getErrorKey(error);

      if (Platform.isIOS) {
        _showCupertinoAlert(context, message);
      } else {
        _showMaterialSnackBar(context, message);
      }
    }
  }

  void _showCupertinoAlert(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: Text(LocaleKeys.notification.tr()),
            content: Text(message, style: AppTextStyles.bold12),
            actions: [
              CupertinoDialogAction(
                child: Text(LocaleKeys.ok.tr()),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  void _showMaterialSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.darkPrimary,
        content: Text(
          message,
          style: AppTextStyles.manropeBold12.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  // bool _isEmailAlreadyInUseError(String error) {
  //   return error.contains('email-already-in-use') ||
  //       error.contains('Учетная запись уже существует');
  // }

  Widget _buildSignUpForm(
    BuildContext context,
    ProfileState state,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Form(
                key: _signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocaleKeys.signUp.tr(),
                      style: AppTextStyles.merriweatherBold16,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),

                    AppTextFormField(
                      controller: emailController,
                      hint: LocaleKeys.enterEmail.tr(),
                      textInputType: TextInputType.emailAddress,
                      validate: _validateEmail,
                    ),
                    const SizedBox(height: 12),

                    AppTextFormField(
                      controller: passwordController,
                      hint: LocaleKeys.password.tr(),
                      obscureText: true,
                      validate: _validatePassword,
                    ),
                    const SizedBox(height: 24),

                    _buildSignUpButton(
                      context,
                      state,
                      emailController,
                      passwordController,
                    ),
                    SizedBox(height: 10.h),

                    TextButton(
                      onPressed: () {
                     
                        navigateToPage(
                          context,
                          route: ProfileRoute(),
                          clearStack: true,
                        );
                      },
                      child: Text(
                        LocaleKeys.login.tr(),
                        style: AppTextStyles.manropeBold12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.enterEmail.tr();
    }
    if (!EmailValidator.validate(value)) {
      return LocaleKeys.invalidEmail.tr();
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.enterPassword.tr();
    }
    if (value.length < 6) {
      return LocaleKeys.passwordTooShort.tr();
    }
    return null;
  }

  Widget _buildSignUpButton(
    BuildContext context,
    ProfileState state,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) {
    return ElevatedButton(
      onPressed:
          state.isLoading
              ? null
              : () => _onSignUpPressed(
                context,
                emailController,
                passwordController,
              ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child:
          state.isLoading
              ? const CircularProgressIndicator()
              : Text(LocaleKeys.signUp.tr()),
    );
  }

  void _onSignUpPressed(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) {
    if (_signUpFormKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
        SignUpWithEmailAndPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        ),
      );
    }
  }

  // Widget _buildLoginTextButton(BuildContext context) {
  //   return TextButton(
  //     onPressed: () {
  //       context.read<ProfileBloc>().add(UpdateProfile(null));
  //       navigateToPage(context, route: ProfileRoute(), clearStack: true);
  //     },
  //     child: Text(LocaleKeys.login.tr(), style: AppTextStyles.manropeBold12),
  //   );
  // }
}
