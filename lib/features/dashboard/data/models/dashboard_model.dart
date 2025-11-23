class DashboardModel {
  // Rachas
  final int fastingStreak;
  final int nextStreakGoal;
  final int nextStreakXP;

  // Ayuno actual
  final bool isFasting;
  final String fastingElapsed;
  final double fastingProgress;

  // Composición corporal
  final double bfOld;
  final double bfNow;
  final String bfDiff;

  final double leanOld;
  final double leanNow;
  final String leanDiff;

  final String recompositionStatus;
  final String recompositionMessage;

  // Calorías
  final int caloriesToday;
  final int calorieGoal;
  final double calorieProgress;
  final String? proteinAlert;

  // Ejercicio
  final int workoutDays;
  final String workoutTip;

  // XP / Nivel
  final int level;
  final int xp;
  final int nextLevelXP;
  final double xpProgress;
  final String lastBadge;

  DashboardModel({
    required this.fastingStreak,
    required this.nextStreakGoal,
    required this.nextStreakXP,
    required this.isFasting,
    required this.fastingElapsed,
    required this.fastingProgress,
    required this.bfOld,
    required this.bfNow,
    required this.bfDiff,
    required this.leanOld,
    required this.leanNow,
    required this.leanDiff,
    required this.recompositionStatus,
    required this.recompositionMessage,
    required this.caloriesToday,
    required this.calorieGoal,
    required this.calorieProgress,
    required this.proteinAlert,
    required this.workoutDays,
    required this.workoutTip,
    required this.level,
    required this.xp,
    required this.nextLevelXP,
    required this.xpProgress,
    required this.lastBadge,
  });

  factory DashboardModel.empty() {
    return DashboardModel(
      fastingStreak: 0,
      nextStreakGoal: 7,
      nextStreakXP: 50,
      isFasting: false,
      fastingElapsed: "0h 0m",
      fastingProgress: 0.0,
      bfOld: 0,
      bfNow: 0,
      bfDiff: "0%",
      leanOld: 0,
      leanNow: 0,
      leanDiff: "0kg",
      recompositionStatus: "Sin cambios",
      recompositionMessage: "Aún no tenemos suficientes datos",
      caloriesToday: 0,
      calorieGoal: 2000,
      calorieProgress: 0,
      proteinAlert: "Aún no registras comidas.",
      workoutDays: 0,
      workoutTip: "Haz al menos 3 días de pesas a la semana.",
      level: 1,
      xp: 0,
      nextLevelXP: 500,
      xpProgress: 0,
      lastBadge: "Ninguno",
    );
  }
}
