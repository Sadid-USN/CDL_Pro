import 'package:cdl_pro/core/errors/error.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileState extends Equatable {
  final User? user;
  final bool isLoading;
  final String? savedEmail;
  final String? savedPassword;
  final FirebaseAuthErrorType? errorMessage;
  final bool isNewUser;
  final bool rememberMe;
  final bool obscurePassword;

  const ProfileState({
    this.user,
    this.savedEmail,
    this.savedPassword,
    this.isLoading = false,
    this.errorMessage,
    this.isNewUser = true,
    this.rememberMe = false,
    this.obscurePassword = true,
  });

  ProfileState copyWith({
    User? user,
    String? savedEmail,
    String? savedPassword,
    bool? isLoading,
    FirebaseAuthErrorType? errorMessage,
    bool? isNewUser,
    AbstractProfileEvent? lastEvent,
    bool? rememberMe,
    bool? obscurePassword,
    bool? shouldClearLoginFields,
  }) {
    return ProfileState(
      savedEmail: savedEmail ?? this.savedEmail,
      savedPassword: savedPassword ?? this.savedPassword,
      rememberMe: rememberMe ?? this.rememberMe,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isNewUser: isNewUser ?? this.isNewUser,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  List<Object?> get props => [
    user?.uid,
    isLoading,
    errorMessage,
    isNewUser,
    rememberMe,
    savedEmail,
    savedPassword,
    obscurePassword
  ];
}
