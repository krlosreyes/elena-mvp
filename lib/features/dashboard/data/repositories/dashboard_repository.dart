import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../body_composition/services/body_composition_service.dart';
import '../models/dashboard_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final dashboardRepositoryProvider =
    Provider<DashboardRepository>((ref) => DashboardRepository(ref));

class DashboardRepository {
  final Ref ref;
  DashboardRepository(this.ref);

  Stream<DashboardData> watchDashboard() async* {
    final user = ref.read(authProvider);
    if (user == null) throw Exception("Usuario no autenticado");
    final uid = user.uid;

    final firestore = FirebaseFirestore.instance;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Escuchar TODOS LOS DOCUMENTOS NECESARIOS
    await for (final snap in firestore
        .collection("users")
        .doc(uid)
        .snapshots()) {

      final profileSnap = await firestore
          .collection("users")
          .doc(uid)
          .collection("profile")
          .doc("data")
          .get();

      final metricsSnap = await firestore
          .collection("users")
          .doc(uid)
          .collection("metrics")
          .doc("data")
          .get();

      final initialComp = await firestore
          .collection("users")
          .doc(uid)
          .collection("initialComposition")
          .doc("start")
          .get();

      final streaksSnap = await firestore
          .collection("users")
          .doc(uid)
          .collection("streaks")
          .doc("data")
          .get();

      final gamificationSnap = await firestore
          .collection("users")
          .doc(uid)
          .collection("gamification")
          .doc("data")
          .get();

      final todaySummary = await firestore
          .collection("users")
          .doc(uid)
          .collection("dailyRecords")
          .doc(today)
          .collection("summary")
          .doc("data")
          .get();

      yield _mapToDashboard(
        profileSnap.data(),
        metricsSnap.data(),
        initialComp.data(),
        streaksSnap.data(),
        gamificationSnap.data(),
        todaySummary.data(),
      );
    }
  }

  DashboardData _mapToDashboard(
    Map<String, dynamic>? profile,
    Map<String, dynamic>? metrics,
    Map<String, dynamic>? initial,
    Map<String, dynamic>? streaks,
    Map<String, dynamic>? gamification,
    Map<String, dynamic>? today,
  ) {
    // Seguridad
    profile ??= {};
    metrics ??= {};
    initial ??= {};
    streaks ??= {};
    gamification ??= {};
    today ??= {};

    // Datos base
    final bfNow = initial["bodyFatPercentage"]?.toDouble() ?? 0;
    final leanNow = initial["leanMass"]?.toDouble() ?? 0;

    // Nivel
    final xp = gamification["xp"] ?? 0;
    final level = gamification["level"] ?? 1;
    final nextLevelXp = (level * 500);

    return DashboardData(
      fastingStreak: streaks["currentFastingStreak"] ?? 0,
      nextStreakGoal: 7,
      nextStreakXP: 100,
      isFasting: today["fastingCompleted"] == false,
      fastingElapsed: today["fastingElapsed"] ?? "0h 0m",
      fastingProgress: today["fastingProgress"]?.toDouble() ?? 0,
      bfOld: bfNow,
      bfNow: bfNow,
      bfDiff: "0%",
      leanOld: leanNow,
      leanNow: leanNow,
      leanDiff: "0kg",
      recompositionStatus: "Primer registro",
      recompositionMessage: "Aún no hay suficiente data para análisis",
      caloriesToday: today["totalCalories"] ?? 0,
      calorieGoal: metrics["calorieGoal"]?.toInt() ?? 0,
      calorieProgress: (today["totalCalories"] ?? 0) /
          (metrics["calorieGoal"] ?? 1),
      proteinAlert: today["proteinMeals"] != null &&
              today["proteinMeals"] < 3
          ? "Pocas comidas proteicas hoy"
          : null,
      workoutDays: today["workoutsCompleted"] ?? 0,
      workoutTip: "Agrega un día más de pesas esta semana",
      level: level,
      xp: xp,
      nextLevelXP: nextLevelXp,
      xpProgress: xp / nextLevelXp,
      lastBadge: gamification["lastBadge"] ?? "Sin logros aún",
    );
  }
}
