import 'package:cdl_pro/presentation/blocs/onboarding/onboarding.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final SharedPreferences prefs;

  OnboardingCubit({required this.prefs}) : super(OnboardingLoading());

  Future<void> checkOnboarding() async {
    try {
      final done = prefs.getBool('onboarding_done') ?? false;
      await Future.delayed(const Duration(milliseconds: 500)); // Задержка для плавности
      
      if (done) {
        emit(OnboardingCompleted());
      } else {
        emit(OnboardingRequired());
      }
    } catch (e) {
      emit(OnboardingRequired()); // В случае ошибки показываем onboarding
    }
  }

  Future<void> completeOnboarding() async {
    try {
      await prefs.setBool('onboarding_done', true);
      emit(OnboardingCompleted());
    } catch (e) {
      // Обработка ошибки
      emit(OnboardingRequired());
    }
  }

  // Для тестирования/разработки
  Future<void> resetOnboarding() async {
    await prefs.remove('onboarding_done');
    emit(OnboardingRequired());
  }
}