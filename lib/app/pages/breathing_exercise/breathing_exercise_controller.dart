import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

/// Controller para la vista de ejercicios de respiración
/// 
/// Responsabilidades:
/// - Gestionar el estado del ejercicio de respiración
/// - Controlar las animaciones y temporizadores
/// - Ejecutar casos de uso del dominio
/// - Comunicarse con el presenter
class BreathingExerciseController extends Controller {
  final dynamic breathingExercisePresenter;
  
  // Constructor
  BreathingExerciseController(this.breathingExercisePresenter) : super();

  @override
  void initListeners() {
    // Inicializar listeners si es necesario
  }

  // Estado del ejercicio de respiración
  bool _isPlaying = false;
  bool _isPaused = false;
  int _currentCycle = 0;
  int _totalCycles = 8;
  String _currentPhase = 'rest'; // 'inhale', 'hold', 'exhale', 'rest'
  String _selectedShape = 'circle'; // 'circle', 'square', 'triangle'
  String _exerciseType = '4-7-8';
  double _phaseProgress = 0.0;
  int _phaseTimeRemaining = 0;

  // Configuración del ejercicio (4-7-8)
  final int _inhaleTime = 4;
  final int _holdTime = 7;
  final int _exhaleTime = 8;
  final int _pauseTime = 1;

  // Getters para exponer el estado de manera segura
  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  int get currentCycle => _currentCycle;
  int get totalCycles => _totalCycles;
  String get currentPhase => _currentPhase;
  String get selectedShape => _selectedShape;
  String get exerciseType => _exerciseType;
  double get phaseProgress => _phaseProgress;
  int get phaseTimeRemaining => _phaseTimeRemaining;
  int get inhaleTime => _inhaleTime;
  int get holdTime => _holdTime;
  int get exhaleTime => _exhaleTime;
  
  // Getters adicionales para la vista
  bool get isInhaling => _currentPhase == 'inhale';
  bool get isHolding => _currentPhase == 'hold';
  bool get isExhaling => _currentPhase == 'exhale';
  bool get isPausing => _currentPhase == 'rest';
  int get inhaleSeconds => _inhaleTime;
  int get holdSeconds => _holdTime;
  int get exhaleSeconds => _exhaleTime;
  int get pauseSeconds => _pauseTime;
  int get currentPhaseDuration => 
    _currentPhase == 'inhale' ? _inhaleTime * 1000 :
    _currentPhase == 'hold' ? _holdTime * 1000 :
    _currentPhase == 'exhale' ? _exhaleTime * 1000 :
    _pauseTime * 1000;

  /// Inicia el ejercicio de respiración
  void startExercise() {
    _isPlaying = true;
    _isPaused = false;
    _currentCycle = 0;
    
    // Notificar al presenter que se inició el ejercicio
    getPresenter().onExerciseStarted();
    
    // Iniciar el primer ciclo
    _startBreathingCycle();
    
    refreshUI();
  }

  /// Pausa el ejercicio
  void pauseExercise() {
    _isPaused = true;
    _isPlaying = false;
    
    // Notificar al presenter
    getPresenter().onExercisePaused();
    
    refreshUI();
  }

  /// Reanuda el ejercicio
  void resumeExercise() {
    _isPaused = false;
    _isPlaying = true;
    
    // Notificar al presenter
    getPresenter().onExerciseResumed();
    
    refreshUI();
  }

  /// Detiene el ejercicio
  void stopExercise() {
    _isPlaying = false;
    _isPaused = false;
    _currentCycle = 0;
    _currentPhase = 'rest';
    _phaseProgress = 0.0;
    _phaseTimeRemaining = 0;
    
    // Notificar al presenter
    getPresenter().onExerciseStopped();
    
    refreshUI();
  }

  /// Reinicia el ejercicio
  void resetExercise() {
    stopExercise();
    _currentCycle = 0;
    _currentPhase = 'rest';
    _phaseProgress = 0.0;
    _phaseTimeRemaining = 0;
    
    refreshUI();
  }

