import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

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
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(LocaleKeys.resetQuiz.tr()),
            content: Text(LocaleKeys.startTheQuizOverText.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(LocaleKeys.cancel.tr()),
              ),
              TextButton(
                onPressed: () {
                  context.read<CDLTestsBloc>().add(const ResetQuizEvent());
                  Navigator.of(context).pop();
                },
                child: Text(LocaleKeys.reset.tr()),
              ),
            ],
          ),
    );
  }
}
