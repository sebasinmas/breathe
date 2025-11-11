import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/breathing_exercise.dart';
import '../../../domain/entities/breathing_step.dart';

part 'breathing_state.freezed.dart';

/// Estado del ejercicio de respiración
enum BreathingStatus {
  /// Estado inicial antes de cargar
  initial,
  
  /// Cargando ejercicios
  loading,
  
  /// Ejercicios cargados, listo para seleccionar
  loaded,
  
  /// Ejercicio en ejecución
  running,
  
  /// Ejercicio pausado
  paused,
  
  /// Ejercicio finalizado
  finished,
  
  /// Error al cargar o ejecutar
  error,
}

@freezed
class BreathingState with _$BreathingState {
  const BreathingState._();
  
  const factory BreathingState({
    /// Estado actual del ejercicio
    @Default(BreathingStatus.initial) BreathingStatus status,
    
    /// Lista de ejercicios disponibles
    @Default([]) List<BreathingExercise> exercises,
    
    /// Ejercicio seleccionado actualmente
    BreathingExercise? selectedExercise,
    
    /// Índice del paso actual en el ejercicio
    @Default(0) int currentStepIndex,
    
    /// Progreso del paso actual (0.0 a 1.0)
    @Default(0.0) double stepProgress,
    
    /// Mensaje de error si existe
    String? errorMessage,
  }) = _BreathingState;
  
  /// Obtiene el paso actual del ejercicio
  BreathingStep? get currentStep {
    if (selectedExercise == null) return null;
    if (currentStepIndex >= selectedExercise!.steps.length) return null;
    return selectedExercise!.steps[currentStepIndex];
  }
  
  /// Verifica si hay un siguiente paso
  bool get hasNextStep {
    if (selectedExercise == null) return false;
    return currentStepIndex < selectedExercise!.steps.length - 1;
  }
  
  /// Verifica si es el primer paso
  bool get isFirstStep => currentStepIndex == 0;
  
  /// Verifica si es el último paso
  bool get isLastStep {
    if (selectedExercise == null) return true;
    return currentStepIndex == selectedExercise!.steps.length - 1;
  }
  
  /// Progreso total del ejercicio (0.0 a 1.0)
  double get totalProgress {
    if (selectedExercise == null || selectedExercise!.steps.isEmpty) return 0.0;
    
    final totalSteps = selectedExercise!.steps.length;
    final completedSteps = currentStepIndex;
    final currentStepProgress = stepProgress;
    
    return (completedSteps + currentStepProgress) / totalSteps;
  }
  
  /// Tiempo restante del paso actual en milisegundos
  int get remainingTimeMs {
    if (currentStep == null) return 0;
    final totalMs = currentStep!.duration.inMilliseconds;
    final elapsedMs = (totalMs * stepProgress).round();
    return totalMs - elapsedMs;
  }
}
