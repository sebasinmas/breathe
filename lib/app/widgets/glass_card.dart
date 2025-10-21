import 'dart:ui';
import 'package:flutter/material.dart';

/// Widget reutilizable que implementa el efecto Glassmorphism 
/// 
/// Mejoras implementadas:
/// - Usa implementación custom optimizada para la app
/// - Configuración optimizada para iOS
/// - Parámetros personalizables
class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blurAmount;
  final double opacity;
  final Color? backgroundColor;
  final Border? border;
  final VoidCallback? onTap;

  const GlassCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blurAmount = 8.0,
    this.opacity = 0.12,
    this.backgroundColor,
    this.border,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Color de fondo más sutil y elegante
    final adaptiveBackgroundColor = backgroundColor ?? 
        (isDark 
            ? Colors.white.withOpacity(opacity * 0.8) 
            : Colors.white.withOpacity(opacity));
    
    Widget glassContainer = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: adaptiveBackgroundColor,
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            border: border ?? Border.all(
              color: isDark 
                  ? Colors.white.withOpacity(0.15) 
                  : Colors.white.withOpacity(0.25),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark 
                    ? Colors.black.withOpacity(0.15) 
                    : Colors.grey.withOpacity(0.08),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    // Si tiene onTap, envolver en GestureDetector
    if (onTap != null) {
      glassContainer = GestureDetector(
        onTap: onTap,
        child: glassContainer,
      );
    }

    // Aplicar margin si está especificado
    if (margin != null) {
      glassContainer = Container(
        margin: margin,
        child: glassContainer,
      );
    }

    return glassContainer;
  }
}

/// Variante de GlassCard optimizada para formularios
class GlassFormCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassFormCard({
    Key? key,
    required this.child,
    this.title,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: padding ?? const EdgeInsets.all(24),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 20),
      borderRadius: BorderRadius.circular(20),
      blurAmount: 15,
      opacity: 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
          ],
          child,
        ],
      ),
    );
  }
}

/// Variante de GlassCard para elementos de navegación
class GlassNavCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isSelected;

  const GlassNavCard({
    Key? key,
    required this.child,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(25),
      blurAmount: 8,
      opacity: isSelected ? 0.3 : 0.1,
      backgroundColor: isSelected 
          ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
          : null,
      border: isSelected 
          ? Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              width: 1.5,
            )
          : null,
      child: child,
    );
  }
}