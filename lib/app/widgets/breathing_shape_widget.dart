import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// Widget optimizado para animaciones de respiración con nueva paleta de colores
/// 
/// OPTIMIZACIONES APLICADAS:
/// - Reducción de AnimationControllers para mejorar performance
/// - Nueva paleta cálida y emocional (Rosa, Magenta, Vino, Marrón)
/// - Curvas de animación más naturales (easeInOutCubic, easeInOutSine)
/// - RepaintBoundary para aislar el canvas y mejorar FPS
/// - Animaciones más suaves y sincronizadas
enum BreathingShape { circle, square, triangle }

/// Fases de la respiración con transiciones mejoradas
enum BreathingPhase { inhale, hold, exhale, rest }

class BreathingShapeWidget extends StatefulWidget {
  final BreathingShape shape;
  final BreathingPhase phase;
  final double progress; // 0.0 a 1.0
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final bool showGuidance;
  final bool enableHapticFeedback;

  const BreathingShapeWidget({
    super.key,
    required this.shape,
    required this.phase,
    required this.progress,
    this.size = 200.0,
    this.primaryColor = const Color(0xFFFD3E81), // Rosa brillante
    this.secondaryColor = const Color(0xFFD72483), // Magenta
    this.showGuidance = true,
    this.enableHapticFeedback = true,
  });

  @override
  State<BreathingShapeWidget> createState() => _BreathingShapeWidgetState();
}

class _BreathingShapeWidgetState extends State<BreathingShapeWidget>
    with TickerProviderStateMixin {
  
  // OPTIM: Reducir controladores de animación para mejor performance
  late AnimationController _holdAnimationController;
  late Animation<double> _holdAnimation;
  
  BreathingPhase? _previousPhase;
  bool _animationsInitialized = false;

  @override
  void initState() {
    super.initState();
    
    // FIX: Inicialización síncrona de animaciones
    _initializeAnimations();
  }

  /// OPTIM: Inicialización simplificada de animaciones
  void _initializeAnimations() {
    try {
      // Solo una animación para micro-pulso durante retención
      _holdAnimationController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );
      
      _holdAnimation = Tween<double>(
        begin: 0.98,
        end: 1.02,
      ).animate(CurvedAnimation(
        parent: _holdAnimationController,
        curve: Curves.easeInOutSine, // FIX: Curva más natural
      ));
      
      _animationsInitialized = true;
    } catch (e) {
      debugPrint('Error inicializando animaciones: $e');
    }
  }

  @override
  void didUpdateWidget(BreathingShapeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Solo procesar si las animaciones están inicializadas
    if (!_animationsInitialized) return;
    
    // Detectar cambio de fase para feedback háptico
    if (oldWidget.phase != widget.phase) {
      _previousPhase = oldWidget.phase;
      _triggerPhaseTransition();
    }
    
    // Animar durante la retención para dar feedback visual sutil
    if (widget.phase == BreathingPhase.hold && oldWidget.phase != BreathingPhase.hold) {
      _holdAnimationController.repeat(reverse: true);
    } else if (widget.phase != BreathingPhase.hold && oldWidget.phase == BreathingPhase.hold) {
      _holdAnimationController.stop();
      _holdAnimationController.reset();
    }
  }

  /// Maneja las transiciones entre fases con feedback háptico
  void _triggerPhaseTransition() {
    if (!widget.enableHapticFeedback) return;

    // Feedback háptico específico para cada transición
    switch (widget.phase) {
      case BreathingPhase.inhale:
        if (_previousPhase == BreathingPhase.rest || _previousPhase == BreathingPhase.exhale) {
          HapticFeedback.lightImpact(); // Inicio de ciclo
        }
        break;
      case BreathingPhase.hold:
        HapticFeedback.selectionClick(); // Transición sutil
        break;
      case BreathingPhase.exhale:
        HapticFeedback.selectionClick(); // Cambio de fase
        break;
      case BreathingPhase.rest:
        if (_previousPhase == BreathingPhase.exhale) {
          HapticFeedback.lightImpact(); // Fin de ciclo
        }
        break;
    }
  }

  @override
  void dispose() {
    if (_animationsInitialized) {
      _holdAnimationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary( // OPTIM: Aislar canvas para mejor performance
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // FIX: Forma principal simplificada con una sola animación
            AnimatedBuilder(
              animation: _holdAnimation,
              builder: (context, child) {
                // Validar que las animaciones estén inicializadas
                if (!_animationsInitialized) {
                  return CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _getShapePainter(),
                  );
                }
                
                final scaleFactor = _getScaleFactor();
                
                // Validar que scaleFactor sea un número válido
                if (!scaleFactor.isFinite || scaleFactor <= 0) {
                  return CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _getShapePainter(),
                  );
                }
                
                return Transform.scale(
                  scale: scaleFactor,
                  child: CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _getShapePainter(),
                  ),
                );
              },
            ),
            
            // Texto de guía si está habilitado
            if (widget.showGuidance)
              _buildGuidanceText(),
          ],
        ),
      ),
    );
  }

  /// OPTIM: Factor de escala simplificado basado en fase y progreso
  double _getScaleFactor() {
    const double minScale = 0.6;
    const double maxScale = 1.0;
    
    switch (widget.phase) {
      case BreathingPhase.inhale:
        // FIX: Interpolación suave para inhalación
        final progress = Curves.easeInOutSine.transform(widget.progress);
        return minScale + (maxScale - minScale) * progress;
        
      case BreathingPhase.hold:
        // Micro-pulso durante retención
        if (_animationsInitialized) {
          return maxScale * _holdAnimation.value;
        }
        return maxScale;
        
      case BreathingPhase.exhale:
        // FIX: Contracción suave para exhalación
        final progress = Curves.easeInOutSine.transform(widget.progress);
        return maxScale - (maxScale - minScale) * progress;
        
      case BreathingPhase.rest:
        return minScale;
    }
  }

  /// Obtiene el painter apropiado según la forma seleccionada
  CustomPainter _getShapePainter() {
    switch (widget.shape) {
      case BreathingShape.circle:
        return _CirclePainter(
          primaryColor: widget.primaryColor,
          secondaryColor: widget.secondaryColor,
        );
      case BreathingShape.square:
        return _SquarePainter(
          primaryColor: widget.primaryColor,
          secondaryColor: widget.secondaryColor,
        );
      case BreathingShape.triangle:
        return _TrianglePainter(
          primaryColor: widget.primaryColor,
          secondaryColor: widget.secondaryColor,
        );
    }
  }

  /// Construye el texto de guía para la respiración con animación
  Widget _buildGuidanceText() {
    String text;
    Color textColor;

    switch (widget.phase) {
      case BreathingPhase.inhale:
        text = 'Inhala';
        textColor = widget.primaryColor;
        break;
      case BreathingPhase.hold:
        text = 'Mantén';
        textColor = widget.secondaryColor;
        break;
      case BreathingPhase.exhale:
        text = 'Exhala';
        textColor = widget.primaryColor;
        break;
      case BreathingPhase.rest:
        text = 'Descansa';
        textColor = Colors.grey;
        break;
    }

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      child: Text(text),
    );
  }
}

