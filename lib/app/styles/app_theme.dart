import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sistema de temas moderno inspirado en iOS con glassmorphism
/// Paleta elegante, relajante y minimalista
class AppTheme {
  // PALETA DE COLORES GLASSMORPHISM INSPIRADA EN iOS
  
  // Colores primarios - Tonos azules relajantes
  static const Color primaryBlue = Color(0xFF007AFF);      // Azul iOS principal
  static const Color lightBlue = Color(0xFF64B5F6);        // Azul claro relajante
  static const Color darkBlue = Color(0xFF1976D2);         // Azul oscuro elegante
  
  // Colores secundarios - Tonos verdes naturales
  static const Color mintGreen = Color(0xFF00C896);        // Verde menta fresco
  static const Color softGreen = Color(0xFF81C784);        // Verde suave
  static const Color deepGreen = Color(0xFF388E3C);        // Verde profundo
  
  // Colores de acento - Tonos cálidos sutiles
  static const Color warmPeach = Color(0xFFFFB74D);        // Durazno cálido
  static const Color softPink = Color(0xFFF8BBD9);         // Rosa suave
  static const Color lavender = Color(0xFFD1C4E9);         // Lavanda relajante
  
  // Grises glassmorphism
  static const Color glassWhite = Color(0xFFF8FAFC);       // Blanco vítreo
  static const Color lightGlass = Color(0xFFF1F5F9);       // Gris muy claro
  static const Color mediumGlass = Color(0xFFE2E8F0);      // Gris medio
  static const Color darkGlass = Color(0xFF64748B);        // Gris oscuro
  static const Color charcoal = Color(0xFF1E293B);         // Carbón elegante
  
  // Colores de superficie con transparencia
  static const Color surfaceLight = Color(0x0DFFFFFF);     // Superficie clara
  static const Color surfaceMedium = Color(0x1AFFFFFF);    // Superficie media
  static const Color surfaceDark = Color(0x26000000);      // Superficie oscura
  
  // Gradientes glassmorphism
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF007AFF),
      Color(0xFF64B5F6),
    ],
  );
  
  static const LinearGradient glassMorphGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1AFFFFFF),
      Color(0x0DFFFFFF),
    ],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF8FAFC),
      Color(0xFFE2E8F0),
    ],
  );

  // TIPOGRAFÍA ELEGANTE
  static TextTheme get textTheme {
    return TextTheme(
      // Headlines - Para títulos principales
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: charcoal,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: charcoal,
        letterSpacing: -0.3,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: charcoal,
        letterSpacing: -0.2,
      ),
      
      // Headlines secundarios
      headlineLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: charcoal,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: charcoal,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: charcoal,
      ),
      
      // Títulos para componentes
      titleLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: charcoal,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: charcoal,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: darkGlass,
      ),
      
      // Texto del cuerpo
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: charcoal,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: darkGlass,
        height: 1.4,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: darkGlass,
        height: 1.3,
      ),
      
      // Labels para botones y elementos pequeños
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: darkGlass,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: darkGlass,
      ),
    );
  }

  // TEMA PRINCIPAL
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Esquema de colores refinado
      colorScheme: const ColorScheme.light(
        // Colores primarios
        primary: primaryBlue,
        onPrimary: Colors.white,
        primaryContainer: lightBlue,
        onPrimaryContainer: charcoal,
        
        // Colores secundarios
        secondary: mintGreen,
        onSecondary: Colors.white,
        secondaryContainer: softGreen,
        onSecondaryContainer: charcoal,
        
        // Colores terciarios
        tertiary: warmPeach,
        onTertiary: charcoal,
        tertiaryContainer: softPink,
        onTertiaryContainer: charcoal,
        
        // Superficies
        surface: glassWhite,
        onSurface: charcoal,
        surfaceVariant: lightGlass,
        onSurfaceVariant: darkGlass,
        
        // Fondo
        background: glassWhite,
        onBackground: charcoal,
        
        // Errores
        error: Color(0xFFEF4444),
        onError: Colors.white,
        errorContainer: Color(0xFFFEF2F2),
        onErrorContainer: Color(0xFFDC2626),
        
        // Contornos
        outline: mediumGlass,
        outlineVariant: Color(0xFFE5E7EB),
        
        // Superficie inversa
        inverseSurface: charcoal,
        onInverseSurface: glassWhite,
        inversePrimary: lightBlue,
        
        // Sombra y scrim
        shadow: Color(0x1A000000),
        scrim: Color(0x80000000),
      ),
      
      // Tipografía
      textTheme: textTheme,
      
      // AppBar con glassmorphism
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: charcoal,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: charcoal,
        ),
        centerTitle: true,
      ),
      
      // Cards con glassmorphism
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white.withOpacity(0.7),
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Botones elegantes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input fields minimalistas
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightGlass,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Dividers sutiles
      dividerTheme: const DividerThemeData(
        color: mediumGlass,
        thickness: 0.5,
        space: 1,
      ),
    );
  }

  // TEMA OSCURO
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      colorScheme: const ColorScheme.dark(
        primary: lightBlue,
        onPrimary: charcoal,
        primaryContainer: darkBlue,
        onPrimaryContainer: Colors.white,
        
        secondary: softGreen,
        onSecondary: charcoal,
        secondaryContainer: deepGreen,
        onSecondaryContainer: Colors.white,
        
        tertiary: warmPeach,
        onTertiary: charcoal,
        tertiaryContainer: softPink,
        onTertiaryContainer: charcoal,
        
        surface: Color(0xFF0F172A),
        onSurface: glassWhite,
        surfaceVariant: Color(0xFF1E293B),
        onSurfaceVariant: lightGlass,
        
        background: Color(0xFF020617),
        onBackground: glassWhite,
        
        error: Color(0xFFEF4444),
        onError: Colors.white,
        
        outline: Color(0xFF334155),
        outlineVariant: Color(0xFF475569),
        
        inverseSurface: glassWhite,
        onInverseSurface: charcoal,
        inversePrimary: primaryBlue,
        
        shadow: Color(0x40000000),
        scrim: Color(0x80000000),
      ),
      
      textTheme: textTheme.apply(
        bodyColor: glassWhite,
        displayColor: glassWhite,
      ),
    );
  }

  // ESPACIADO CONSISTENTE
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // BORDER RADIUS CONSISTENTE
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // ELEVACIONES
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
}