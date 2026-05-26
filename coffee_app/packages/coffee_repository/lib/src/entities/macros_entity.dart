class MacrosEntity {
  const MacrosEntity({
    required this.calories,
    required this.proteins,
    required this.fat,
    required this.carbs,
  });

  final int calories;
  final int proteins;
  final int fat;
  final int carbs;

  Map<String, Object?> toDocument() {
    return <String, Object?>{
      'calories': calories,
      'proteins': proteins,
      'fat': fat,
      'carbs': carbs,
    };
  }

  static MacrosEntity fromDocument(Map<String, dynamic> doc) {
    return MacrosEntity(
      calories: (doc['calories'] as num?)?.toInt() ?? 0,
      proteins: (doc['proteins'] as num?)?.toInt() ?? 0,
      fat: (doc['fat'] as num?)?.toInt() ?? 0,
      carbs: (doc['carbs'] as num?)?.toInt() ?? 0,
    );
  }
}
