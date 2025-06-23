import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RememberMeButton extends StatelessWidget {
  const RememberMeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Checkbox(
              value: state.rememberMe,
              onChanged: (bool? value) {
                context.read<ProfileBloc>().add(
                  RememberMeChanged(value ?? false),
                );
              },
              fillColor: WidgetStateProperty.resolveWith<Color>((
                Set<WidgetState> states,
              ) {
                return AppColors.lightPrimary;
              }),
              checkColor: AppColors.whiteColor,
            );
          },
        ),
        Text(LocaleKeys.rememberMe.tr(), style: AppTextStyles.merriweather8),
      ],
    );
  }
}
