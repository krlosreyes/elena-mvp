class OnboardingModel {
  final String goal;              // lose_fat | gain_muscle | recomposition
  final String name;
  final int age;
  final String sex;               // male | female | other
  final double weight;
  final double height;

  final double neck;
  final double waist;
  final double? hip;
  final int workoutDays;
  final bool doesFasting;
  final String? fastingProtocol;

  final List<String> conditions;
  final String? otherCondition;

  const OnboardingModel({
    this.goal = "",
    this.name = "",
    this.age = 0,
    this.sex = "",
    this.weight = 0,
    this.height = 0,
    this.neck = 0,
    this.waist = 0,
    this.hip,
    this.workoutDays = 0,
    this.doesFasting = false,
    this.fastingProtocol,
    this.conditions = const [],
    this.otherCondition,
  });

  OnboardingModel copyWith({
    String? goal,
    String? name,
    int? age,
    String? sex,
    double? weight,
    double? height,
    double? neck,
    double? waist,
    double? hip,
    int? workoutDays,
    bool? doesFasting,
    String? fastingProtocol,
    List<String>? conditions,
    String? otherCondition,
  }) {
    return OnboardingModel(
      goal: goal ?? this.goal,
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      neck: neck ?? this.neck,
      waist: waist ?? this.waist,
      hip: hip ?? this.hip,
      workoutDays: workoutDays ?? this.workoutDays,
      doesFasting: doesFasting ?? this.doesFasting,
      fastingProtocol: fastingProtocol ?? this.fastingProtocol,
      conditions: conditions ?? this.conditions,
      otherCondition: otherCondition ?? this.otherCondition,
    );
  }
}
