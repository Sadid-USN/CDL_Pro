import 'package:cdl_pro/core/errors/error.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileState extends Equatable {
  final User? user;
  final bool isLoading;
  final FirebaseAuthErrorType? errorMessage;
  final bool isNewUser;
  final bool rememberMe;


  const ProfileState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isNewUser = true,
    this.rememberMe = false,

  });

  ProfileState copyWith({
    User? user,
    bool? isLoading,
    FirebaseAuthErrorType? errorMessage,
    bool? isNewUser,
    AbstractProfileEvent? lastEvent,
    bool? rememberMe,
    bool? shouldClearLoginFields,
  }) {
    return ProfileState(

      rememberMe: rememberMe ?? this.rememberMe,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isNewUser: isNewUser ?? this.isNewUser,
      // lastEvent: lastEvent ?? this.lastEvent,
    );
  }

  @override
  List<Object?> get props => [
    user?.uid,
    isLoading,
    errorMessage,
    isNewUser,
    rememberMe,
  
  ];
}
