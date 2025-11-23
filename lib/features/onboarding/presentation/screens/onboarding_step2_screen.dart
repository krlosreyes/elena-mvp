import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../onboarding/providers/onboarding_provider.dart';
import 'package:elena/ui/elena_ui_system.dart';
import 'package:elena/ui/layouts/elena_centered_layout.dart';

class OnboardingStep2Screen extends ConsumerStatefulWidget {
  const OnboardingStep2Screen({super.key});

  @override
  ConsumerState<OnboardingStep2Screen> createState() =>
      _OnboardingStep2ScreenState();
}

class _OnboardingStep2ScreenState
    extends ConsumerState<OnboardingStep2Screen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  DateTime? birthDate;
  String? identity;

  int _calculateAge(DateTime birth) {
    final now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(now.year - 80),
      lastDate: DateTime(now.year - 15),
    );

    if (picked != null) {
      setState(() => birthDate = picked);
    }
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;

    if (identity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona cómo te defines")),
      );
      return;
    }

    if (birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona tu fecha de nacimiento")),
      );
      return;
    }

    final age = _calculateAge(birthDate!);

    ref.read(onboardingProvider.notifier).setBasicData(
          name: nameController.text.trim(),
          age: age,
          sex: identity!,
          weight: double.parse(weightController.text.trim()),
          height: double.parse(heightController.text.trim()),
        );

    context.go('/onboarding/step3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: SafeArea(
        child: ElenaCenteredLayout(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                const ElenaProgressBar(step: 2, total: 4),
                const SizedBox(height: 30),

                const ElenaSectionHeader(
                  title: "¿Cómo quieres que te llamemos? 🙂",
                  subtitle:
                      "Vamos a conocerte un poco mejor para personalizar tu experiencia.",
                ),

                const SizedBox(height: 30),

                ElenaCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ElenaInput(
                          controller: nameController,
                          label: "Nombre",
                          validator: (v) =>
                              v == null || v.isEmpty ? "Campo requerido" : null,
                        ),

                        const SizedBox(height: 20),

                        // Fecha nacimiento
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Fecha de nacimiento",
                              style: ElenaText.label),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: _pickBirthDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              birthDate == null
                                  ? "Selecciona una fecha"
                                  : "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("¿Cómo te defines?",
                              style: ElenaText.label),
                        ),

                        RadioListTile<String>(
                          title: const Text("Hombre"),
                          value: "male",
                          groupValue: identity,
                          onChanged: (v) => setState(() => identity = v),
                        ),
                        RadioListTile<String>(
                          title: const Text("Mujer"),
                          value: "female",
                          groupValue: identity,
                          onChanged: (v) => setState(() => identity = v),
                        ),
                        RadioListTile<String>(
                          title: const Text("Otro"),
                          value: "other",
                          groupValue: identity,
                          onChanged: (v) => setState(() => identity = v),
                        ),

                        const SizedBox(height: 20),

                        ElenaInput(
                          controller: weightController,
                          label: "Peso (kg)",
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Campo requerido";
                            final n = double.tryParse(v);
                            if (n == null || n < 35 || n > 250) {
                              return "Peso inválido";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        ElenaInput(
                          controller: heightController,
                          label: "Altura (cm)",
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Campo requerido";
                            final n = double.tryParse(v);
                            if (n == null || n < 130 || n > 230) {
                              return "Altura inválida";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                ElenaButtonPrimary(text: "Siguiente", onPressed: _next),
                const SizedBox(height: 20),
                ElenaButtonSecondary(
                  text: "Volver",
                  onPressed: () => context.go('/onboarding/step1'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
