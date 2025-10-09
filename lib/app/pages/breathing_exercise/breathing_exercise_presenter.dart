import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

/// Presenter para la pantalla de ejercicios de respiración siguiendo Clean Architecture
/// Maneja la lógica de presentación y la comunicación con la vista
class BreathingExercisePresenter extends Presenter {
  final Logger _logger = Logger('BreathingExercisePresenter');
  
  // Referencias para la vista - usando nullable para evitar late initialization error
  Function? onNavigateToHome;
  Function(String)? onShowError;
  Function(String)? onShowSuccess;
  Function(String)? onShowInfo;
  Function? onShowSettings;
  Function(String, int)? onStartPhase;
  Function? onExerciseComplete;
  Function? onHapticFeedback;
  
  @override
  void dispose() {
    // Limpiar recursos si es necesario
  }
  
  /// Configura las callbacks de la vista
  void setViewCallbacks({
    required Function navigateToHome,
    required Function(String) showError,
    required Function(String) showSuccess,
    required Function(String) showInfo,
    required Function showSettings,
    required Function(String, int) startPhase,
    required Function exerciseComplete,
    required Function hapticFeedback,
  }) {
    onNavigateToHome = navigateToHome;
    onShowError = showError;
    onShowSuccess = showSuccess;
    onShowInfo = showInfo;
    onShowSettings = showSettings;
    onStartPhase = startPhase;
    onExerciseComplete = exerciseComplete;
    onHapticFeedback = hapticFeedback;
  }
  
  /// Se llama cuando se inicia el ejercicio
  void onExerciseStarted() {
    _logger.info('Ejercicio de respiración iniciado');
    // Feedback háptico para inicio
    HapticFeedback.lightImpact();
  }
  
  /// Se llama cuando se pausa el ejercicio
  void onExercisePaused() {
    _logger.info('Ejercicio de respiración pausado');
    // Feedback háptico para pausa
    HapticFeedback.selectionClick();
  }
  
  /// Se llama cuando se reanuda el ejercicio
  void onExerciseResumed() {
    _logger.info('Ejercicio de respiración reanudado');
    // Feedback háptico para reanudar
    HapticFeedback.lightImpact();
  }
  
  /// Se llama cuando se detiene el ejercicio
  void onExerciseStopped() {
    _logger.info('Ejercicio de respiración detenido');
    // Feedback háptico para detener
    HapticFeedback.mediumImpact();
  }
  
  /// Se llama cuando se completa el ejercicio
  void onExerciseCompleted(int totalCycles) {
    _logger.info('Ejercicio de respiración completado: $totalCycles ciclos');
    
    // Feedback háptico de completado
    HapticFeedback.heavyImpact();
    
    // Mostrar mensaje de felicitación
    onShowSuccess?.call('¡Excelente trabajo! Has completado $totalCycles ciclos de respiración 4-7-8.');
    
    // Trigger de finalización en la vista
    onExerciseComplete?.call();
  }
  
  /// Se llama cuando cambia la fase de respiración
  void onPhaseChanged(String phase, int duration) {
    _logger.info('Nueva fase de respiración: $phase (${duration}s)');
    
    // Determinar el feedback háptico según la fase
    switch (phase) {
      case 'inhale':
        HapticFeedback.lightImpact(); // Inicio de inhalación
        break;
      case 'hold':
        HapticFeedback.selectionClick(); // Transición a retención
        break;
      case 'exhale':
        HapticFeedback.selectionClick(); // Cambio a exhalación
        break;
    }
    
    // Notificar a la vista para iniciar las animaciones
    onStartPhase?.call(phase, duration);
  }
  
  /// Se llama cuando cambia la forma de respiración
  void onShapeChanged(String shape) {
    _logger.info('Forma de respiración cambiada a: $shape');
    
    // Feedback háptico para cambio de forma
    HapticFeedback.selectionClick();
    
    // Mostrar mensaje informativo
    String shapeName = _getShapeName(shape);
    onShowInfo?.call('Forma cambiada a: $shapeName');
  }
  
  /// Se llama cuando se solicita mostrar información
  void showExerciseInfo() {
    _logger.info('Mostrando información del ejercicio');
    
    final infoText = '''
Respiración 4-7-8

La técnica de respiración 4-7-8 es una práctica de relajación profunda que puede ayudar a:

• Reducir el estrés y la ansiedad
• Mejorar la calidad del sueño
• Aumentar la concentración
• Calmar el sistema nervioso

Cómo funciona:
1. Inhala por 4 segundos
2. Mantén la respiración por 7 segundos
3. Exhala lentamente por 8 segundos
4. Repite el ciclo

Consejos:
• Encuentra una posición cómoda
• Respira por la nariz al inhalar
• Exhala completamente por la boca
• Practica regularmente para mejores resultados
''';
    
    onShowInfo?.call(infoText);
  }
  
  /// Se llama cuando se solicita mostrar configuración
  void showExerciseSettings() {
    _logger.info('Mostrando configuración del ejercicio');
    onShowSettings?.call();
  }
  
  /// Navega de vuelta a la pantalla principal
  void navigateToHome() {
    _logger.info('Navegando de vuelta a Home');
    onNavigateToHome?.call();
  }
  
  /// Maneja errores durante el ejercicio
  void handleError(String error) {
    _logger.severe('Error en ejercicio de respiración: $error');
    onShowError?.call(error);
  }
  
  /// Convierte el código de forma a nombre legible
  String _getShapeName(String shape) {
    switch (shape) {
      case 'circle':
        return 'Círculo';
      case 'square':
        return 'Cuadrado';
      case 'triangle':
        return 'Triángulo';
      default:
        return 'Forma desconocida';
    }
  }
  
  /// Valida los parámetros del ejercicio
  bool validateExerciseParams(int inhaleTime, int holdTime, int exhaleTime, int cycles) {
    if (inhaleTime <= 0 || holdTime < 0 || exhaleTime <= 0 || cycles <= 0) {
      onShowError?.call('Los parámetros del ejercicio deben ser valores positivos');
      return false;
    }
    
    if (cycles > 20) {
      onShowError?.call('El número máximo de ciclos es 20');
      return false;
    }
    
    return true;
  }
  
  /// Formatea el tiempo restante para mostrar
  String formatTimeRemaining(int seconds) {
    if (seconds <= 0) return '0';
    return seconds.toString();
  }
  
  /// Calcula el progreso total del ejercicio
  double calculateTotalProgress(int currentCycle, int totalCycles) {
    if (totalCycles <= 0) return 0.0;
    return (currentCycle / totalCycles).clamp(0.0, 1.0);
  }


}
