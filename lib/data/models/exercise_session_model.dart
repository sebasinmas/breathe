import 'package:breathe/domain/entities/exercise_session.dart';

/// Modelo de datos para ExerciseSession que extiende la entidad del dominio
/// Agrega funcionalidades de serialización para Firebase/API
class ExerciseSessionModel extends ExerciseSession {
  const ExerciseSessionModel({
    required super.id,
    required super.userId,
    required super.exerciseId,
    required super.exerciseName,
    required super.startTime,
    required super.endTime,
    required super.completedCycles,
    required super.targetCycles,
    required super.completionRate,
    required super.metadata,
  });

  /// Crea un modelo desde un Map (útil para Firebase/JSON)
  factory ExerciseSessionModel.fromJson(Map<String, dynamic> json) {
    return ExerciseSessionModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      exerciseId: json['exerciseId'] as String? ?? '',
      exerciseName: json['exerciseName'] as String? ?? '',
      startTime: DateTime.tryParse(json['startTime'] as String? ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['endTime'] as String? ?? '') ?? DateTime.now(),
      completedCycles: json['completedCycles'] as int? ?? 0,
      targetCycles: json['targetCycles'] as int? ?? 0,
      completionRate: (json['completionRate'] as num?)?.toDouble() ?? 0.0,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  /// Crea un modelo desde una entidad del dominio
  factory ExerciseSessionModel.fromEntity(ExerciseSession entity) {
    return ExerciseSessionModel(
      id: entity.id,
      userId: entity.userId,
      exerciseId: entity.exerciseId,
      exerciseName: entity.exerciseName,
      startTime: entity.startTime,
      endTime: entity.endTime,
      completedCycles: entity.completedCycles,
      targetCycles: entity.targetCycles,
      completionRate: entity.completionRate,
      metadata: Map<String, dynamic>.from(entity.metadata),
    );
  }

  /// Convierte el modelo a Map (útil para Firebase/JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'completedCycles': completedCycles,
      'targetCycles': targetCycles,
      'completionRate': completionRate,
      'metadata': Map<String, dynamic>.from(metadata),
    };
  }

  /// Crea una copia del modelo con valores modificados
  @override
  ExerciseSessionModel copyWith({
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
    return ExerciseSessionModel(
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
}