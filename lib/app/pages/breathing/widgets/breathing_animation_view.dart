import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../styles/app_colors.dart';
import '../breathing_cubit.dart';

/// Vista de animación del ejercicio de respiración con círculo animado
/// 
/// Especificaciones:
/// - Círculo con glow (boxShadow) que crece y decrece
/// - Tamaño: 100.0 (mínimo) a 300.0 (máximo)
/// - Ciclo: INHALAR (4s) → SOSTENER (4s) → EXHALAR (7s)
/// - Delay inicial de 4 segundos antes del primer ciclo
/// - Animación continua en loop
class BreathingAnimationView extends StatefulWidget {
  const BreathingAnimationView({super.key});

  @override
  State<BreathingAnimationView> createState() => _BreathingAnimationViewState();
}

class _BreathingAnimationViewState extends State<BreathingAnimationView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _glowAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  String _currentPhase = 'PREPÁRATE';
  bool _isInitialDelay = true;

  @override
  void initState() {
    super.initState();
    
    // Configurar el controlador de animación para el ciclo completo (15 segundos)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );

    // Animación del tamaño del círculo
    _sizeAnimation = TweenSequence<double>([
      // INHALAR (0.0 - 0.267): 100 → 300 (4 segundos)
      TweenSequenceItem(
        tween: Tween<double>(begin: 100.0, end: 300.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 26.7,
      ),
      // SOSTENER (0.267 - 0.533): 300 (4 segundos)
      TweenSequenceItem(
        tween: ConstantTween<double>(300.0),
        weight: 26.7,
      ),
      // EXHALAR (0.533 - 1.0): 300 → 100 (7 segundos)
      TweenSequenceItem(
        tween: Tween<double>(begin: 300.0, end: 100.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 46.6,
      ),
    ]).animate(_controller);

    // Animación del glow (blurRadius sigue al tamaño)
    _glowAnimation = TweenSequence<double>([
      // INHALAR: glow aumenta 20 → 60
      TweenSequenceItem(
        tween: Tween<double>(begin: 20.0, end: 60.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 26.7,
      ),
      // SOSTENER: glow máximo 60
      TweenSequenceItem(
        tween: ConstantTween<double>(60.0),
        weight: 26.7,
      ),
      // EXHALAR: glow disminuye 60 → 20
      TweenSequenceItem(
        tween: Tween<double>(begin: 60.0, end: 20.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 46.6,
      ),
    ]).animate(_controller);

    // Listener para cambiar el texto según la fase
    _controller.addListener(() {
      final progress = _controller.value;
      String newPhase;
      
      if (progress < 0.267) {
        newPhase = 'INHALA';
      } else if (progress < 0.533) {
        newPhase = 'SOSTÉN';
      } else {
        newPhase = 'EXHALA';
      }
      
      if (newPhase != _currentPhase && !_isInitialDelay) {
        setState(() {
          _currentPhase = newPhase;
        });
        _playStepSound();
      }
    });

    // Delay inicial de 4 segundos antes de comenzar
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _isInitialDelay = false;
          _currentPhase = 'INHALA';
        });
        _controller.repeat(); // Loop infinito
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Reproduce sonido de feedback al cambiar de paso
  Future<void> _playStepSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/chime.wav'));
    } catch (e) {
      // Silenciosamente ignorar error de audio si el archivo no existe
      debugPrint('Error reproduciendo audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Botón de cerrar en la esquina superior izquierda
          SafeArea(
            child: Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white.withOpacity(0.7),
                  size: 28,
                ),
                onPressed: () {
                  context.read<BreathingCubit>().backToList();
                },
              ),
            ),
          ),
          
          // Contenido principal centrado
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Texto de instrucción arriba del círculo
                Text(
                  _currentPhase,
                  style: GoogleFonts.lato(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
                
                SizedBox(height: 60.h),
                
                // Círculo animado con glow
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final size = _sizeAnimation.value;
                    final glowRadius = _glowAnimation.value;
                    
                    return Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary,
                            blurRadius: glowRadius,
                            spreadRadius: glowRadius / 3,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
