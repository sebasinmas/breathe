import '../../domain/entities/breathing_step.dart';
import '../../domain/entities/breathing_step_type.dart';

/// Modelo de datos para un paso de respiración
/// 
/// Extiende la entidad [BreathingStep] y agrega funcionalidad de serialización
/// para persistencia y transferencia de datos.
class BreathingStepModel extends BreathingStep {
  const BreathingStepModel({
    required super.type,
    required super.duration,
    required super.instructionalText,
  });

  /// Crea un modelo desde un Map JSON
  factory BreathingStepModel.fromJson(Map<String, dynamic> json) {
    return BreathingStepModel(
      type: _parseStepType(json['type'] as String),
      duration: Duration(seconds: json['durationSeconds'] as int),
      instructionalText: json['instructionalText'] as String,
    );
  }

  /// Convierte el modelo a un Map JSON
  Map<String, dynamic> toJson() {
    return {
      'type': _stepTypeToString(type),
      'durationSeconds': duration.inSeconds,
      'instructionalText': instructionalText,
    };
  }

  /// Convierte un [BreathingStep] entidad a modelo
  factory BreathingStepModel.fromEntity(BreathingStep entity) {
    return BreathingStepModel(
      type: entity.type,
      duration: entity.duration,
      instructionalText: entity.instructionalText,
    );
  }

  /// Convierte el modelo a una entidad [BreathingStep]
  BreathingStep toEntity() {
    return BreathingStep(
      type: type,
      duration: duration,
      instructionalText: instructionalText,
    );
  }

  /// Parsea el tipo de paso desde string
  static BreathingStepType _parseStepType(String type) {
    switch (type.toLowerCase()) {
      case 'inhale':
        return BreathingStepType.inhale;
      case 'hold':
        return BreathingStepType.hold;
      case 'exhale':
        return BreathingStepType.exhale;
      case 'holdout':
      case 'hold_out':
        return BreathingStepType.holdOut;
      default:
        throw ArgumentError('Unknown breathing step type: $type');
    }
  }

  /// Convierte el tipo de paso a string
  static String _stepTypeToString(BreathingStepType type) {
    switch (type) {
      case BreathingStepType.inhale:
        return 'inhale';
      case BreathingStepType.hold:
        return 'hold';
      case BreathingStepType.exhale:
        return 'exhale';
      case BreathingStepType.holdOut:
        return 'holdOut';
    }
  }

  @override
  BreathingStepModel copyWith({
    BreathingStepType? type,
    Duration? duration,
    String? instructionalText,
  }) {
    return BreathingStepModel(
      type: type ?? this.type,
      duration: duration ?? this.duration,
      instructionalText: instructionalText ?? this.instructionalText,
    );
  }
}
