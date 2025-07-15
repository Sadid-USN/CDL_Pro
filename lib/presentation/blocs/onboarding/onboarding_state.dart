import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingLoading extends OnboardingState {}

class OnboardingRequired extends OnboardingState {}

class OnboardingCompleted extends OnboardingState {}