/// Painter para círculo con efecto glassmorphism
class _CirclePainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  _CirclePainter({
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Gradiente radial
    final gradient = RadialGradient(
      colors: [
        primaryColor.withOpacity(0.3),
        secondaryColor.withOpacity(0.1),
        primaryColor.withOpacity(0.05),
      ],
      stops: const [0.0, 0.7, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    // Círculo principal
    canvas.drawCircle(center, radius, paint);

    // Borde
    final borderPaint = Paint()
      ..color = primaryColor.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter para cuadrado con efecto glassmorphism
class _SquarePainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  _SquarePainter({
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Gradiente lineal
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor.withOpacity(0.3),
        secondaryColor.withOpacity(0.1),
        primaryColor.withOpacity(0.05),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    final borderRadius = Radius.circular(size.width * 0.1);
    final rrect = RRect.fromRectAndRadius(rect, borderRadius);

    // Cuadrado principal
    canvas.drawRRect(rrect, paint);

    // Borde
    final borderPaint = Paint()
      ..color = primaryColor.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter para triángulo con efecto glassmorphism
class _TrianglePainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  _TrianglePainter({
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Crear triángulo equilátero
    for (int i = 0; i < 3; i++) {
      final angle = (i * 2 * math.pi / 3) - (math.pi / 2); // Comenzar desde arriba
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // Gradiente
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        primaryColor.withOpacity(0.3),
        secondaryColor.withOpacity(0.1),
        primaryColor.withOpacity(0.05),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(path.getBounds())
      ..style = PaintingStyle.fill;

    // Triángulo principal
    canvas.drawPath(path, paint);

    // Borde
    final borderPaint = Paint()
      ..color = primaryColor.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}