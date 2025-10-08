import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Sistema de transiciones suaves para la app Breathe
/// Incluye animaciones personalizadas con curvas easeInOutCubic para fluidez extra
class BreatheTransitions {
  /// Duración estándar para transiciones meditativas (600ms - 1.2s)
  static const Duration slow = Duration(milliseconds: 1200);
  static const Duration medium = Duration(milliseconds: 800);
  static const Duration fast = Duration(milliseconds: 600);
  static const Duration microInteraction = Duration(milliseconds: 150);

  /// Curvas de animación suaves para experiencia relajante
  static const Curve easeInOutCubic = Curves.easeInOutCubic;
  static const Curve easeInOutExpo = Curves.easeInOutExpo;
  static const Curve elasticOut = Curves.elasticOut;

  /// Crear una transición de página personalizada con fade
  static PageRouteBuilder<T> fadeRoute<T>({
    required Widget child,
    Duration duration = medium,
    Curve curve = easeInOutCubic,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: curve,
          ),
          child: child,
        );
      },
    );
  }

  /// Crear una transición de página con slide desde abajo
  static PageRouteBuilder<T> slideUpRoute<T>({
    required Widget child,
    Duration duration = medium,
    Curve curve = easeInOutCubic,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(
          tween.chain(CurveTween(curve: curve)),
        );

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: curve,
            ),
            child: child,
          ),
        );
      },
    );
  }

  /// Crear una transición Hero personalizada
  static Widget heroTransition({
    required String tag,
    required Widget child,
    Duration duration = medium,
  }) {
    return Hero(
      tag: tag,
      transitionOnUserGestures: true,
      child: child,
    );
  }
}

/// Widget para animaciones de entrada suaves
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset offset;
  final Curve curve;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.offset = const Offset(0, 50),
    this.curve = Curves.easeInOutCubic,
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Iniciar animación después del delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Validar que el offset de la animación sea válido
          final slideValue = _slideAnimation.value;
          final fadeValue = _fadeAnimation.value;
          
          // Verificar que los valores sean finitos y válidos
          if (!slideValue.dx.isFinite || !slideValue.dy.isFinite || 
              !fadeValue.isFinite || fadeValue < 0.0 || fadeValue > 1.0) {
            return widget.child; // Retornar widget sin transformación si hay valores inválidos
          }
          
          return Transform.translate(
            offset: slideValue,
            child: Opacity(
              opacity: fadeValue.clamp(0.0, 1.0),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

/// Widget para microinteracciones con escala y feedback háptico
class InteractiveScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration duration;
  final bool enableHapticFeedback;

  const InteractiveScale({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.95,
    this.duration = const Duration(milliseconds: 150),
    this.enableHapticFeedback = true,
  });

  @override
  State<InteractiveScale> createState() => _InteractiveScaleState();
}

class _InteractiveScaleState extends State<InteractiveScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            // Validar que el valor de escala sea válido
            final scaleValue = _scaleAnimation.value;
            
            if (!scaleValue.isFinite || scaleValue <= 0) {
              return widget.child; // Retornar widget sin transformación si hay valores inválidos
            }
            
            return Transform.scale(
              scale: scaleValue.clamp(0.1, 2.0), // Clamp para evitar valores extremos
              child: widget.child,
            );
          },
        ),
      ),
    );
  }
}

/// Widget para animación de vibración horizontal (errores en inputs)
class ShakeAnimation extends StatefulWidget {
  final Widget child;
  final bool trigger;
  final Duration duration;
  final double offset;

  const ShakeAnimation({
    super.key,
    required this.child,
    required this.trigger,
    this.duration = const Duration(milliseconds: 600),
    this.offset = 10.0,
  });

  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _offsetAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _shake();
    }
  }

  void _shake() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        final animationValue = _offsetAnimation.value;
        
        // Validar que el valor de animación sea válido
        if (!animationValue.isFinite) {
          return widget.child; // Retornar widget sin transformación si hay valores inválidos
        }
        
        final sin = widget.offset * 
            animationValue * 
            (1 - animationValue);
            
        // Validar que el resultado del sin sea válido
        if (!sin.isFinite) {
          return widget.child;
        }
        
        return Transform.translate(
          offset: Offset(sin.clamp(-50.0, 50.0), 0), // Clamp para evitar valores extremos
          child: widget.child,
        );
      },
    );
  }
}

/// Widget para pulso sutil (loading o énfasis)
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minOpacity;
  final double maxOpacity;
  final bool animate;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.minOpacity = 0.5,
    this.maxOpacity = 1.0,
    this.animate = true,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PulseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.repeat(reverse: true);
    } else if (!widget.animate && oldWidget.animate) {
      _controller.stop();
      _controller.value = 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Validar que el valor de opacidad sea válido
        final opacityValue = _animation.value;
        
        if (!opacityValue.isFinite || opacityValue < 0.0 || opacityValue > 1.0) {
          return widget.child; // Retornar widget sin transformación si hay valores inválidos
        }
        
        return Opacity(
          opacity: opacityValue.clamp(0.0, 1.0),
          child: widget.child,
        );
      },
    );
  }
}