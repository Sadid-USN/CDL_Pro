import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileState extends Equatable {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isNewUser;

  const ProfileState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isNewUser = true,
  });

  ProfileState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    bool? isNewUser,
  }) {
    return ProfileState(
      user: user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }

  @override
  List<Object?> get props => [user, isLoading, errorMessage, isNewUser];
}
