import 'dart:math';

double log10(num x) => log(x) / ln10;

class BodyCompositionService {

  // -------------------------------------------
  // % GRASA - Navy Method
  // -------------------------------------------
  static double calculateBodyFat({
    required String sex,
    required double neck,
    required double waist,
    double? hip,
    required double height,
  }) {
    if (sex == "male") {
      return 86.010 * log10(waist - neck) -
          70.041 * log10(height) +
          36.76;
    } else {
      return 163.205 * log10(waist + (hip ?? 0) - neck) -
          97.684 * log10(height) -
          78.387;
    }
  }

  // -------------------------------------------
  // BMR - Mifflin St Jeor
  // -------------------------------------------
  static double calculateBMR({
    required String sex,
    required double weight,
    required double height,
    required int age,
  }) {
    if (sex == "male") {
      return 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      return 10 * weight + 6.25 * height - 5 * age - 161;
    }
  }

  // -------------------------------------------
  // TDEE
  // -------------------------------------------
  static double activityMultiplier(int workoutDays) {
    if (workoutDays == 0) return 1.35;
    if (workoutDays <= 2) return 1.45;
    if (workoutDays <= 4) return 1.55;
    if (workoutDays <= 6) return 1.65;
    return 1.75;
  }

  // -------------------------------------------
  // META AUTOMÁTICA
  // -------------------------------------------
  static String recommendedGoal(double bf, String sex) {
    if (sex == "male") {
      if (bf >= 25) return "lose_fat";
      if (bf >= 15) return "recomposition";
      return "gain_muscle";
    } else {
      if (bf >= 32) return "lose_fat";
      if (bf >= 22) return "recomposition";
      return "gain_muscle";
    }
  }

  // -------------------------------------------
  // CALORÍAS OBJETIVO
  // -------------------------------------------
  static double calculateCalorieGoal({
    required double tdee,
    required String goal,
  }) {
    switch (goal) {
      case "lose_fat":
        return tdee - 300;
      case "gain_muscle":
        return tdee + 300;
      default:
        return tdee - 200; // recomposición
    }
  }

  // -------------------------------------------
  // PROTEÍNA
  // -------------------------------------------
  static double proteinTarget(double leanMassKg) {
    return leanMassKg * 2.0;
  }

  // -------------------------------------------
  // TARGET BODYFAT
  // -------------------------------------------
  static double targetBodyFat(String sex, double currentBf) {
    if (sex == "male") {
      if (currentBf >= 25) return 15;
      if (currentBf >= 15) return 12;
      return 10;
    } else {
      if (currentBf >= 32) return 22;
      if (currentBf >= 22) return 20;
      return 18;
    }
  }

  // -------------------------------------------
  // OBJETIVO DE MASA MAGRA
  // -------------------------------------------
  static double leanMassTargetGain(String goal) {
    if (goal == "gain_muscle") return 2.5;
    if (goal == "recomposition") return 1.5;
    return 0.5; // perder grasa
  }
}
