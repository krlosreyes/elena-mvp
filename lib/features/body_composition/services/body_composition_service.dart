import 'dart:math';

double log10(num x) => log(x) / ln10;

class BodyCompositionService {
  // Navy Method (US Navy formula)
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

  // BMR
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

  // TDEE multiplier
  static double activityMultiplier(int workoutDays) {
    if (workoutDays == 0) return 1.35;
    if (workoutDays <= 2) return 1.45;
    if (workoutDays <= 4) return 1.55;
    if (workoutDays <= 6) return 1.65;
    return 1.75;
  }

  // Objetivo recomendado automático
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
}
