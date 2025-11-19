import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../ui/elena_ui_system.dart';
import '../../../onboarding/providers/onboarding_provider.dart';

class OnboardingStep3Screen extends ConsumerStatefulWidget {
  const OnboardingStep3Screen({super.key});

  @override
  ConsumerState<OnboardingStep3Screen> createState() =>
      _OnboardingStep3ScreenState();
}

class _OnboardingStep3ScreenState
    extends ConsumerState<OnboardingStep3Screen> {
  final _formKey = GlobalKey<FormState>();

  // Inputs
  final neckController = TextEditingController();
  final waistController = TextEditingController();
  final hipController = TextEditingController();
  final otherConditionController = TextEditingController();

  // Lifestyle
  int workoutDays = 3;
  bool doesFasting = false;
  String? protocol;

  // Health
  List<String> selectedConditions = [];

  final List<Map<String, String>> conditionsList = [
    {"id": "prediabetes", "label": "Prediabetes"},
    {"id": "diabetes2", "label": "Diabetes tipo 2"},
    {"id": "insulin_resistance", "label": "Resistencia a la insulina"},
    {"id": "hypothyroidism", "label": "Hipotiroidismo"},
    {"id": "hyperthyroidism", "label": "Hipertiroidismo"},
    {"id": "anemia", "label": "Anemia"},
    {"id": "hypertension", "label": "Presión alta"},
    {"id": "cholesterol", "label": "Colesterol alto"},
    {"id": "renal", "label": "Enfermedad renal"},
    {"id": "metabolic", "label": "Síndrome metabólico"},
    {"id": "pcos", "label": "SOP (solo mujer)"},
  ];

  // -------------------------------------------------------------
  // SUBMIT
  // -------------------------------------------------------------
  void _next() {
    final user = ref.read(onboardingProvider);
    final sex = user.sex;

    if (!_formKey.currentState!.validate()) return;

    final neckValue = double.tryParse(neckController.text.trim());
    final waistValue = double.tryParse(waistController.text.trim());
    final hipValue =
        hipController.text.trim().isEmpty ? null : double.tryParse(hipController.text.trim());

    if (neckValue == null || waistValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ingresa valores válidos en cuello y cintura."),
        ),
      );
      return;
    }

    // VALIDACIÓN CRÍTICA DEL AYUNO — evita el error fatal
    if (doesFasting && protocol == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona un protocolo de ayuno."),
        ),
      );
      return;
    }

    ref.read(onboardingProvider.notifier).setMeasurements(
          neck: neckValue,
          waist: waistValue,
          hip: (sex == "female") ? hipValue : null,
          workoutDays: workoutDays,
          doesFasting: doesFasting,
          fastingProtocol: doesFasting ? protocol : null,
        );

    ref.read(onboardingProvider.notifier).setHealthData(
          conditions: selectedConditions,
          otherCondition: otherConditionController.text.trim().isEmpty
              ? null
              : otherConditionController.text.trim(),
        );

    context.go('/onboarding/step4');
  }

  // -------------------------------------------------------------
  // UI
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(onboardingProvider);
    final name = user.name ?? "Usuario";
    final sex = user.sex;

    final emoji = (sex == "male")
        ? "👨‍🦱"
        : (sex == "female")
            ? "👩‍🦱"
            : "🙂";

    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              const ElenaProgressBar(step: 3, total: 4),
              const SizedBox(height: 30),

              ElenaSectionHeader(
                title: "Vamos muy bien, $name $emoji",
                subtitle:
                    "Solo necesitamos unos últimos datos para calcular tu composición corporal.",
              ),

              const SizedBox(height: 30),

              // ---------------------------------------------------
              // MEDIDAS CORPORALES
              // ---------------------------------------------------
              ElenaCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CUELLO
                      Text(
                        "Cuello (cm)",
                        style: ElenaText.label,
                      ),
                      const SizedBox(height: 6),
                      _buildExplanationBox(
                        text: (sex == "male")
                            ? "Mide justo debajo de la manzana de Adán."
                            : "Mide la base del cuello, justo debajo de la barbilla.",
                      ),
                      const SizedBox(height: 10),
                      ElenaInput(
                        controller: neckController,
                        label: "Cuello (cm)",
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Requerido" : null,
                      ),

                      const SizedBox(height: 25),

                      // CINTURA
                      Text("Cintura (cm)", style: ElenaText.label),
                      const SizedBox(height: 6),
                      _buildExplanationBox(
                        text:
                            "Mide a la altura del ombligo, sin apretar la cinta.",
                      ),
                      const SizedBox(height: 10),
                      ElenaInput(
                        controller: waistController,
                        label: "Cintura (cm)",
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Requerido" : null,
                      ),

                      const SizedBox(height: 25),

                      // CADERA – SOLO MUJERES
                      if (sex == "female") ...[
                        Text("Cadera (cm)", style: ElenaText.label),
                        const SizedBox(height: 6),
                        _buildExplanationBox(
                          text:
                              "Mide la parte más ancha de tus glúteos, asegurando que la cinta esté nivelada.",
                        ),
                        const SizedBox(height: 10),
                        ElenaInput(
                          controller: hipController,
                          label: "Cadera (cm)",
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ---------------------------------------------------
              // ESTILO DE VIDA
              // ---------------------------------------------------
              ElenaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("💪 Tu actividad semanal", style: ElenaText.label),
                    const SizedBox(height: 6),
                    Text(
                      "Selecciona cuántos días entrenas a la semana.",
                      style: ElenaText.subtitle,
                    ),
                    const SizedBox(height: 15),

                    Text(
                      "Días: $workoutDays",
                      style: ElenaText.label,
                    ),
                    Slider(
                      min: 0,
                      max: 7,
                      divisions: 7,
                      value: workoutDays.toDouble(),
                      activeColor: ElenaColors.primary,
                      onChanged: (v) =>
                          setState(() => workoutDays = v.toInt()),
                    ),

                    const SizedBox(height: 25),

                    Text("⏳ ¿Practicas ayuno intermitente?",
                        style: ElenaText.label),
                    const SizedBox(height: 6),
                    Text(
                      "Si lo usas, selecciona tu protocolo.",
                      style: ElenaText.subtitle,
                    ),
                    const SizedBox(height: 10),

                    Switch(
                      value: doesFasting,
                      activeColor: ElenaColors.primary,
                      onChanged: (v) {
                        setState(() {
                          doesFasting = v;
                          if (v) {
                            protocol ??= "16:8"; // Valor por defecto
                          } else {
                            protocol = null;
                          }
                        });
                      },
                    ),

                    if (doesFasting) ...[
                      const SizedBox(height: 10),
                      Text("Protocolo", style: ElenaText.label),
                      DropdownButton<String>(
                        value: protocol,
                        isExpanded: true,
                        items: ["16:8", "18:6", "20:4", "OMAD"]
                            .map(
                              (p) => DropdownMenuItem(
                                value: p,
                                child: Text(p),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => protocol = v),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ---------------------------------------------------
              // SALUD
              // ---------------------------------------------------
              ElenaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("❤️ Condiciones de salud (opcional)",
                        style: ElenaText.label),
                    const SizedBox(height: 6),
                    Text(
                      "Selecciona las que apliquen para personalizar mejor tu plan.",
                      style: ElenaText.subtitle,
                    ),
                    const SizedBox(height: 15),

                    Wrap(
                      spacing: 10,
                      runSpacing: 12,
                      children: conditionsList.map((c) {
                        return FilterChip(
                          label: Text(c["label"]!),
                          selected: selectedConditions.contains(c["id"]!),
                          onSelected: (v) {
                            setState(() {
                              if (v) {
                                selectedConditions.add(c["id"]!);
                              } else {
                                selectedConditions.remove(c["id"]!);
                              }
                            });
                          },
                          selectedColor:
                              ElenaColors.primary.withOpacity(0.2),
                          checkmarkColor: ElenaColors.primary,
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),
                    ElenaInput(
                      controller: otherConditionController,
                      label: "Otra condición (opcional)",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              ElenaButtonPrimary(text: "Siguiente", onPressed: _next),
              const SizedBox(height: 20),
              ElenaButtonSecondary(
                text: "Volver",
                onPressed: () => context.go('/onboarding/step2'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET EXPLICATIVO REUTILIZABLE
  Widget _buildExplanationBox({required String text}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: ElenaText.subtitle,
      ),
    );
  }
}
