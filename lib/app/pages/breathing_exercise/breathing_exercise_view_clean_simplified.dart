import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'breathing_exercise_controller.dart';
import 'breathing_exercise_presenter.dart' as presenter;

/// Vista de ejercicio de respiración siguiendo Clean Architecture
/// Versión simplificada y funcional
class BreathingExerciseViewClean extends CleanView {
  const BreathingExerciseViewClean({super.key});

  @override
  _BreathingExerciseViewCleanState createState() => _BreathingExerciseViewCleanState();
}

class _BreathingExerciseViewCleanState extends CleanViewState<BreathingExerciseViewClean, BreathingExerciseController> {
  _BreathingExerciseViewCleanState() : super(BreathingExerciseController(presenter.BreathingExercisePresenter()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.deepPurple),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.deepPurple),
            onPressed: () => _showSettingsDialog(),
          ),
        ],
      ),
      body: ControlledWidgetBuilder<BreathingExerciseController>(
        builder: (context, controller) {
          return SafeArea(
            child: Column(
              children: [
                // Header con información del ejercicio
                _buildHeader(controller),
                
                // Círculo de animación principal
                Expanded(
                  child: _buildAnimationCircle(controller),
                ),
                
                // Información de fase
                _buildPhaseInfo(controller),
                
                // Controles de reproducción
                _buildControls(controller),
                
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BreathingExerciseController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Text(
            _getExerciseName(controller.exerciseType),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[800],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Ciclo ${controller.currentCycle} de ${controller.totalCycles}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.deepPurple[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimationCircle(BreathingExerciseController controller) {
    return Center(
      child: Container(
        width: 280,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Círculo de fondo
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.deepPurple.withOpacity(0.2),
                  width: 2,
                ),
              ),
            ),
            
            // Círculo animado
            AnimatedContainer(
              duration: Duration(milliseconds: controller.currentPhaseDuration),
              width: controller.isInhaling 
                  ? 240 
                  : controller.isHolding 
                      ? 240 
                      : 160,
              height: controller.isInhaling 
                  ? 240 
                  : controller.isHolding 
                      ? 240 
                      : 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.deepPurple.withOpacity(0.3),
                    Colors.deepPurple.withOpacity(0.1),
                  ],
                ),
              ),
            ),
            
            // Texto central
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getCurrentPhaseText(controller),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(controller.currentPhaseDuration / 1000).round()} seg',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.deepPurple[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseInfo(BreathingExerciseController controller) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPhaseStep(
            'Inhalar',
            controller.inhaleSeconds,
            controller.isInhaling,
          ),
          _buildPhaseStep(
            'Retener',
            controller.holdSeconds,
            controller.isHolding,
          ),
          _buildPhaseStep(
            'Exhalar',
            controller.exhaleSeconds,
            controller.isExhaling,
          ),
          if (controller.pauseSeconds > 0)
            _buildPhaseStep(
              'Pausa',
              controller.pauseSeconds,
              controller.isPausing,
            ),
        ],
      ),
    );
  }

  Widget _buildPhaseStep(String label, int seconds, bool isActive) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive 
                ? Colors.deepPurple 
                : Colors.deepPurple.withOpacity(0.2),
          ),
          child: Center(
            child: Text(
              '$seconds',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive 
                ? Colors.deepPurple[800] 
                : Colors.deepPurple[400],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildControls(BreathingExerciseController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Botón de pausa/play
          GestureDetector(
            onTap: () => controller.isPaused 
                ? controller.resumeExercise() 
                : controller.pauseExercise(),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurple,
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                controller.isPaused ? Icons.play_arrow : Icons.pause,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          
          // Botón de stop
          GestureDetector(
            onTap: () => _showStopConfirmation(controller),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red[400],
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.stop,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          
          // Botón de restart
          GestureDetector(
            onTap: () => controller.restartExercise(),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange[400],
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getExerciseName(String exerciseType) {
    switch (exerciseType) {
      case '4-7-8':
        return 'Respiración 4-7-8';
      case 'square':
        return 'Respiración Cuadrada';
      case 'triangle':
        return 'Respiración Triangular';
      default:
        return 'Ejercicio de Respiración';
    }
  }

  String _getCurrentPhaseText(BreathingExerciseController controller) {
    if (controller.isInhaling) return 'Inhala';
    if (controller.isHolding) return 'Retén';
    if (controller.isExhaling) return 'Exhala';
    if (controller.isPausing) return 'Pausa';
    return 'Preparado';
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configuración del Ejercicio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.volume_up),
              title: const Text('Sonidos de guía'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
            ListTile(
              leading: const Icon(Icons.vibration),
              title: const Text('Vibración'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
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

  void _showStopConfirmation(BreathingExerciseController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar Ejercicio'),
        content: const Text('¿Estás seguro de que quieres finalizar el ejercicio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continuar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.stopExercise();
              Navigator.of(context).pop();
            },
            child: Text(
              'Finalizar',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}