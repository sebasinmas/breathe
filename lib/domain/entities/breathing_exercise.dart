import 'breathing_step.dart';

/// Entidad que representa un ejercicio de respiración completo
/// 
/// Un ejercicio consiste en:
/// - Identificador único ([id])
/// - Nombre del ejercicio ([name])
/// - Descripción detallada ([description])
/// - Secuencia de pasos respiratorios ([steps])
class BreathingExercise {
  /// Identificador único del ejercicio
  final String id;
  
  /// Nombre del ejercicio (ej: "Respiración Cuadrada", "Técnica 4-7-8")
  final String name;
  
  /// Descripción del ejercicio y sus beneficios
  final String description;
  
  /// Lista ordenada de pasos que componen el ejercicio
  final List<BreathingStep> steps;

  const BreathingExercise({
    required this.id,
    required this.name,
    required this.description,
    required this.steps,
  });

  /// Duración total del ejercicio (suma de todos los pasos)
  Duration get totalDuration => steps.fold(
        Duration.zero,
        (total, step) => total + step.duration,
      );

  /// Duración total en segundos (útil para mostrar al usuario)
  int get totalDurationInSeconds => totalDuration.inSeconds;

  /// Número de pasos en el ejercicio
  int get stepCount => steps.length;

  /// Verifica si el ejercicio tiene pasos válidos
  bool get isValid => steps.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreathingExercise &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          steps == other.steps;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode ^ steps.hashCode;

  @override
  String toString() {
    return 'BreathingExercise{id: $id, name: $name, stepCount: $stepCount, totalDuration: $totalDuration}';
  }

  /// Crea una copia de este ejercicio con los valores opcionales modificados
  BreathingExercise copyWith({
    String? id,
    String? name,
    String? description,
    List<BreathingStep>? steps,
  }) {
    return BreathingExercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      steps: steps ?? this.steps,
    );
  }
}
