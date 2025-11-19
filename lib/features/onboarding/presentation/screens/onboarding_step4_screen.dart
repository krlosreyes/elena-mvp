import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../ui/elena_ui_system.dart';
import '../../../onboarding/providers/onboarding_provider.dart';
import '../../../body_composition/services/body_composition_service.dart';

class OnboardingStep4Screen extends ConsumerWidget {
  const OnboardingStep4Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(onboardingProvider);

    // ----------------------------
    // CÁLCULOS BOOTSTRAP
    // ----------------------------
    final double bf = BodyCompositionService.calculateBodyFat(
      sex: user.sex!,
      neck: user.neck!,
      waist: user.waist!,
      hip: user.hip,
      height: user.height!,
    );

    final double fatMass = (bf / 100) * user.weight!;
    final double leanMass = user.weight! - fatMass;

    final double bmr = BodyCompositionService.calculateBMR(
      sex: user.sex!,
      weight: user.weight!,
      height: user.height!,
      age: user.age!,
    );

    final double tdee = bmr *
        BodyCompositionService.activityMultiplier(user.workoutDays ?? 3);

    final recommendedGoal =
        BodyCompositionService.recommendedGoal(bf, user.sex!);

    // Map objetivo → texto
    final Map<String, String> goalLabels = {
      "lose_fat": "Perder grasa",
      "recomposition": "Recomposición corporal",
      "gain_muscle": "Ganar músculo",
    };

    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              const ElenaProgressBar(step: 4, total: 4),
              const SizedBox(height: 30),

              ElenaSectionHeader(
                title: "Resultados iniciales",
                subtitle: "Aquí tienes tu análisis corporal actual.",
              ),

              const SizedBox(height: 25),

              // ------------------------------------------------
              // TARJETA: Composición Corporal
              // ------------------------------------------------
              ElenaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tu composición corporal", style: ElenaText.title),
                    const SizedBox(height: 12),

                    _valueRow("Grasa corporal", "${bf.toStringAsFixed(1)}%"),
                    _valueRow("Masa grasa", "${fatMass.toStringAsFixed(1)} kg"),
                    _valueRow("Masa magra", "${leanMass.toStringAsFixed(1)} kg"),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ------------------------------------------------
              // TARJETA: Metabolismo
              // ------------------------------------------------
              ElenaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Metabolismo y calorías", style: ElenaText.title),
                    const SizedBox(height: 12),

                    _valueRow("BMR (reposo)", "${bmr.toStringAsFixed(0)} kcal"),
                    _valueRow("TDEE (día normal)", "${tdee.toStringAsFixed(0)} kcal"),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ------------------------------------------------
              // TARJETA: Objetivo recomendado
              // ------------------------------------------------
              ElenaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Objetivo recomendado", style: ElenaText.title),
                    const SizedBox(height: 8),

                    Text(
                      goalLabels[recommendedGoal]!,
                      style: ElenaText.title.copyWith(color: ElenaColors.primary),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      _goalExplanation(recommendedGoal),
                      style: ElenaText.subtitle,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ------------------------------------------------
              // BOTÓN FINAL
              // ------------------------------------------------
              ElenaButtonPrimary(
                text: "Continuar al Panel",
                onPressed: () => context.go('/dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _valueRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: ElenaText.subtitle),
          Text(value, style: ElenaText.label),
        ],
      ),
    );
  }

  String _goalExplanation(String g) {
    switch (g) {
      case "lose_fat":
        return "Tu porcentaje de grasa está por encima del rango óptimo. Vamos a enfocarnos en reducirla de forma sostenible.";
      case "recomposition":
        return "Estás dentro de un rango saludable. Podemos ganar músculo mientras reduces un poco de grasa.";
      case "gain_muscle":
        return "Tu porcentaje de grasa es bajo. La prioridad será aumentar masa muscular.";
      default:
        return "";
    }
  }
}
