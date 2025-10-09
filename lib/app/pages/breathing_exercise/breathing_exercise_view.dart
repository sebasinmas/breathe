import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../app/styles/app_theme.dart';
import 'breathing_exercise_controller.dart';

/// Vista del ejercicio de respiración con Clean Architecture
/// Versión mejorada con glassmorphism y animaciones fluidas
class BreathingExercisePage extends CleanView {
  const BreathingExercisePage({super.key});

  @override
  State<StatefulWidget> createState() => _BreathingExerciseViewState();
}

class _BreathingExerciseViewState extends CleanViewState<BreathingExercisePage, BreathingExerciseController> {
  
  _BreathingExerciseViewState() : super(BreathingExerciseController());

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      extendBodyBehindAppBar: true,
      appBar: _buildGlassAppBar(),
      body: Container(
        decoration: _buildGradientBackground(),
        child: ControlledWidgetBuilder<BreathingExerciseController>(
          builder: (context, controller) {
            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Información del ejercicio con glassmorphism
                  _buildExerciseInfo(controller),
                  
                  // Área principal de respiración
                  Expanded(
                    child: _buildBreathingArea(controller),
                  ),
                  
                  // Indicadores de fase
                  _buildPhaseIndicators(controller),
                  
                  // Controles de reproducción
                  _buildPlaybackControls(controller),
                  
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildGlassAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Respiración 4-7-8',
        style: AppTheme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: _showInfo,
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  BoxDecoration _buildGradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.primaryBlue.withOpacity(0.8),
          AppTheme.mintGreen.withOpacity(0.6),
          AppTheme.primaryBlue.withOpacity(0.9),
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  Widget _buildExerciseInfo(BreathingExerciseController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ciclo ${controller.currentCycle + 1} de ${controller.totalCycles}',
                style: AppTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Técnica de relajación profunda',
                style: AppTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.6),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.mintGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.mintGreen.withOpacity(0.2),
                width: 0.5,
              ),
            ),
            child: Text(
              controller.exerciseType,
              style: AppTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.mintGreen,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreathingArea(BreathingExerciseController controller) {
    return Center(
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: controller.currentPhaseDuration),
        curve: Curves.easeInOut,
        tween: Tween<double>(
          begin: _getPreviousSize(controller),
          end: _getTargetSize(controller),
        ),
        builder: (context, animatedSize, child) {
          return Container(
            width: 350,
            height: 350,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Círculos de fondo con efecto de profundidad
                ..._buildBackgroundCircles(),
                
                // Círculo principal animado
                _buildMainBreathingCircle(animatedSize, controller),
                
                // Información central
                _buildCenterContent(controller),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildBackgroundCircles() {
    return [
      // Círculo exterior fijo con brillo sutil
      Container(
        width: 320,
        height: 320,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 2,
          ),
        ),
      ),
      
      // Círculo intermedio con glassmorphism
      Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.mintGreen.withOpacity(0.3),
            width: 1,
          ),
        ),
      )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          duration: 2000.ms,
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.05, 1.05),
          curve: Curves.easeInOut,
        ),
    ];
  }

  Widget _buildMainBreathingCircle(double animatedSize, BreathingExerciseController controller) {
    return Container(
      width: animatedSize,
      height: animatedSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppTheme.mintGreen.withOpacity(0.8),
            AppTheme.primaryBlue.withOpacity(0.6),
            AppTheme.primaryBlue.withOpacity(0.3),
            Colors.transparent,
          ],
          stops: const [0.0, 0.4, 0.7, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.mintGreen.withOpacity(0.5),
            blurRadius: 40,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            blurRadius: 60,
            spreadRadius: 5,
          ),
        ],
      ),
    )
      .animate()
      .shimmer(
        duration: 3000.ms,
        color: Colors.white.withOpacity(0.3),
      );
  }

  Widget _buildCenterContent(BreathingExerciseController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Texto de fase actual con animación
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.5),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Text(
            _getCurrentPhaseText(controller),
            key: ValueKey(_getCurrentPhaseText(controller)),
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.7),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
                Shadow(
                  color: AppTheme.mintGreen.withOpacity(0.8),
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Contador de tiempo
        Text(
          '${_getCurrentPhaseDuration(controller)}s',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseIndicators(BreathingExerciseController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPhaseIndicator('Inhalar', controller.inhaleSeconds, controller.isInhaling),
          _buildPhaseDivider(),
          _buildPhaseIndicator('Retener', controller.holdSeconds, controller.isHolding),
          _buildPhaseDivider(),
          _buildPhaseIndicator('Exhalar', controller.exhaleSeconds, controller.isExhaling),
        ],
      ),
    );
  }

  Widget _buildPhaseIndicator(String label, int duration, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive 
              ? AppTheme.mintGreen.withOpacity(0.2)
              : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive 
                ? AppTheme.mintGreen
                : Colors.white.withOpacity(0.3),
              width: isActive ? 2 : 1,
            ),
          ),
          child: Text(
            '${duration}s',
            style: TextStyle(
              color: isActive ? AppTheme.mintGreen : Colors.white,
              fontSize: 16,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive 
              ? AppTheme.mintGreen
              : Colors.white.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseDivider() {
    return Container(
      width: 1,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildPlaybackControls(BreathingExerciseController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.refresh,
            onPressed: () => controller.resetExercise(),
            label: 'Reiniciar',
          ),
          
          _buildMainPlayButton(controller),
          
          _buildControlButton(
            icon: Icons.stop,
            onPressed: () => controller.stopExercise(),
            label: 'Detener',
          ),
        ],
      ),
    );
  }

  Widget _buildMainPlayButton(BreathingExerciseController controller) {
    return GestureDetector(
      onTap: () {
        if (controller.isPlaying) {
          controller.pauseExercise();
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.mintGreen,
              AppTheme.primaryBlue,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.mintGreen.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          controller.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 36,
        ),
      ),
    )
      .animate(target: controller.isPlaying ? 1 : 0)
      .scale(
        duration: 200.ms,
        begin: const Offset(1.0, 1.0),
        end: const Offset(1.1, 1.1),
        curve: Curves.easeInOut,
      );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Métodos auxiliares
  double _getPreviousSize(BreathingExerciseController controller) {
    // Retorna el tamaño anterior basado en la fase previa
    if (controller.isInhaling) return 120.0; // Venía de reposo
    if (controller.isHolding) return 240.0; // Venía de inhalar
    if (controller.isExhaling) return 240.0; // Venía de retener
    return 120.0; // Por defecto
  }

  double _getTargetSize(BreathingExerciseController controller) {
    if (controller.isInhaling) return 240.0; // Expandir
    if (controller.isHolding) return 240.0; // Mantener
    if (controller.isExhaling) return 120.0; // Contraer
    return 180.0; // Estado de reposo
  }

  String _getCurrentPhaseText(BreathingExerciseController controller) {
    if (controller.isInhaling) return 'Inhala';
    if (controller.isHolding) return 'Retén';
    if (controller.isExhaling) return 'Exhala';
    return 'Prepárate';
  }

  int _getCurrentPhaseDuration(BreathingExerciseController controller) {
    if (controller.isInhaling) return controller.inhaleSeconds;
    if (controller.isHolding) return controller.holdSeconds;
    if (controller.isExhaling) return controller.exhaleSeconds;
    return controller.pauseSeconds;
  }

  void _showInfo() {
    showDialog(
      context: globalKey.currentContext!,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Respiración 4-7-8',
          style: TextStyle(
            color: AppTheme.mintGreen, 
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        content: const Text(
          'Esta técnica de respiración ayuda a relajarse y reducir el estrés:\n\n'
          '🫁 Inhala por la nariz durante 4 segundos\n'
          '⏸️ Retén la respiración por 7 segundos\n'
          '🌬️ Exhala por la boca durante 8 segundos\n\n'
          'Repite este ciclo 8 veces para obtener los mejores resultados.\n\n'
          'Esta técnica activa el sistema nervioso parasimpático, promoviendo la calma y relajación profunda.',
          style: TextStyle(
            color: Colors.white, 
            height: 1.6,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.mintGreen.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Entendido',
              style: TextStyle(
                color: AppTheme.mintGreen, 
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}