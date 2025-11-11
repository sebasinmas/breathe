/// Tipos de pasos en un ejercicio de respiración
/// 
/// Representa las diferentes fases de un ciclo respiratorio:
/// - [inhale]: Fase de inhalación
/// - [hold]: Sostener con los pulmones llenos
/// - [exhale]: Fase de exhalación
/// - [holdOut]: Sostener con los pulmones vacíos
enum BreathingStepType {
  /// Fase de inhalación - respirar hacia adentro
  inhale,
  
  /// Fase de retención con pulmones llenos
  hold,
  
  /// Fase de exhalación - expulsar el aire
  exhale,
  
  /// Fase de retención con pulmones vacíos
  holdOut,
}

/// Extensión para obtener el nombre legible de cada tipo de paso
extension BreathingStepTypeExtension on BreathingStepType {
  /// Obtiene el nombre en español del tipo de paso
  String get displayName {
    switch (this) {
      case BreathingStepType.inhale:
        return 'Inhalar';
      case BreathingStepType.hold:
        return 'Sostener';
      case BreathingStepType.exhale:
        return 'Exhalar';
      case BreathingStepType.holdOut:
        return 'Sostener vacío';
    }
  }
  
  /// Obtiene el índice numérico para la State Machine de Lottie
  /// 1=Inhale, 2=Hold, 3=Exhale, 4=HoldOut
  int get lottieStateIndex {
    switch (this) {
      case BreathingStepType.inhale:
        return 1;
      case BreathingStepType.hold:
        return 2;
      case BreathingStepType.exhale:
        return 3;
      case BreathingStepType.holdOut:
        return 4;
    }
  }
}
