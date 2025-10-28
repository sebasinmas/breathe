import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Sistema de tema unificado con Shadcn Dark + Glassmorphism
/// Siguiendo estándares Apple y Shadcn UI para consistencia visual
class AppTheme {
  AppTheme._();

  // ===== CONFIGURACIÓN DE TIPOGRAFÍA =====
  
  /// Typography system basado en Inter (Shadcn estándar)
  static TextTheme get _textTheme => GoogleFonts.interTextTheme().copyWith(
    // Display styles
    displayLarge: GoogleFonts.inter(
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: AppColors.foreground,
      height: 1.2,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 28.0,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
      color: AppColors.foreground,
      height: 1.25,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.25,
      color: AppColors.foreground,
      height: 1.3,
    ),
    
    // Headline styles
    headlineLarge: GoogleFonts.inter(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.25,
      color: AppColors.foreground,
      height: 1.35,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: AppColors.foreground,
      height: 1.4,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: AppColors.foreground,
      height: 1.4,
    ),
    
    // Title styles
    titleLarge: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: AppColors.foreground,
      height: 1.5,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: AppColors.foreground,
      height: 1.5,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: AppColors.mutedForeground,
      height: 1.5,
    ),
    
    // Body styles
    bodyLarge: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.foreground,
      height: 1.6,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.foreground,
      height: 1.6,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.mutedForeground,
      height: 1.5,
    ),
    
    // Label styles
    labelLarge: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: AppColors.foreground,
      height: 1.4,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: AppColors.mutedForeground,
      height: 1.4,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 10.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: AppColors.mutedForeground,
      height: 1.4,
    ),
  );

  // ===== CONFIGURACIÓN DE COLORES =====
  
  /// ColorScheme dark con paleta Shadcn
  static ColorScheme get _colorScheme => ColorScheme.dark(
    // Primary colors
    primary: AppColors.primary,
    onPrimary: AppColors.primaryForeground,
    primaryContainer: AppColors.primary.withValues(alpha: .2),
    onPrimaryContainer: AppColors.primaryForeground,
    
    // Secondary colors
    secondary: AppColors.secondary,
    onSecondary: AppColors.secondaryForeground,
    secondaryContainer: AppColors.secondary.withValues(alpha: .2),
    onSecondaryContainer: AppColors.secondaryForeground,
    
    // Tertiary colors
    tertiary: AppColors.accent,
    onTertiary: AppColors.accentForeground,
    tertiaryContainer: AppColors.accent.withValues(alpha: .2),
    onTertiaryContainer: AppColors.accentForeground,
    
    // Background colors
    surfaceContainer: AppColors.background,
    onSurface: AppColors.foreground,
    surface: AppColors.card,
    onSurfaceVariant: AppColors.mutedForeground,
    
    // Error colors
    error: AppColors.destructive,
    onError: AppColors.destructiveForeground,
    errorContainer: AppColors.destructive.withValues(alpha: .2),
    onErrorContainer: AppColors.destructiveForeground,
    
    // Outline colors
    outline: AppColors.border,
    outlineVariant: AppColors.border.withValues(alpha: .5),
    
    // Surface colors
    surfaceTint: AppColors.primary,
    inverseSurface: AppColors.foreground,
    onInverseSurface: AppColors.background,
    inversePrimary: AppColors.primaryForeground,
    
    // Shadow and scrim
    shadow: Colors.black.withValues(alpha: .3),
    scrim: Colors.black.withValues(alpha: .6),

    // Brightness
    brightness: Brightness.dark,
  );

  // ===== CONFIGURACIONES DE COMPONENTES =====
  
  /// AppBar theme con glassmorphism
  static AppBarTheme get _appBarTheme => AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.foreground,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: _textTheme.headlineMedium,
    iconTheme: IconThemeData(
      color: AppColors.foreground,
      size: 24,
    ),
    actionsIconTheme: IconThemeData(
      color: AppColors.foreground,
      size: 24,
    ),
  );
  
  /// Card theme con glassmorphism
  static CardThemeData get _cardTheme => CardThemeData(
    color: Colors.transparent,
    shadowColor: Colors.black.withValues(alpha: .3),
    elevation: 0,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: AppColors.border,
        width: 1,
      ),
    ),
  );
  
  /// ElevatedButton theme
  static ElevatedButtonThemeData get _elevatedButtonTheme => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.primaryForeground,
      disabledBackgroundColor: AppColors.muted,
      disabledForegroundColor: AppColors.mutedForeground,
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      minimumSize: const Size(120, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: _textTheme.labelLarge,
    ),
  );
  
  /// OutlinedButton theme
  static OutlinedButtonThemeData get _outlinedButtonTheme => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.foreground,
      disabledForegroundColor: AppColors.mutedForeground,
      side: BorderSide(color: AppColors.border, width: 1),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      minimumSize: const Size(120, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: _textTheme.labelLarge,
    ),
  );
  
  /// TextButton theme
  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.mutedForeground,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minimumSize: const Size(64, 36),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: _textTheme.labelLarge,
    ),
  );
  
  /// InputDecoration theme
  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.input,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.border, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.border, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.destructive, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.destructive, width: 2),
    ),
    labelStyle: _textTheme.bodyMedium?.copyWith(
      color: AppColors.mutedForeground,
    ),
    hintStyle: _textTheme.bodyMedium?.copyWith(
      color: AppColors.mutedForeground.withValues(alpha: .6),
    ),
    helperStyle: _textTheme.bodySmall,
    errorStyle: _textTheme.bodySmall?.copyWith(
      color: AppColors.destructive,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
  
  /// Floating Action Button theme
  static FloatingActionButtonThemeData get _fabTheme => FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.primaryForeground,
    elevation: 8,
    highlightElevation: 12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );
  
  /// Bottom Navigation Bar theme
  static BottomNavigationBarThemeData get _bottomNavTheme => BottomNavigationBarThemeData(
    backgroundColor: AppColors.card.withValues(alpha: .95),
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.mutedForeground,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
    selectedLabelStyle: _textTheme.labelSmall,
    unselectedLabelStyle: _textTheme.labelSmall,
  );
  
  /// Divider theme
  static DividerThemeData get _dividerTheme => DividerThemeData(
    color: AppColors.border,
    thickness: 1,
    space: 1,
  );

  // ===== TEMA PRINCIPAL =====
  
  /// Tema dark completo con Shadcn + Glassmorphism
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Core theming
    colorScheme: _colorScheme,
    textTheme: _textTheme,
    
    // Background
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: AppColors.card,
    
    // Component themes
    appBarTheme: _appBarTheme,
    cardTheme: _cardTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    inputDecorationTheme: _inputDecorationTheme,
    floatingActionButtonTheme: _fabTheme,
    bottomNavigationBarTheme: _bottomNavTheme,
    dividerTheme: _dividerTheme,
    
    // Visual density
    visualDensity: VisualDensity.adaptivePlatformDensity,
    
    // Platform adaptations
    platform: TargetPlatform.iOS,
  );

  // ===== TEMA LEGACY (PARA MANTENER COMPATIBILIDAD) =====
  
  /// Getter para mantener compatibilidad con código existente
  static ThemeData get lightTheme => darkTheme;

  /// Getters de compatibilidad para colores legacy
  static Color get primaryBlue => AppColors.primary;
  static Color get mintGreen => AppColors.secondary;
  static Color get lightGlass => AppColors.muted;
  static Color get charcoal => AppColors.foreground;
  static Color get darkGlass => AppColors.mutedForeground;
  
  /// Getter de compatibilidad para textTheme
  static TextTheme get textTheme => _textTheme;
}