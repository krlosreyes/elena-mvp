import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:elena/ui/elena_ui_system.dart';

class OnboardingStep1Screen extends StatelessWidget {
  const OnboardingStep1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const SizedBox(height: 20),
              const ElenaProgressBar(step: 1, total: 4),

              const SizedBox(height: 30),
              const ElenaSectionHeader(
                title: "Tu transformación comienza aquí ✨",
                subtitle:
                    "Vamos a analizar tu cuerpo y tus hábitos para construir un plan totalmente personalizado.",
              ),

              const SizedBox(height: 30),

              ElenaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("📏 Calcularemos tu % de grasa real",
                        style: ElenaText.subtitle),
                    SizedBox(height: 10),
                    Text("💪 Estimaremos tu masa muscular",
                        style: ElenaText.subtitle),
                    SizedBox(height: 10),
                    Text("🔥 Tus necesidades calóricas exactas",
                        style: ElenaText.subtitle),
                    SizedBox(height: 10),
                    Text("🎯 Objetivo recomendado para ti",
                        style: ElenaText.subtitle),
                    SizedBox(height: 10),
                    Text("🍽️ Recomendación de ayuno, proteína y calorías",
                        style: ElenaText.subtitle),
                  ],
                ),
              ),

              const Spacer(),

              ElenaButtonPrimary(
                text: "Comenzar ahora",
                onPressed: () => context.go('/onboarding/step2'),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
