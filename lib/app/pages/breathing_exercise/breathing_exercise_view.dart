import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/breathing_shape_widget.dart';

/// Vista del ejercicio de respiración con diseño glassmorphism refinado
/// 
/// OPTIMIZACIONES APLICADAS:
/// - Animaciones fluidas con curvas naturales (easeInOutCubic, easeInOutSine)
/// - Performance mejorada con RepaintBoundary y menos setState()
/// - Nueva paleta de colores cálida y emocional
/// - Barra de pausa redimensionada y correctamente posicionada
/// - Sincronización perfecta entre fases de respiración
class BreathingExercisePage extends StatefulWidget {
  const BreathingExercisePage({Key? key}) : super(key: key);

  @override
  State<BreathingExercisePage> createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage>
    with TickerProviderStateMixin {
  
  // OPTIM: Controladores de animación movidos a initState para mejor gestión
  late AnimationController _breathingAnimationController;
  late AnimationController _progressAnimationController;
  
  // FIX: Nueva paleta negro/verde fosforescente/blanco
  static const Color _negro = Color(0xFF000000);
  static const Color _verdeFosforescente = Color(0xFF00FF41);
  static const Color _verdeOscuro = Color(0xFF00AA2B);
  static const Color _blanco = Color(0xFFFFFFFF);
  static const Color _grisOscuro = Color(0xFF1A1A1A);
  
  // Estado del ejercicio
  bool _isPlaying = false;
  bool _isPaused = false;
  int _currentCycle = 0;
  int _totalCycles = 8;
  BreathingPhase _currentPhase = BreathingPhase.rest;
  BreathingShape _selectedShape = BreathingShape.circle;
  double _phaseProgress = 0.0;
  int _phaseTimeRemaining = 0;
  
  // Configuración del ejercicio (4-7-8) con duraciones más naturales
  final int _inhaleTime = 4;
  final int _holdTime = 7;
  final int _exhaleTime = 8;
  
  Timer? _exerciseTimer;
  Timer? _phaseTimer;

  @override
  void initState() {
    super.initState();
    
    // FIX: Inicialización síncrona de animaciones en initState
    _initAnimations();
  }

  void _initAnimations() {
    // OPTIM: Animación principal de respiración con curvas suaves
    _breathingAnimationController = AnimationController(
      duration: Duration(seconds: _inhaleTime + _holdTime + _exhaleTime),
      vsync: this,
    );
    
    // Animación para el progreso general
    _progressAnimationController = AnimationController(
      duration: Duration(seconds: (_inhaleTime + _holdTime + _exhaleTime) * _totalCycles),
      vsync: this,
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

  void _startExercise() {
    setState(() {
      _isPlaying = true;
      _isPaused = false;
      _currentCycle = 0;
    });
    
    _progressAnimationController.forward();
    _startBreathingCycle();
  }

  void _pauseExercise() {
    setState(() {
      _isPaused = true;
      _isPlaying = false;
    });
    
    _progressAnimationController.stop();
    _breathingAnimationController.stop();
    _exerciseTimer?.cancel();
    _phaseTimer?.cancel();
  }

  void _resumeExercise() {
    setState(() {
      _isPaused = false;
      _isPlaying = true;
    });
    
    _progressAnimationController.forward();
    _continueFromCurrentPhase();
  }

  void _stopExercise() {
    setState(() {
      _isPlaying = false;
      _isPaused = false;
      _currentCycle = 0;
      _currentPhase = BreathingPhase.rest;
      _phaseProgress = 0.0;
    });
    
    _progressAnimationController.reset();
    _breathingAnimationController.reset();
    _exerciseTimer?.cancel();
    _phaseTimer?.cancel();
  }

  void _startBreathingCycle() {
    if (_currentCycle >= _totalCycles) {
      _completeExercise();
      return;
    }
    
    _inhalePhase();
  }

  // OPTIM: Método de inhalación con animación fluida
  void _inhalePhase() {
    setState(() {
      _currentPhase = BreathingPhase.inhale;
      _phaseTimeRemaining = _inhaleTime;
      _phaseProgress = 0.0;
    });
    
    // FIX: Usar AnimationController en lugar de Timer para animaciones más fluidas
    _breathingAnimationController.reset();
    _breathingAnimationController.duration = Duration(seconds: _inhaleTime);
    _breathingAnimationController.forward().then((_) {
      if (mounted && _isPlaying && !_isPaused) {
        _holdPhase();
      }
    });
    
    // OPTIM: Timer con mayor frecuencia para animaciones más suaves (60 FPS)
    _phaseTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted || !_isPlaying || _isPaused) {
        timer.cancel();
        return;
      }
      
      final elapsed = timer.tick * 16 / 1000; // FIX: Ajustar cálculo para 16ms
      final newProgress = elapsed / _inhaleTime;
      final newTimeRemaining = _inhaleTime - elapsed.floor();
      
      // Solo actualizar si hay cambios significativos
      if ((newProgress - _phaseProgress).abs() > 0.1 || newTimeRemaining != _phaseTimeRemaining) {
        setState(() {
          _phaseProgress = newProgress.clamp(0.0, 1.0);
          _phaseTimeRemaining = newTimeRemaining.clamp(0, _inhaleTime);
        });
      }
      
      if (elapsed >= _inhaleTime) {
        timer.cancel();
      }
    });
  }

