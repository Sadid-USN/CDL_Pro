import 'package:cdl_pro/core/errors/error.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileState extends Equatable {
  final User? user;
  final bool isLoading;
  final FirebaseAuthErrorType? errorMessage;
  final bool isNewUser;
  final AbstractProfileEvent? lastEvent;

  const ProfileState({
    this.user,
    this.lastEvent,
    this.isLoading = false,
    this.errorMessage,
    this.isNewUser = true,
  });

  ProfileState copyWith({
    User? user,
    bool? isLoading,
    FirebaseAuthErrorType? errorMessage,
    bool? isNewUser,
    AbstractProfileEvent? lastEvent,
  }) {
    return ProfileState(
      user: user,
      lastEvent: lastEvent,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }

  @override
  List<Object?> get props => [
    user,
    isLoading,
    errorMessage,
    isNewUser,
    lastEvent,
  ];
}
