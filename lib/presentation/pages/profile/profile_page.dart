import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/constants/constants.dart';
import 'package:cdl_pro/core/themes/themes.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

final _formKey = GlobalKey<FormState>();

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder:
          (context, state) => Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          LocaleKeys.login.tr(),
                          style: AppTextStyles.merriweatherBold16,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),

                        /// Email field
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

                        /// Password field
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

                        /// Login button
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {}
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(LocaleKeys.login.tr()),
                        ),
                        SizedBox(height: 5.h),

                        TextButton(
                          onPressed: () {},
                          child: Text(
                            LocaleKeys.forgotPassword.tr(),
                            style: AppTextStyles.manropeBold12,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            LocaleKeys.signUp.tr(),
                            style: AppTextStyles.manropeBold12,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        /// Login via Google & Apple
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  AppLogos.googleIcon,
                                  height: 24.h,
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  AppLogos.appleIcon,
                                  height: 24.h,
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
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
          ),
    );
  }
}
