import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/fasting_provider.dart';
import '../../../../ui/elena_ui_system.dart';
import '../../../../ui/layouts/elena_centered_layout.dart';

class FastingScreen extends ConsumerStatefulWidget {
  const FastingScreen({super.key});

  @override
  ConsumerState<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends ConsumerState<FastingScreen> {
  Timer? timer;
  Duration elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTicker();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startTicker() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final session = ref.read(fastingNotifierProvider).value;
      if (session == null) return;

      setState(() {
        elapsed = DateTime.now().difference(session.start);
      });
    });
  }

  String _format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    return "${h}h ${m}m ${s}s";
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fastingNotifierProvider);
    final notifier = ref.read(fastingNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: ElenaColors.background,
      appBar: AppBar(
        title: const Text("Ayuno"),
        backgroundColor: ElenaColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ElenaCenteredLayout(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text("Error: $e")),
            data: (session) {
              if (session == null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("¿Listo para comenzar tu ayuno?",
                        style: ElenaText.title),
                    const SizedBox(height: 20),
                    ElenaButtonPrimary(
                      text: "Iniciar ayuno",
                      onPressed: () => notifier.iniciarAyuno(),
                    ),
                  ],
                );
              }

              final progress = (elapsed.inSeconds / (16 * 3600)).clamp(0.0, 1.0);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Ayuno en progreso", style: ElenaText.title),
                  const SizedBox(height: 12),

                  Text(
                    _format(elapsed),
                    style: ElenaText.title,
                  ),

                  const SizedBox(height: 20),

                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade300,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ElenaColors.primary),
                  ),

                  const SizedBox(height: 20),
                  const Text("Meta: 16 horas", style: ElenaText.subtitle),

                  const SizedBox(height: 40),

                  ElenaButtonSecondary(
                    text: "Finalizar ayuno",
                    onPressed: () => notifier.terminarAyuno(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
