import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingStep4Screen extends StatelessWidget {
  const OnboardingStep4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Onboarding Paso 4 - Resultados"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text("Finalizar y continuar"),
            ),
          ],
        ),
      ),
    );
  }
}