  /// Reinicia el ejercicio (alias para la vista)
  void restartExercise() {
    resetExercise();
    startExercise();
  }

  /// Cambia la forma de respiración
  void changeShape(String shape) {
    _selectedShape = shape;
    
    // Notificar al presenter
    getPresenter().onShapeChanged(shape);
    
    refreshUI();
  }

  /// Actualiza el progreso de la fase actual
  void updatePhaseProgress(double progress, int timeRemaining) {
    _phaseProgress = progress;
    _phaseTimeRemaining = timeRemaining;
    
    refreshUI();
  }

  /// Avanza a la siguiente fase del ciclo de respiración
  void nextPhase() {
    switch (_currentPhase) {
      case 'rest':
        _inhalePhase();
        break;
      case 'inhale':
        _holdPhase();
        break;
      case 'hold':
        _exhalePhase();
        break;
      case 'exhale':
        _completeCurrentCycle();
        break;
    }
  }

  /// Inicia la fase de inhalación
  void _inhalePhase() {
    _currentPhase = 'inhale';
    _phaseTimeRemaining = _inhaleTime;
    _phaseProgress = 0.0;
    
    // Notificar al presenter
    getPresenter().onPhaseChanged('inhale', _inhaleTime);
    
    refreshUI();
  }

  /// Inicia la fase de retención
  void _holdPhase() {
    _currentPhase = 'hold';
    _phaseTimeRemaining = _holdTime;
    _phaseProgress = 0.0;
    
    // Notificar al presenter
    getPresenter().onPhaseChanged('hold', _holdTime);
    
    refreshUI();
  }

  /// Inicia la fase de exhalación
  void _exhalePhase() {
    _currentPhase = 'exhale';
    _phaseTimeRemaining = _exhaleTime;
    _phaseProgress = 0.0;
    
    // Notificar al presenter
    getPresenter().onPhaseChanged('exhale', _exhaleTime);
    
    refreshUI();
  }

  /// Completa el ciclo actual y avanza al siguiente
  void _completeCurrentCycle() {
    _currentCycle++;
    
    if (_currentCycle >= _totalCycles) {
      // Ejercicio completado
      _completeExercise();
    } else {
      // Continuar con el siguiente ciclo
      _currentPhase = 'rest';
      _phaseProgress = 0.0;
      _phaseTimeRemaining = 0;
      
      // Pequeña pausa antes del siguiente ciclo
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_isPlaying && !_isPaused) {
          _startBreathingCycle();
        }
      });
    }
    
    refreshUI();
  }

  /// Inicia un nuevo ciclo de respiración
  void _startBreathingCycle() {
    if (_currentCycle >= _totalCycles) {
      _completeExercise();
      return;
    }
    
    _inhalePhase();
  }

  /// Completa todo el ejercicio
  void _completeExercise() {
    _isPlaying = false;
    _isPaused = false;
    _currentPhase = 'rest';
    
    // Notificar al presenter que se completó el ejercicio
    getPresenter().onExerciseCompleted(_totalCycles);
    
    refreshUI();
  }

  /// Muestra información del ejercicio
  void showInfo() {
    getPresenter().showExerciseInfo();
  }

  /// Muestra configuración del ejercicio
  void showSettings() {
    getPresenter().showExerciseSettings();
  }

  /// Retorna el presenter tipado
  BreathingExercisePresenter getPresenter() {
    return breathingExercisePresenter;
  }

  @override
  void onDisposed() {
    // Limpiar recursos si es necesario
    breathingExercisePresenter.dispose();
    super.onDisposed();
  }
}

/// Interface que debe implementar el presenter
abstract class BreathingExercisePresenter extends Presenter {
  void onExerciseStarted();
  void onExercisePaused();
  void onExerciseResumed();
  void onExerciseStopped();
  void onExerciseCompleted(int totalCycles);
  void onPhaseChanged(String phase, int duration);
  void onShapeChanged(String shape);
  void showExerciseInfo();
  void showExerciseSettings();
}