import 'package:flutter/material.dart';

/// Sistema de colores Shadcn-inspired para modo oscuro
/// Paleta centralizada con acentos morado e índigo brillante
class AppColors {
  AppColors._();

  // ===== PALETA PRINCIPAL SHADCN DARK =====
  
  /// Colores de fondo principales
  static const Color background = Color(0xFF0F0F10);        // Fondo principal ultra oscuro
  static const Color foreground = Color(0xFFEAEAEA);        // Texto principal
  
  /// Colores de superficie tipo card
  static const Color card = Color(0xFF1A1A1B);              // Superficie de cards
  static const Color cardForeground = Color(0xFFEAEAEA);    // Texto en cards
  
  /// Colores popover/modal
  static const Color popover = Color(0xFF262627);           // Fondo popover
  static const Color popoverForeground = Color(0xFFEAEAEA); // Texto popover
  
  /// Colores primarios
  static const Color primary = Color(0xFF8B5CF6);           // Purple accent principal
  static const Color primaryForeground = Color(0xFFFFFFFF); // Texto en primary
  
  /// Colores secundarios
  static const Color secondary = Color(0xFF6366F1);         // Indigo accent
  static const Color secondaryForeground = Color(0xFFFFFFFF); // Texto en secondary
  
  /// Colores muted (desactivado)
  static const Color muted = Color(0xFF262627);             // Fondo muted
  static const Color mutedForeground = Color(0xFF737373);   // Texto muted
  
  /// Colores de acento
  static const Color accent = Color(0xFF3B82F6);            // Azul acento
  static const Color accentForeground = Color(0xFFFFFFFF);  // Texto en accent
  
  /// Colores destructivos
  static const Color destructive = Color(0xFFF87171);       // Rojo error/destructivo
  static const Color destructiveForeground = Color(0xFFFFFFFF); // Texto destructivo
  
  /// Colores de borde
  static const Color border = Color(0xFF333334);            // Borde principal
  static const Color input = Color(0xFF262627);             // Fondo de inputs
  static const Color ring = Color(0xFF8B5CF6);              // Color del focus ring
  
  // ===== COLORES LEGACY PARA COMPATIBILIDAD =====
  static const Color backgroundSecondary = Color(0xFF1A1A1B); // Fondo secundario
  static const Color backgroundTertiary = Color(0xFF262627);  // Fondo terciario
  static const Color surface = Color(0xFF1A1A1B);           // Superficie principal
  static const Color surfaceElevated = Color(0xFF262627);   // Superficie elevada
  static const Color surfaceHighest = Color(0xFF333334);    // Superficie más alta
  static const Color textPrimary = Color(0xFFEAEAEA);       // Texto principal
  static const Color textSecondary = Color(0xFFB4B4B4);     // Texto secundario
  static const Color textTertiary = Color(0xFF737373);      // Texto terciario
  static const Color textMuted = Color(0xFF525252);         // Texto desactivado
  static const Color primaryLight = Color(0xFFA78BFA);      // Purple claro
  static const Color primaryDark = Color(0xFF7C3AED);       // Purple oscuro
  static const Color secondaryLight = Color(0xFF818CF8);    // Indigo claro
  static const Color secondaryDark = Color(0xFF4F46E5);     // Indigo oscuro
  static const Color success = Color(0xFF10B981);           // Verde éxito
  static const Color warning = Color(0xFFF59E0B);           // Amarillo alerta
  static const Color error = Color(0xFFF87171);             // Rojo error
  static const Color info = Color(0xFF3B82F6);              // Azul información
  static const Color borderSecondary = Color(0xFF404040);   // Borde secundario
  static const Color borderHighlight = Color(0xFF525252);   // Borde destacado
  
  // ===== GLASSMORPHISM ESPECÍFICO =====
  
  /// Gradientes para glassmorphism
  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x33FFFFFF), // 20% opacidad
      Color(0x0DFFFFFF), // 5% opacidad
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient glassBorderGradient = LinearGradient(
    colors: [
      Color(0x66FFFFFF), // 40% opacidad
      Color(0x1AFFFFFF), // 10% opacidad
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Gradientes de acento para elementos especiales
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Gradientes glassmorphism con tinte de color
  static const LinearGradient primaryGlassGradient = LinearGradient(
    colors: [
      Color(0x33A78BFA), // Primary light con 20% opacidad
      Color(0x0D8B5CF6), // Primary con 5% opacidad
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGlassGradient = LinearGradient(
    colors: [
      Color(0x33818CF8), // Secondary light con 20% opacidad
      Color(0x0D6366F1), // Secondary con 5% opacidad
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ===== SOMBRAS =====
  
  /// Sombras para glassmorphism
  static const List<BoxShadow> glassElevation1 = [
    BoxShadow(
      color: Color(0x1A000000), // 10% negro
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];
  
  static const List<BoxShadow> glassElevation2 = [
    BoxShadow(
      color: Color(0x26000000), // 15% negro
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];
  
  static const List<BoxShadow> glassElevation3 = [
    BoxShadow(
      color: Color(0x33000000), // 20% negro
      blurRadius: 30,
      offset: Offset(0, 12),
    ),
  ];
  
  /// Sombras con glow para acentos
  static const List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: Color(0x4D8B5CF6), // Primary con 30% opacidad
      blurRadius: 20,
      offset: Offset(0, 0),
    ),
  ];
  
  static const List<BoxShadow> secondaryGlow = [
    BoxShadow(
      color: Color(0x4D6366F1), // Secondary con 30% opacidad
      blurRadius: 20,
      offset: Offset(0, 0),
    ),
  ];
}