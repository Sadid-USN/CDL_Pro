import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:cdl_pro/presentation/pages/profile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.user == null) {
          emailController.clear();
          passwordController.clear();
          // // Автоматический переход при logout/delete
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   if (state.user == null && mounted) {
          //     context.router.replaceAll([const LoginRoute()]);
          //   }
          // });
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        buildWhen: (previous, current) {
          // Перестраиваем только при изменении ключевых параметров
          return previous.user != current.user ||
              previous.isLoading != current.isLoading;
        },
        builder: (context, state) {
          debugPrint(
            'ProfilePage builder: user=${state.user?.uid}, isLoading=${state.isLoading}',
          );

          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return state.user == null
              ? LoginView(
                key: const ValueKey('LoginView'),
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