  void _holdPhase() {
    setState(() {
      _currentPhase = BreathingPhase.hold;
      _phaseTimeRemaining = _holdTime;
      _phaseProgress = 0.0;
    });
    
    // FIX: Usar animación para mantener el estado con micro-pulso
    _breathingAnimationController.duration = Duration(seconds: _holdTime);
    _breathingAnimationController.forward().then((_) {
      if (mounted && _isPlaying && !_isPaused) {
        _exhalePhase();
      }
    });
    
    _phaseTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted || !_isPlaying || _isPaused) {
        timer.cancel();
        return;
      }
      
      final elapsed = timer.tick * 16 / 1000; // FIX: Ajustar cálculo para 16ms
      final newProgress = elapsed / _holdTime;
      final newTimeRemaining = _holdTime - elapsed.floor();
      
      if ((newProgress - _phaseProgress).abs() > 0.01 || newTimeRemaining != _phaseTimeRemaining) { // FIX: Umbral más bajo para actualizaciones más frecuentes
        setState(() {
          _phaseProgress = newProgress.clamp(0.0, 1.0);
          _phaseTimeRemaining = newTimeRemaining.clamp(0, _holdTime);
        });
      }
      
      if (elapsed >= _holdTime) {
        timer.cancel();
      }
    });
  }

  void _exhalePhase() {
    setState(() {
      _currentPhase = BreathingPhase.exhale;
      _phaseTimeRemaining = _exhaleTime;
      _phaseProgress = 0.0;
    });
    
    // FIX: Usar animación para exhalación suave
    _breathingAnimationController.duration = Duration(seconds: _exhaleTime);
    _breathingAnimationController.reverse().then((_) {
      if (mounted && _isPlaying && !_isPaused) {
        setState(() {
          _currentCycle++;
        });
        
        if (_currentCycle < _totalCycles) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _startBreathingCycle();
          });
        } else {
          _completeExercise();
        }
      }
    });
    
    _phaseTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted || !_isPlaying || _isPaused) {
        timer.cancel();
        return;
      }
      
      final elapsed = timer.tick * 16 / 1000; // FIX: Ajustar cálculo para 16ms
      final newProgress = elapsed / _exhaleTime;
      final newTimeRemaining = _exhaleTime - elapsed.floor();
      
      if ((newProgress - _phaseProgress).abs() > 0.01 || newTimeRemaining != _phaseTimeRemaining) { // FIX: Umbral más bajo para actualizaciones más frecuentes
        setState(() {
          _phaseProgress = newProgress.clamp(0.0, 1.0);
          _phaseTimeRemaining = newTimeRemaining.clamp(0, _exhaleTime);
        });
      }
      
      if (elapsed >= _exhaleTime) {
        timer.cancel();
      }
    });
  }

  void _continueFromCurrentPhase() {
    // Lógica para continuar desde la fase actual después de pausa
    if (_currentPhase == BreathingPhase.inhale) {
      _inhalePhase();
    } else if (_currentPhase == BreathingPhase.hold) {
      _holdPhase();
    } else if (_currentPhase == BreathingPhase.exhale) {
      _exhalePhase();
    }
  }

  void _completeExercise() {
    setState(() {
      _isPlaying = false;
      _currentPhase = BreathingPhase.rest;
    });
    
    // Mostrar dialog de completado
    _showCompletionDialog();
  }

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
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 32),
                  SizedBox(width: 12),
                  Text(
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
                'Has completado $_totalCycles ciclos de respiración 4-7-8.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 20),
              
              const Text(
                '¿Cómo te sientes ahora?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMoodButton('😌', 'Relajado'),
                  _buildMoodButton('😊', 'Feliz'),
                  _buildMoodButton('🧘', 'Tranquilo'),
                  _buildMoodButton('💪', 'Energizado'),
                ],
              ),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'Terminar',
                      onPressed: () {
                        Navigator.of(context).pop(); // Cerrar dialog
                        Navigator.of(context).pop(); // Volver a home
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Repetir',
                      onPressed: () {
                        Navigator.of(context).pop(); // Cerrar dialog
                        _resetExercise(); // Reiniciar ejercicio
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

  Widget _buildMoodButton(String emoji, String label) {
    return GestureDetector(
      onTap: () {
        // Guardar estado de ánimo
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Te sientes $label'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
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

  /// Convierte la fase de respiración a texto legible
  String _getPhaseText(BreathingPhase phase) {
    switch (phase) {
      case BreathingPhase.inhale:
        return 'Inhala';
      case BreathingPhase.hold:
        return 'Mantén';
      case BreathingPhase.exhale:
        return 'Exhala';
      case BreathingPhase.rest:
        return 'Prepárate';
    }
  }

  void _resetExercise() {
    _stopExercise();
    setState(() {
      _currentCycle = 0;
      _currentPhase = BreathingPhase.rest;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          GlassIconButton(
            icon: Icons.info_outline,
            onPressed: () {
              _showInfoDialog();
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        // FIX: Nueva paleta negro/verde fosforescente/blanco
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _negro,         // Negro en la parte superior
              _grisOscuro,    // Gris oscuro en el centro
              _negro,         // Negro en la parte inferior
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Contenido principal (scrollable si es necesario)
              SingleChildScrollView(
                child: Column(
                  children: [
                    // FIX: Barra de pausa redimensionada y reposicionada
                    if (_isPaused)
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Container(
                          height: 8, // FIX: Reducida de tamaño
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white.withOpacity(0.3), // FIX: Integración visual suave
                          ),
                          child: Center(
                            child: Text(
                              'PAUSADO',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    
                    // Información del ejercicio con glassmorphism
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: GlassCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              'Ciclo ${_currentCycle + 1} de $_totalCycles',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Barra de progreso mejorada
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: LinearProgressIndicator(
                                value: _currentCycle / _totalCycles,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _verdeFosforescente.withOpacity(0.8), // FIX: Verde fosforescente
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Área principal del ejercicio (centrada verticalmente)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // FIX: Círculo de respiración con nueva paleta de colores
                          RepaintBoundary( // OPTIM: Aislar canvas para mejor performance
                            child: BreathingShapeWidget(
                              shape: _selectedShape,
                              phase: _currentPhase,
                              progress: _phaseProgress,
                              size: 220,
                              primaryColor: _verdeFosforescente, // Verde fosforescente
                              secondaryColor: _verdeOscuro,    // Verde oscuro
                              showGuidance: false, // El texto lo mostramos por separado
                              enableHapticFeedback: true, // Habilitar feedback háptico
                            ),
                          ),
                          
                          const SizedBox(height: 48),
                          
                          // Instrucciones de fase con glassmorphism
                          GlassCard(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 24,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _getPhaseText(_currentPhase),
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                
                                const SizedBox(height: 12),
                                
                                // Contador de tiempo
                                if (_phaseTimeRemaining > 0)
                                  Text(
                                    _phaseTimeRemaining.toString(),
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
                    
                    // Espacio adicional para evitar que el contenido se esconda detrás de los botones fijos
                    const SizedBox(height: 120),
                  ],
                ),
              ),
              
              // Controles fijos en la parte inferior
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Botón de stop
                      GlassIconButton(
                        icon: Icons.stop,
                        size: 50, // FIX: Reducido de 60 a 50
                        onPressed: _isPlaying || _isPaused ? _stopExercise : null,
                      ),
                      
                      // Botón principal play/pause
                      GestureDetector(
                        onTap: () {
                          if (!_isPlaying && !_isPaused) {
                            _startExercise();
                          } else if (_isPlaying) {
                            _pauseExercise();
                          } else if (_isPaused) {
                            _resumeExercise();
                          }
                        },
                        child: Container(
                          width: 70, // FIX: Reducido de 90 a 70 para evitar solapamiento
                          height: 70, // FIX: Reducido de 90 a 70 para evitar solapamiento
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                _verdeFosforescente.withOpacity(0.8), // FIX: Nueva paleta
                                _verdeOscuro.withOpacity(0.8),        // FIX: Nueva paleta
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _verdeFosforescente.withOpacity(0.4), // FIX: Nueva paleta
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 35, // FIX: Reducido de 45 a 35 para proporcionalidad
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      // Botón de configuración
                      GlassIconButton(
                        icon: Icons.settings,
                        size: 50, // FIX: Reducido de 60 a 50
                        onPressed: () {
                          _showSettingsDialog();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Respiración 4-7-8'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Esta técnica te ayuda a:'),
            SizedBox(height: 10),
            Text('• Reducir el estrés y la ansiedad'),
            Text('• Mejorar la calidad del sueño'),
            Text('• Calmar el sistema nervioso'),
            Text('• Aumentar la concentración'),
            SizedBox(height: 15),
            Text('Cómo funciona:'),
            SizedBox(height: 5),
            Text('1. Inhala por 4 segundos'),
            Text('2. Mantén por 7 segundos'),
            Text('3. Exhala por 8 segundos'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configuración'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.repeat),
              title: const Text('Número de ciclos'),
              subtitle: Text('$_totalCycles ciclos'),
              onTap: () {
                // Cambiar número de ciclos
              },
            ),
            ListTile(
              leading: const Icon(Icons.volume_up),
              title: const Text('Sonidos ambientales'),
              subtitle: const Text('Activar/desactivar'),
              onTap: () {
                // Configurar sonidos
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}