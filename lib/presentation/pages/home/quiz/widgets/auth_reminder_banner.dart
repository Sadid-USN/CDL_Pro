import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:cdl_pro/router/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthReminderBanner extends StatelessWidget {
  const AuthReminderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // Проверка без подписки на изменения
    if (context.read<CDLTestsBloc>().uid != null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                navigateToPage(
                  context,
                  clearStack: true,
                  route: ProfileRoute(),
                );
              },
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.merriweather10.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                  children: [
                    TextSpan(text: '${LocaleKeys.logInToSaveProgress.tr()} '),
                    TextSpan(
                      text: LocaleKeys.clickToLogin.tr(),
                      style: AppTextStyles.merriweather10.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
