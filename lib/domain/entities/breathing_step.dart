import 'breathing_step_type.dart';

/// Entidad que representa un paso individual en un ejercicio de respiración
/// 
/// Cada paso define:
/// - El tipo de acción respiratoria ([type])
/// - La duración del paso ([duration])
/// - El texto instructivo que se mostrará al usuario ([instructionalText])
class BreathingStep {
  /// Tipo de paso respiratorio (inhalar, sostener, exhalar, etc.)
  final BreathingStepType type;
  
  /// Duración de este paso
  final Duration duration;
  
  /// Texto de guía que se mostrará al usuario durante este paso
  /// Ejemplo: "Inhala profundamente...", "Sostén el aire..."
  final String instructionalText;

  const BreathingStep({
    required this.type,
    required this.duration,
    required this.instructionalText,
  });

  /// Duración en segundos (útil para mostrar al usuario)
  int get durationInSeconds => duration.inSeconds;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreathingStep &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          duration == other.duration &&
          instructionalText == other.instructionalText;

  @override
  int get hashCode => type.hashCode ^ duration.hashCode ^ instructionalText.hashCode;

  @override
  String toString() {
    return 'BreathingStep{type: $type, duration: $duration, instructionalText: $instructionalText}';
  }

  /// Crea una copia de este paso con los valores opcionales modificados
  BreathingStep copyWith({
    BreathingStepType? type,
    Duration? duration,
    String? instructionalText,
  }) {
    return BreathingStep(
      type: type ?? this.type,
      duration: duration ?? this.duration,
      instructionalText: instructionalText ?? this.instructionalText,
    );
  }
}
