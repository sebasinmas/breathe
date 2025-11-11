import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_breathing_exercises.dart';
import 'breathing_state.dart';

/// Cubit que maneja la lógica de estado para los ejercicios de respiración
/// 
/// Controla la carga de ejercicios, selección, ejecución con temporizador,
/// pausa y reinicio de ejercicios.
class BreathingCubit extends Cubit<BreathingState> {
  final GetBreathingExercises _getBreathingExercises;
  
  Timer? _timer;
  static const _tickInterval = Duration(milliseconds: 50); // 20 FPS para animaciones suaves

  BreathingCubit(this._getBreathingExercises) : super(const BreathingState());

  /// Carga la lista de ejercicios disponibles
  Future<void> loadExercises() async {
    try {
      emit(state.copyWith(status: BreathingStatus.loading));
      
      final exercises = await _getBreathingExercises();
      
      emit(state.copyWith(
        status: BreathingStatus.loaded,
        exercises: exercises,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BreathingStatus.error,
        errorMessage: 'Error al cargar ejercicios: $e',
      ));
    }
  }

  /// Selecciona un ejercicio e inicia automáticamente
  /// Nielsen: Eficiencia de uso - Inicia el ejercicio directamente sin pasos adicionales
  void selectExercise(int exerciseIndex) {
    if (exerciseIndex < 0 || exerciseIndex >= state.exercises.length) {
      return;
    }
    
    final exercise = state.exercises[exerciseIndex];
    
    emit(state.copyWith(
      selectedExercise: exercise,
      currentStepIndex: 0,
      stepProgress: 0.0,
      status: BreathingStatus.loaded,
    ));
    
    // Nielsen: Eficiencia de uso - Iniciar automáticamente después de un pequeño delay
    // Esto da tiempo al usuario para ver la transición de pantalla
    Future.delayed(const Duration(milliseconds: 800), () {
      if (state.selectedExercise == exercise) {
        startTimer();
      }
    });
  }

  /// Inicia el temporizador del ejercicio
  void startTimer() {
    if (state.selectedExercise == null) return;
    if (state.status == BreathingStatus.running) return;
    
    // Cancelar cualquier temporizador anterior
    _timer?.cancel();
    
    emit(state.copyWith(status: BreathingStatus.running));
    
    // Crear temporizador periódico
    _timer = Timer.periodic(_tickInterval, (_) {
      _onTimerTick();
    });
  }

  /// Maneja cada tick del temporizador
  void _onTimerTick() {
    if (state.currentStep == null) {
      stopTimer();
      return;
    }
    
    // Calcular el incremento de progreso basado en la duración del paso
    final stepDurationMs = state.currentStep!.duration.inMilliseconds;
    final incrementPerTick = _tickInterval.inMilliseconds / stepDurationMs;
    
    final newProgress = state.stepProgress + incrementPerTick;
    
    if (newProgress >= 1.0) {
      // Paso completado, avanzar al siguiente
      if (state.hasNextStep) {
        emit(state.copyWith(
          currentStepIndex: state.currentStepIndex + 1,
          stepProgress: 0.0,
        ));
      } else {
        // Ejercicio completado
        finishExercise();
      }
    } else {
      // Actualizar progreso del paso actual
      emit(state.copyWith(stepProgress: newProgress));
    }
  }

  /// Pausa el temporizador
  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
    
    if (state.status == BreathingStatus.running) {
      emit(state.copyWith(status: BreathingStatus.paused));
    }
  }

  /// Detiene completamente el temporizador
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Finaliza el ejercicio
  void finishExercise() {
    stopTimer();
    emit(state.copyWith(
      status: BreathingStatus.finished,
      stepProgress: 1.0,
    ));
  }

  /// Reinicia el ejercicio actual
  void resetExercise() {
    stopTimer();
    emit(state.copyWith(
      currentStepIndex: 0,
      stepProgress: 0.0,
      status: BreathingStatus.loaded,
    ));
  }

  /// Avanza manualmente al siguiente paso
  void nextStep() {
    if (!state.hasNextStep) return;
    
    emit(state.copyWith(
      currentStepIndex: state.currentStepIndex + 1,
      stepProgress: 0.0,
    ));
  }

  /// Retrocede manualmente al paso anterior
  void previousStep() {
    if (state.isFirstStep) return;
    
    emit(state.copyWith(
      currentStepIndex: state.currentStepIndex - 1,
      stepProgress: 0.0,
    ));
  }

  /// Vuelve a la lista de ejercicios
  void backToList() {
    stopTimer();
    emit(state.copyWith(
      selectedExercise: null,
      currentStepIndex: 0,
      stepProgress: 0.0,
      status: BreathingStatus.loaded,
    ));
  }

  @override
  Future<void> close() {
    stopTimer();
    return super.close();
  }
}
