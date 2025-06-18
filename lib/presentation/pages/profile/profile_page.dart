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
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.user != null) {
          // Очистим поля только при успешной авторизации
          emailController.clear();
          passwordController.clear();
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state.user == null) {
          return LoginView(
            formKey: _formKey,
            emailController: emailController,
            passwordController: passwordController,
            error: state.errorMessage,
            state: state,
          );
        }
        return ProfileView(user: state.user!);
      },
    );
  }
}
