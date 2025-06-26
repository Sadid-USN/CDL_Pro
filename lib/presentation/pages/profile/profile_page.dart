import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:cdl_pro/presentation/pages/profile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

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
  void initState() {
    super.initState();

    final bloc = context.read<ProfileBloc>();
    final state = bloc.state;

    // Сразу устанавливаем текст при инициализации, если включен rememberMe
    if (state.rememberMe) {
      emailController.text = bloc.getSavedEmail() ?? '';
      passwordController.text = bloc.getSavedPassword() ?? '';
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.rememberMe) {
          final bloc = context.read<ProfileBloc>();
          emailController.text = bloc.getSavedEmail() ?? '';
          passwordController.text = bloc.getSavedPassword() ?? '';
        } else {
          // Очищаем только если пользователь точно отключил "Запомнить меня"
          emailController.clear();
          passwordController.clear();
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        buildWhen:
            (previous, current) =>
                previous.user != current.user ||
                previous.isLoading != current.isLoading,
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: Lottie.asset(
                "assets/lottie/moving_truck.json",
                height: 150.h,
                repeat: false,
              ),
            );
          }

          return state.user == null
              ? LoginView(
                formKey: _formKey,
                emailController: emailController,
                passwordController: passwordController,
                error: state.errorMessage,
                state: state,
              )
              : ProfileView(user: state.user!);
        },
      ),
    );
  }
}
