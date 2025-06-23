import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AbstractProfileEvent extends Equatable {
  const AbstractProfileEvent();

  @override
  List<Object?> get props => [];
}

class RememberMeChanged extends AbstractProfileEvent {
  final bool rememberMe;

  const RememberMeChanged(this.rememberMe);
}

class DeleteAccount extends AbstractProfileEvent {}

class SignInWithEmailAndPassword extends AbstractProfileEvent {
  final String email;
  final String password;

  const SignInWithEmailAndPassword(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class SignUpWithEmailAndPassword extends AbstractProfileEvent {
  final String email;
  final String password;

  const SignUpWithEmailAndPassword(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class UpdateProfile extends AbstractProfileEvent {
  final User? user;

  const UpdateProfile(this.user);

  @override
  List<Object?> get props => [user];
}

class SignOut extends AbstractProfileEvent {}

class SignInWithGoogle extends AbstractProfileEvent {}

class SignInWithAppleEvent extends AbstractProfileEvent {}

class InitializeProfile extends AbstractProfileEvent {}
