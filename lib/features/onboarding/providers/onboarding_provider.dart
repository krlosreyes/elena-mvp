import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/onboarding_model.dart';

class OnboardingNotifier extends StateNotifier<OnboardingModel> {
  // Estado inicial seguro
  OnboardingNotifier() : super(const OnboardingModel());

  // Paso 1: objetivo
  void setGoal(String goal) {
    state = state.copyWith(goal: goal);
  }

  // Paso 2: datos personales
  void setBasicData({
    required String name,
    required int age,
    required String sex,
    required double weight,
    required double height,
  }) {
    state = state.copyWith(
      name: name,
      age: age,
      sex: sex,
      weight: weight,
      height: height,
    );
  }

  // Paso 3: medidas, actividad, ayuno
  void setMeasurements({
    required double neck,
    required double waist,
    double? hip,
    required int workoutDays,
    required bool doesFasting,
    String? fastingProtocol,
  }) {
    state = state.copyWith(
      neck: neck,
      waist: waist,
      hip: hip,
      workoutDays: workoutDays,
      doesFasting: doesFasting,
      fastingProtocol: fastingProtocol,
    );
  }

  // Paso 3: condiciones de salud
  void setHealthData({
    required List<String> conditions,
    String? otherCondition,
  }) {
    state = state.copyWith(
      conditions: conditions,
      otherCondition: otherCondition,
    );
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingModel>((ref) {
  return OnboardingNotifier();
});
