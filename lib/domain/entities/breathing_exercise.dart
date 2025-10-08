/// Entidad que representa un ejercicio de respiración
/// Esta entidad define la estructura base de un ejercicio con sus patrones y configuraciones
class BreathingExercise {
  final String id;
  final String name;
  final String description;
  final int inhaleTime; // Tiempo de inhalación en segundos
  final int holdTime; // Tiempo de retención en segundos
  final int exhaleTime; // Tiempo de exhalación en segundos
  final int cycles; // Número de ciclos del ejercicio
  final String category; // Categoría: básico, avanzado, personalizado
  final bool isPremium; // Si requiere suscripción premium
  final DateTime createdAt;
  final DateTime updatedAt;

  const BreathingExercise({
    required this.id,
    required this.name,
    required this.description,
    required this.inhaleTime,
    required this.holdTime,
    required this.exhaleTime,
    required this.cycles,
    required this.category,
    required this.isPremium,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Crea una copia del ejercicio con valores modificados
  BreathingExercise copyWith({
    String? id,
    String? name,
    String? description,
    int? inhaleTime,
    int? holdTime,
    int? exhaleTime,
    int? cycles,
    String? category,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BreathingExercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      inhaleTime: inhaleTime ?? this.inhaleTime,
      holdTime: holdTime ?? this.holdTime,
      exhaleTime: exhaleTime ?? this.exhaleTime,
      cycles: cycles ?? this.cycles,
      category: category ?? this.category,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Duración total del ejercicio en segundos
  int get totalDuration {
    return (inhaleTime + holdTime + exhaleTime) * cycles;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BreathingExercise && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'BreathingExercise(id: $id, name: $name, cycles: $cycles)';
  }
}