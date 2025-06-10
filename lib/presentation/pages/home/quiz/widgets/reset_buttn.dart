import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showResetConfirmationDialog(context);
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),

        elevation: 3,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: SvgPicture.asset(
        AppLogos.reset,
        height: 22.h,
        colorFilter: ColorFilter.mode(
          AppColors.lightBackground,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    showConfirmationDialog(
      context: context,
      title: LocaleKeys.resetQuiz.tr(),
      description: LocaleKeys.startTheQuizOverText.tr(),
      cancelText: LocaleKeys.cancel.tr(),
      confirmText: LocaleKeys.reset.tr(),
      onConfirm: () {
        context.read<CDLTestsBloc>().add(const ResetQuizEvent());
        context.read<CDLTestsBloc>().add(StartTimerEvent());
      },
    );
  }
}
