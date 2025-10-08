import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'dart:async';
import 'dart:ui';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/breathing_shape_widget.dart';
import 'breathing_exercise_controller.dart';
import 'breathing_exercise_presenter.dart' as presenter_file;

/// Vista del ejercicio de respiración con diseño glassmorphism siguiendo Clean Architecture
/// Solo maneja UI, delega lógica al Controller
class BreathingExercisePage extends CleanView {
  const BreathingExercisePage({super.key});

  @override
  State<StatefulWidget> createState() => _BreathingExerciseViewState();
}

class _BreathingExerciseViewState extends CleanViewState<BreathingExercisePage, BreathingExerciseController> 
    with TickerProviderStateMixin {
  
  // Controladores de animación para la UI
  late AnimationController _breathingAnimationController;
  late AnimationController _progressAnimationController;
  
  // Timers para el ejercicio
  Timer? _exerciseTimer;
  Timer? _phaseTimer;
  
  // Colores de la paleta negro/verde fosforescente/blanco
  static const Color _negro = Color(0xFF000000);
  static const Color _verdeFosforescente = Color(0xFF00FF41);
  static const Color _verdeOscuro = Color(0xFF00AA2B);
  static const Color _grisOscuro = Color(0xFF1A1A1A);

  // Constructor que inicializa el controller
  _BreathingExerciseViewState() : super(BreathingExerciseController(
    presenter_file.BreathingExercisePresenter()
  ));

  void _initializeView() {
    _initAnimations();
    _setupPresenterCallbacks();
  }

  /// Inicializa las animaciones
  void _initAnimations() {
    _breathingAnimationController = AnimationController(
      duration: const Duration(seconds: 19), // 4+7+8
      vsync: this,
    );
    
    _progressAnimationController = AnimationController(
      duration: Duration(seconds: 19 * controller.totalCycles),
      vsync: this,
    );
  }

  /// Configura las callbacks del presenter
  void _setupPresenterCallbacks() {
    final presenter = controller.getPresenter();
    
    presenter.setViewCallbacks(
      navigateToHome: () => Navigator.of(context).pop(),
      showError: (message) => _showSnackBar(message, isError: true),
      showSuccess: (message) => _showSnackBar(message, isError: false),
      showInfo: (info) => _showInfoDialog(info),
      showSettings: () => _showSettingsDialog(),
      startPhase: (phase, duration) => _handlePhaseChange(phase, duration),
      exerciseComplete: () => _showCompletionDialog(),
      hapticFeedback: () => {}, // Ya manejado en el presenter
    );
  }

  @override
  void dispose() {
    _breathingAnimationController.dispose();
    _progressAnimationController.dispose();
    _exerciseTimer?.cancel();
    _phaseTimer?.cancel();
    super.dispose();
  }

  /// Maneja el cambio de fase de respiración
  void _handlePhaseChange(String phase, int duration) {
    _breathingAnimationController.duration = Duration(seconds: duration);
    
    switch (phase) {
      case 'inhale':
        _breathingAnimationController.forward();
        break;
      case 'hold':
        // Mantener en el estado actual
        break;
      case 'exhale':
        _breathingAnimationController.reverse();
        break;
    }
    
    _startPhaseTimer(duration);
  }

  /// Inicia el timer de la fase actual
  void _startPhaseTimer(int duration) {
    _phaseTimer?.cancel();
    
    _phaseTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      final elapsed = timer.tick * 16 / 1000;
      final progress = elapsed / duration;
      final timeRemaining = duration - elapsed.floor();
      
      if (elapsed >= duration) {
        timer.cancel();
        controller.nextPhase();
      } else {
        controller.updatePhaseProgress(progress.clamp(0.0, 1.0), timeRemaining.clamp(0, duration));
      }
    });
  }

  /// Muestra un SnackBar
  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.withOpacity(0.8) : Colors.green.withOpacity(0.8),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Muestra el diálogo de información
  void _showInfoDialog(String info) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: _verdeFosforescente, size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    'Información',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                info,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Cerrar',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Muestra el diálogo de configuración
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.settings, color: _verdeFosforescente, size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    'Configuración',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Configurar ejercicio de respiración',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              // Aquí se puede agregar configuración de formas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShapeButton('circle', 'Círculo'),
                  _buildShapeButton('square', 'Cuadrado'),
                  _buildShapeButton('triangle', 'Triángulo'),
                ],
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Cerrar',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye un botón de forma
  Widget _buildShapeButton(String shape, String label) {
    return GestureDetector(
      onTap: () {
        controller.changeShape(shape);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: controller.selectedShape == shape 
              ? _verdeFosforescente.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          border: Border.all(
            color: controller.selectedShape == shape 
                ? _verdeFosforescente
                : Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              shape == 'circle' ? Icons.circle_outlined :
              shape == 'square' ? Icons.square_outlined : Icons.change_history_outlined,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Muestra el diálogo de completado
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: _verdeFosforescente, size: 32),
                  const SizedBox(width: 12),
                  const Text(
                    '¡Excelente trabajo!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Has completado ${controller.totalCycles} ciclos de respiración 4-7-8.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: 'Hacer de nuevo',
                      onPressed: () {
                        Navigator.of(context).pop();
                        controller.resetExercise();
                      },
                      variant: ButtonVariant.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Finalizar',
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Convierte la fase de respiración a texto legible
  String _getPhaseText(String phase) {
    switch (phase) {
      case 'inhale':
        return 'Inhala';
      case 'hold':
        return 'Mantén';
      case 'exhale':
        return 'Exhala';
      case 'rest':
        return 'Prepárate';
      default:
        return 'Respira';
    }
  }

  /// Convierte el código de forma a enum
  BreathingShape _getBreathingShape(String shape) {
    switch (shape) {
      case 'circle':
        return BreathingShape.circle;
      case 'square':
        return BreathingShape.square;
      case 'triangle':
        return BreathingShape.triangle;
      default:
        return BreathingShape.circle;
    }
  }

  /// Convierte el código de fase a enum
  BreathingPhase _getBreathingPhase(String phase) {
    switch (phase) {
      case 'inhale':
        return BreathingPhase.inhale;
      case 'hold':
        return BreathingPhase.hold;
      case 'exhale':
        return BreathingPhase.exhale;
      case 'rest':
        return BreathingPhase.rest;
      default:
        return BreathingPhase.rest;
    }
  }

  @override
  Widget get view {
    final theme = Theme.of(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.9)),
        title: Text(
          'Respiración 4-7-8',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => controller.showInfo(),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _negro,
              _grisOscuro,
              _negro,
            ],
          ),
        ),
        child: ControlledWidgetBuilder<BreathingExerciseController>(
          builder: (context, controller) {
            return Stack(
              children: [
                // Contenido principal
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 120, bottom: 160),
                    child: Column(
                      children: [
                        // Información del ejercicio
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: GlassCard(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  'Ciclo ${controller.currentCycle + 1} de ${controller.totalCycles}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Barra de progreso
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  child: LinearProgressIndicator(
                                    value: controller.currentCycle / controller.totalCycles,
                                    backgroundColor: Colors.transparent,
                                    valueColor: AlwaysStoppedAnimation<Color>(_verdeFosforescente),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Área principal del ejercicio
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Círculo de respiración
                              RepaintBoundary(
                                child: BreathingShapeWidget(
                                  shape: _getBreathingShape(controller.selectedShape),
                                  phase: _getBreathingPhase(controller.currentPhase),
                                  progress: controller.phaseProgress,
                                  size: 220,
                                  primaryColor: _verdeFosforescente,
                                  secondaryColor: _verdeOscuro,
                                  showGuidance: false,
                                  enableHapticFeedback: true,
                                ),
                              ),
                              
                              const SizedBox(height: 48),
                              
                              // Instrucciones de fase
                              GlassCard(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 24,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      _getPhaseText(controller.currentPhase),
                                      style: theme.textTheme.headlineMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (controller.phaseTimeRemaining > 0)
                                      Text(
                                        controller.phaseTimeRemaining.toString(),
                                        style: theme.textTheme.displayLarge?.copyWith(
                                          color: Colors.white.withOpacity(0.9),
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Botones de control fijos
                Positioned(
                  bottom: 80,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Botón de configuración
                      GestureDetector(
                        onTap: () => controller.showSettings(),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.settings,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      // Botón de play/pause principal
                      GestureDetector(
                        onTap: () {
                          if (controller.isPlaying) {
                            controller.pauseExercise();
                          } else if (controller.isPaused) {
                            controller.resumeExercise();
                          } else {
                            controller.startExercise();
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                _verdeFosforescente.withOpacity(0.8),
                                _verdeOscuro.withOpacity(0.8),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _verdeFosforescente.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            controller.isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      // Botón de stop
                      GestureDetector(
                        onTap: () => controller.stopExercise(),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.stop,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}