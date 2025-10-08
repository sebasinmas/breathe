/// Entidad que representa una sesión de ejercicio completada
/// Utilizada para tracking de progreso y estadísticas del usuario
class ExerciseSession {
  final String id;
  final String userId;
  final String exerciseId;
  final String exerciseName;
  final DateTime startTime;
  final DateTime endTime;
  final int completedCycles;
  final int targetCycles;
  final double completionRate; // Porcentaje de finalización (0.0 - 1.0)
  final Map<String, dynamic> metadata; // Datos adicionales como sensaciones, notas, etc.

  const ExerciseSession({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.exerciseName,
    required this.startTime,
    required this.endTime,
    required this.completedCycles,
    required this.targetCycles,
    required this.completionRate,
    required this.metadata,
  });

  /// Duración de la sesión en minutos
  double get durationInMinutes {
    return endTime.difference(startTime).inMinutes.toDouble();
  }

  /// Indica si la sesión fue completada exitosamente
  bool get isCompleted {
    return completionRate >= 1.0;
  }

  ExerciseSession copyWith({
    String? id,
    String? userId,
    String? exerciseId,
    String? exerciseName,
    DateTime? startTime,
    DateTime? endTime,
    int? completedCycles,
    int? targetCycles,
    double? completionRate,
    Map<String, dynamic>? metadata,
  }) {
    return ExerciseSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      completedCycles: completedCycles ?? this.completedCycles,
      targetCycles: targetCycles ?? this.targetCycles,
      completionRate: completionRate ?? this.completionRate,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseSession && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ExerciseSession(id: $id, exerciseName: $exerciseName, completionRate: $completionRate)';
  }
}