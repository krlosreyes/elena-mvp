import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../body_composition/services/body_composition_service.dart';
import '../data/models/onboarding_model.dart';

class OnboardingNotifier extends StateNotifier<OnboardingModel> {
  final Ref ref;

  OnboardingNotifier(this.ref) : super(const OnboardingModel());

  // SETTERS
  void setGoal(String goal) => state = state.copyWith(goal: goal);

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

  void setHealthData({
    required List<String> conditions,
    String? otherCondition,
  }) {
    state = state.copyWith(
      conditions: conditions,
      otherCondition: otherCondition,
    );
  }

  /// ================================================================
  /// SAVE INITIAL COMPOSITION (Web-safe)
  /// ================================================================
  Future<void> saveInitialComposition() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      print("ERROR: No hay usuario autenticado.");
      return;
    }

    try {
      final firestore = FirebaseFirestore.instance;
      final now = FieldValue.serverTimestamp();

      final bf = BodyCompositionService.calculateBodyFat(
        sex: state.sex!,
        neck: state.neck!,
        waist: state.waist!,
        hip: state.hip,
        height: state.height!,
      );

      final fatMass = (bf / 100) * state.weight!;
      final leanMass = state.weight! - fatMass;

      final bmr = BodyCompositionService.calculateBMR(
        sex: state.sex!,
        weight: state.weight!,
        height: state.height!,
        age: state.age!,
      );

      final tdee = bmr *
          BodyCompositionService.activityMultiplier(state.workoutDays ?? 3);

      final recommendedGoal =
          BodyCompositionService.recommendedGoal(bf, state.sex!);

      final calorieGoal = BodyCompositionService.calculateCalorieGoal(
        tdee: tdee,
        goal: recommendedGoal,
      );

      final proteinTarget =
          BodyCompositionService.proteinTarget(leanMass);

      final targetBF =
          BodyCompositionService.targetBodyFat(state.sex!, bf);

      final targetLeanMass =
          leanMass + BodyCompositionService.leanMassTargetGain(recommendedGoal);

      // PERFIL + METRICAS
      await firestore.collection("users").doc(uid).set({
        "profile": {
          "name": state.name,
          "age": state.age,
          "sex": state.sex,
          "goal": recommendedGoal,
          "workoutDays": state.workoutDays,
          "fastingProtocol": state.fastingProtocol,
          "createdAt": now,
          "updatedAt": now,
        },
        "metrics": {
          "bmr": bmr,
          "tdee": tdee,
          "calorieGoal": calorieGoal,
          "proteinTarget": proteinTarget,
        }
      }, SetOptions(merge: true));

      // COMPOSICIÓN INICIAL
      await firestore
          .collection("users")
          .doc(uid)
          .collection("initialComposition")
          .doc("start")
          .set({
        "date": now,
        "weight": state.weight,
        "height": state.height,
        "measurements": {
          "neck": state.neck,
          "waist": state.waist,
          "hip": state.hip,
        },
        "bodyFatPercentage": bf,
        "fatMass": fatMass,
        "leanMass": leanMass,
        "targetBodyFat": targetBF,
        "targetLeanMass": targetLeanMass,
      }, SetOptions(merge: true));

      print("🔥 Composición inicial guardada.");
    } catch (e) {
      print("🔥 ERROR guardando composición inicial: $e");
    }
  }
}


// PROVIDER
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingModel>((ref) {
  return OnboardingNotifier(ref);
});
