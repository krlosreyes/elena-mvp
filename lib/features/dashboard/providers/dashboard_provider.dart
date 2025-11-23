import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/models/dashboard_model.dart';

/// Dashboard Provider — seguro para Web y compatible con todos los módulos
final dashboardProvider = FutureProvider<DashboardModel>((ref) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  if (uid == null) return DashboardModel.empty();

  final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

  // ============================================================
  // LECTURA DEL DOCUMENTO RAÍZ (/users/{uid})
  // ============================================================
  Map<String, dynamic> root = {};
  try {
    final snap = await userDoc.get();
    root = snap.data() ?? {};
  } catch (e) {
    print("Error leyendo /users/$uid: $e");
    return DashboardModel.empty();
  }

  final profile = root['profile'] ?? {};
  final metrics = root['metrics'] ?? {};

  // ============================================================
  // SUBCOLECCIONES SEGURAS
  // ============================================================
  Future<Map<String, dynamic>> safeSub(String name) async {
    try {
      final q = await userDoc.collection(name).limit(1).get();
      return q.docs.isNotEmpty ? q.docs.first.data() : {};
    } catch (e) {
      print("Error leyendo subcolección $name: $e");
      return {};
    }
  }

  final initComp = await safeSub('initialComposition');
  final streaks = await safeSub('streaks');
  final gamification = await safeSub('gamification');

  // ============================================================
  // COMPOSICIÓN — Valores iniciales
  // ============================================================
  final double bf = (initComp['bodyFatPercentage'] ?? 0).toDouble();
  final double leanMass = (initComp['leanMass'] ?? 0).toDouble();

  final double bfNow = bf;       // de momento sin semana actual
  final double leanNow = leanMass;

  // ============================================================
  // AYUNO — Sesión activa
  // ============================================================
  final activeSessionQuery = await userDoc
      .collection('fastingSessions')
      .where('end', isNull: true)
      .limit(1)
      .get();

  bool isFasting = false;
  String fastingElapsed = "0h 0m";
  double fastingProgress = 0.0;

  if (activeSessionQuery.docs.isNotEmpty) {
    isFasting = true;

    final data = activeSessionQuery.docs.first.data();
    final start = (data['start'] as Timestamp).toDate();

    final diff = DateTime.now().difference(start);

    fastingElapsed = "${diff.inHours}h ${diff.inMinutes % 60}m";

    // Objetivo: 16 horas
    fastingProgress = diff.inSeconds / (16 * 3600);
    if (fastingProgress > 1) fastingProgress = 1;
  }

  // ============================================================
  // RETORNO FINAL — DashboardModel COMPLETO
  // ============================================================
  return DashboardModel(
    fastingStreak: streaks['currentFastingStreak'] ?? 0,
    nextStreakGoal: 7,
    nextStreakXP: 50,

    isFasting: isFasting,
    fastingElapsed: fastingElapsed,
    fastingProgress: fastingProgress,

    bfOld: bf,
    bfNow: bfNow,
    bfDiff: "${(bfNow - bf).toStringAsFixed(1)}%",

    leanOld: leanMass,
    leanNow: leanNow,
    leanDiff: "${(leanNow - leanMass).toStringAsFixed(1)}kg",

    recompositionStatus: "Sin cambios aún",
    recompositionMessage:
        "Completa tu primer check-in semanal para activar análisis inteligente.",

    caloriesToday: 0,
    calorieGoal: metrics['calorieGoal']?.toInt() ?? 2000,
    calorieProgress: 0 / (metrics['calorieGoal']?.toInt() ?? 2000),
    proteinAlert: "Aún no registras comidas.",

    workoutDays: profile['workoutDays'] ?? 0,
    workoutTip: "Ideal: 4 días de pesas por semana",

    xp: gamification['xp'] ?? 0,
    nextLevelXP: 500,
    xpProgress: (gamification['xp'] ?? 0) / 500,
    level: gamification['level'] ?? 1,
    lastBadge: (gamification['badges']?.isNotEmpty ?? false)
        ? gamification['badges'].last
        : "Ninguno",
  );
});
