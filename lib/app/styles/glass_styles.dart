import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'app_colors.dart';

/// Configuraciones centralizadas para efectos glassmorphism
/// Siguiendo estándares Apple y Shadcn con consistencia visual
class GlassStyles {
  GlassStyles._();

  // ===== CONFIGURACIONES BASE =====
  
  /// Blur amount estándar para diferentes niveles
  static const double blurLow = 10.0;
  static const double blurMedium = 15.0;
  static const double blurHigh = 20.0;
  
  /// Border width estándar
  static const double borderThin = 1.0;
  static const double borderMedium = 1.5;
  static const double borderThick = 2.0;
  
  /// Border radius estándar
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 20.0;
  static const double radiusXLarge = 24.0;
  
  // ===== CONFIGURACIONES GLASSMORPHIC CONTAINERS =====
  
  /// Card glassmorphism básica
  static Widget buildCard({
    required Widget child,
    double? width,
    double? height,
    double borderRadius = radiusMedium,
    double blur = blurMedium,
    double border = borderMedium,
  }) {
    return Container(
      width: width,
      height: height,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: borderRadius,
        blur: blur,
        border: border,
        alignment: Alignment.bottomCenter,
        linearGradient: AppColors.glassGradient,
        borderGradient: AppColors.glassBorderGradient,
        child: child,
      ),
    );
  }
  
  /// Card glassmorphism con acento primary
  static Widget buildPrimaryCard({
    required Widget child,
    double? width,
    double? height,
    double borderRadius = radiusMedium,
    double blur = blurMedium,
    double border = borderMedium,
  }) {
    return Container(
      width: width,
      height: height,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: borderRadius,
        blur: blur,
        border: border,
        alignment: Alignment.bottomCenter,
        linearGradient: AppColors.primaryGlassGradient,
        borderGradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: .6),
            AppColors.primary.withValues(alpha: .2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: child,
      ),
    );
  }
  
  /// Card glassmorphism con acento secondary
  static Widget buildSecondaryCard({
    required Widget child,
    double? width,
    double? height,
    double borderRadius = radiusMedium,
    double blur = blurMedium,
    double border = borderMedium,
  }) {
    return Container(
      width: width,
      height: height,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: borderRadius,
        blur: blur,
        border: border,
        alignment: Alignment.bottomCenter,
        linearGradient: AppColors.secondaryGlassGradient,
        borderGradient: LinearGradient(
          colors: [
            AppColors.secondary.withValues(alpha: .6),
            AppColors.secondary.withValues(alpha: .2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: child,
      ),
    );
  }
  
  /// Panel glassmorphism para contenido principal
  static GlassmorphicContainer buildPanel({
    required Widget child,
    double? width,
    double? height,
    double borderRadius = radiusLarge,
    double blur = blurHigh,
    double border = borderThin,
  }) {
    return GlassmorphicContainer(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      borderRadius: borderRadius,
      blur: blur,
      border: border,
      alignment: Alignment.bottomCenter,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withValues(alpha: .15),
          Colors.white.withValues(alpha: .03),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.white.withValues(alpha: .3),
          Colors.white.withValues(alpha: .05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: child,
    );
  }
  
  /// Botón glassmorphism
  static GlassmorphicContainer buildButton({
    required Widget child,
    double? width,
    double? height,
    double borderRadius = radiusSmall,
    double blur = blurLow,
    double border = borderMedium,
    bool isPrimary = false,
  }) {
    return GlassmorphicContainer(
      width: width ?? 120,
      height: height ?? 48,
      borderRadius: borderRadius,
      blur: blur,
      border: border,
      alignment: Alignment.bottomCenter,
      linearGradient: isPrimary 
          ? AppColors.primaryGlassGradient
          : AppColors.glassGradient,
      borderGradient: isPrimary
          ? LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.8),
                AppColors.primary.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : AppColors.glassBorderGradient,
      child: child,
    );
  }
  
  // ===== DECORACIONES COMPLEMENTARIAS =====
  
  /// Decoración para Container con glassmorphism manual
  static BoxDecoration cardDecoration({
    double borderRadius = radiusMedium,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      gradient: AppColors.glassGradient,
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: borderMedium,
      ),
      boxShadow: shadows ?? AppColors.glassElevation2,
    );
  }
  
  /// Decoración con acento primary
  static BoxDecoration primaryDecoration({
    double borderRadius = radiusMedium,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      gradient: AppColors.primaryGlassGradient,
      border: Border.all(
        color: AppColors.primary.withOpacity(0.4),
        width: borderMedium,
      ),
      boxShadow: shadows ?? AppColors.primaryGlow,
    );
  }
  
  /// Decoración con acento secondary
  static BoxDecoration secondaryDecoration({
    double borderRadius = radiusMedium,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      gradient: AppColors.secondaryGlassGradient,
      border: Border.all(
        color: AppColors.secondary.withOpacity(0.4),
        width: borderMedium,
      ),
      boxShadow: shadows ?? AppColors.secondaryGlow,
    );
  }
}