import '../../domain/entities/breathing_exercise.dart';
import '../../domain/entities/breathing_step.dart';
import 'breathing_step_model.dart';

/// Modelo de datos para un ejercicio de respiración
/// 
/// Extiende la entidad [BreathingExercise] y agrega funcionalidad de serialización
/// para persistencia y transferencia de datos.
class BreathingExerciseModel extends BreathingExercise {
  const BreathingExerciseModel({
    required super.id,
    required super.name,
    required super.description,
    required super.steps,
  });

  /// Crea un modelo desde un Map JSON
  factory BreathingExerciseModel.fromJson(Map<String, dynamic> json) {
    final stepsJson = json['steps'] as List<dynamic>;
    final steps = stepsJson
        .map((stepJson) => BreathingStepModel.fromJson(stepJson as Map<String, dynamic>))
        .toList();

    return BreathingExerciseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      steps: steps,
    );
  }

  /// Convierte el modelo a un Map JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'steps': steps
          .map((step) => BreathingStepModel.fromEntity(step).toJson())
          .toList(),
    };
  }

  /// Convierte un [BreathingExercise] entidad a modelo
  factory BreathingExerciseModel.fromEntity(BreathingExercise entity) {
    return BreathingExerciseModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      steps: entity.steps,
    );
  }

  /// Convierte el modelo a una entidad [BreathingExercise]
  BreathingExercise toEntity() {
    return BreathingExercise(
      id: id,
      name: name,
      description: description,
      steps: steps.map((step) {
        if (step is BreathingStepModel) {
          return step.toEntity();
        }
        return step;
      }).toList(),
    );
  }

  @override
  BreathingExerciseModel copyWith({
    String? id,
    String? name,
    String? description,
    List<BreathingStep>? steps,
  }) {
    return BreathingExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      steps: steps ?? this.steps,
    );
  }
}
