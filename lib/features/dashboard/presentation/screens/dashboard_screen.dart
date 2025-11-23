import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:elena/ui/elena_ui_system.dart';
import 'package:elena/ui/layouts/elena_centered_layout.dart';
import '../../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(dashboardProvider);

    return asyncData.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),

      error: (err, stack) => Scaffold(
        body: Center(child: Text("Error: $err")),
      ),

      data: (d) => Scaffold(
        backgroundColor: ElenaColors.background,
        body: SafeArea(
          child: ElenaCenteredLayout(
            maxWidth: 480,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _streakCard(d),
                const SizedBox(height: 20),

                _fastingCard(context, d),
                const SizedBox(height: 20),

                _compositionCard(d),
                const SizedBox(height: 20),

                _caloriesCard(d),
                const SizedBox(height: 20),

                _workoutCard(d),
                const SizedBox(height: 20),

                _xpCard(d),
                const SizedBox(height: 30),

                _quickActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 1. Racha de ayuno
  // -------------------------------------------------------------
  Widget _streakCard(dynamic d) {
    return ElenaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🔥 Racha de Ayuno", style: ElenaText.title),
          const SizedBox(height: 6),
          Text("${d.fastingStreak} días consecutivos", style: ElenaText.subtitle),
          const SizedBox(height: 8),
          Text("Próximo logro: ${d.nextStreakGoal} días (+${d.nextStreakXP} XP)",
              style: ElenaText.label),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 2. Ayuno actual
  // -------------------------------------------------------------
  Widget _fastingCard(BuildContext context, dynamic d) {
    return ElenaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("⏳ Ayuno Actual", style: ElenaText.title),
          const SizedBox(height: 12),

          Center(
            child: Column(
              children: [
                Text("${d.fastingElapsed}", style: ElenaText.title),
                Text("${d.fastingProgress} completado",
                    style: ElenaText.subtitle),
                const SizedBox(height: 12),

                // Nota: toggleFasting deberá implementarse luego en el módulo
                ElenaButtonPrimary(
                  text: d.isFasting ? "Terminar ayuno" : "Iniciar ayuno",
                  onPressed: () {
                    // TODO: Implementar en módulo de Ayuno
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Funcionalidad de ayuno pendiente."),
                      ),
                    );
                  },
                ),

                ElenaButtonPrimary(
                  text: "Ir al módulo de Ayuno",
                  onPressed: () => GoRouter.of(context).go('/fasting'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 3. Composición corporal
  // -------------------------------------------------------------
  Widget _compositionCard(dynamic d) {
    return ElenaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("📊 Tu Recomposición", style: ElenaText.title),
          const SizedBox(height: 12),

          Text("Grasa: ${d.bfOld}% → ${d.bfNow}% (${d.bfDiff})",
              style: ElenaText.subtitle),
          const SizedBox(height: 4),

          Text("Músculo: ${d.leanOld}kg → ${d.leanNow}kg (${d.leanDiff})",
              style: ElenaText.subtitle),
          const SizedBox(height: 12),

          Text("Estado: ${d.recompositionStatus}",
              style: ElenaText.label.copyWith(color: ElenaColors.primary)),
          const SizedBox(height: 6),

          Text(d.recompositionMessage, style: ElenaText.subtitle),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 4. Calorías del día
  // -------------------------------------------------------------
  Widget _caloriesCard(dynamic d) {
    return ElenaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🔥 Calorías Hoy", style: ElenaText.title),
          const SizedBox(height: 6),

          Text("${d.caloriesToday} / ${d.calorieGoal} kcal",
              style: ElenaText.subtitle),
          const SizedBox(height: 10),

          ElenaProgressBarSimple(value: d.calorieProgress),
          const SizedBox(height: 10),

          if (d.proteinAlert != null)
            Text("⚠ ${d.proteinAlert}",
                style: ElenaText.label.copyWith(color: Colors.red)),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 5. Ejercicio
  // -------------------------------------------------------------
  Widget _workoutCard(dynamic d) {
    return ElenaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("💪 Ejercicio esta semana", style: ElenaText.title),
          const SizedBox(height: 6),
          Text("${d.workoutDays}/4 días", style: ElenaText.subtitle),
          const SizedBox(height: 10),
          Text("Tip: ${d.workoutTip}", style: ElenaText.label),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 6. XP / Nivel
  // -------------------------------------------------------------
  Widget _xpCard(dynamic d) {
    return ElenaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("⭐ Nivel ${d.level}", style: ElenaText.title),
          const SizedBox(height: 6),

          Text("${d.xp} / ${d.nextLevelXP} XP", style: ElenaText.subtitle),
          const SizedBox(height: 10),

          ElenaProgressBarSimple(value: d.xpProgress),
          const SizedBox(height: 10),

          Text("Último logro: ${d.lastBadge}", style: ElenaText.label),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 7. Acciones rápidas
  // -------------------------------------------------------------
  Widget _quickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElenaQuickActionButton(
          icon: Icons.restaurant,
          label: "Comida",
          onTap: () => context.go('/meal'),
        ),
        ElenaQuickActionButton(
          icon: Icons.fitness_center,
          label: "Ejercicio",
          onTap: () => context.go('/workout'),
        ),
        ElenaQuickActionButton(
          icon: Icons.monitor_weight,
          label: "Peso",
          onTap: () => context.go('/weight'),
        ),
        ElenaQuickActionButton(
          icon: Icons.straighten,
          label: "Medidas",
          onTap: () => context.go('/measure'),
        ),
      ],
    );
  }
}
