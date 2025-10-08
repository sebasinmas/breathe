import 'package:flutter/material.dart';
import 'package:breathe/app/pages/splash/splash_view.dart';
import 'package:breathe/app/pages/login/login_view.dart';
import 'package:breathe/app/pages/home/home_view.dart';
import 'package:breathe/app/pages/breathing_exercise/breathing_exercise_view.dart';
import 'package:breathe/app/pages/settings/settings_view.dart';
import 'package:breathe/app/widgets/animations/breathe_transitions.dart';

/// Clase principal de la aplicación
/// Configura el tema, rutas y navegación de la app Breathe
class BreatheApp extends StatefulWidget {
  const BreatheApp({Key? key}) : super(key: key);

  @override
  State<BreatheApp> createState() => _BreatheAppState();
}

class _BreatheAppState extends State<BreatheApp> {
  // Notifier para el tema de la aplicación
  final ValueNotifier<ThemeMode> _themeNotifier = ValueNotifier(ThemeMode.system);

  @override
  void dispose() {
    _themeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'Breathe',
          debugShowCheckedModeBanner: false,
          
          // Configuración de tema
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: themeMode,
          
          // Configuración de rutas con transiciones personalizadas
          initialRoute: '/',
          onGenerateRoute: _generateRoute,
          
          // Manejo de rutas no encontradas
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const NotFoundPage(),
            );
          },
        );
      },
    );
  }

  /// Construye el tema claro de la aplicación con nueva paleta de colores refinada
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Nueva paleta de colores elegante y con buen contraste
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF33658A), // Azul profundo - fondo principal modo claro
        primaryContainer: Color(0xFF55DDE0), // Azul claro - elementos destacados
        secondary: Color(0xFFF6AE2D), // Amarillo - acentos e indicadores
        secondaryContainer: Color(0xFFF26419), // Naranja - botones secundarios
        tertiary: Color(0xFF55DDE0), // Azul claro para variaciones
        tertiaryContainer: Color(0xFFE8F9FA), // Azul muy claro contenedor
        surface: Color(0xFFFAFBFC), // Superficie muy clara
        surfaceVariant: Color(0xFFF0F4F7), // Variante de superficie
        background: Color(0xFFFFFFFF), // Fondo blanco puro
        error: Color(0xFFE53935), // Rojo de error
        onPrimary: Color(0xFFFFFFFF), // Texto sobre primario (blanco)
        onSecondary: Color(0xFF1A1A1A), // Texto sobre secundario (oscuro)
        onTertiary: Color(0xFF1A1A1A), // Texto sobre terciario (oscuro)
        onSurface: Color(0xFF1A1A1A), // Texto sobre superficie (oscuro)
        onSurfaceVariant: Color(0xFF424242), // Texto sobre variante de superficie
        onBackground: Color(0xFF1A1A1A), // Texto sobre fondo (oscuro)
        onError: Color(0xFFFFFFFF), // Texto sobre error (blanco)
        outline: Color(0xFFBDBDBD), // Contorno sutil
        outlineVariant: Color(0xFFE0E0E0), // Variante de contorno
        inverseSurface: Color(0xFF2F4858), // Superficie inversa (azul oscuro)
        onInverseSurface: Color(0xFFF5F5F5), // Texto sobre superficie inversa
        inversePrimary: Color(0xFF55DDE0), // Primario inverso (azul claro)
        scrim: Color(0x80000000), // Scrim con transparencia
      ),
      
      // AppBar theme optimizado para glassmorphism
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      
      // Card theme con glassmorphism
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shadowColor: const Color(0xFF4FC3F7).withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF4FC3F7),
          foregroundColor: Colors.white,
        ),
      ),
      
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(
            color: const Color(0xFF4FC3F7).withOpacity(0.6),
            width: 2,
          ),
          backgroundColor: Colors.white.withOpacity(0.1),
        ),
      ),
      
      // Floating Action Button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 8,
        backgroundColor: const Color(0xFF4FC3F7),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade300.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF4FC3F7),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Typography optimizada para glassmorphism
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.3,
        ),
      ),
    );
  }

  /// Construye el tema oscuro de la aplicación con nueva paleta de colores refinada
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Nueva paleta de colores para tema oscuro con buen contraste
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF55DDE0), // Azul claro - elementos destacados en oscuro
        primaryContainer: Color(0xFF2F4858), // Azul oscuro - fondo principal modo oscuro
        secondary: Color(0xFFF6AE2D), // Amarillo - acentos e indicadores
        secondaryContainer: Color(0xFFF26419), // Naranja - botones secundarios
        tertiary: Color(0xFF33658A), // Azul profundo para variaciones
        tertiaryContainer: Color(0xFF1A2831), // Azul muy oscuro contenedor
        surface: Color(0xFF1A1F23), // Superficie oscura
        surfaceVariant: Color(0xFF232A2E), // Variante de superficie oscura
        background: Color(0xFF0F1419), // Fondo muy oscuro
        error: Color(0xFFEF5350), // Rojo de error claro
        onPrimary: Color(0xFF0F1419), // Texto sobre primario (muy oscuro)
        onSecondary: Color(0xFF0F1419), // Texto sobre secundario (muy oscuro)
        onTertiary: Color(0xFFFFFFFF), // Texto sobre terciario (blanco)
        onSurface: Color(0xFFE8F1F5), // Texto sobre superficie (claro)
        onSurfaceVariant: Color(0xFFB0BEC5), // Texto sobre variante de superficie
        onBackground: Color(0xFFE8F1F5), // Texto sobre fondo (claro)
        onError: Color(0xFF0F1419), // Texto sobre error (oscuro)
        outline: Color(0xFF616161), // Contorno sutil
        outlineVariant: Color(0xFF424242), // Variante de contorno
        inverseSurface: Color(0xFFE8F1F5), // Superficie inversa (claro)
        onInverseSurface: Color(0xFF1A1F23), // Texto sobre superficie inversa
        inversePrimary: Color(0xFF33658A), // Primario inverso (azul profundo)
        scrim: Color(0x80000000), // Scrim con transparencia
      ),
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      
      // Card theme con glassmorphism oscuro
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shadowColor: const Color(0xFF4FC3F7).withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF4FC3F7),
          foregroundColor: Colors.white,
        ),
      ),
      
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(
            color: const Color(0xFF4FC3F7).withOpacity(0.6),
            width: 2,
          ),
          backgroundColor: Colors.white.withOpacity(0.05),
        ),
      ),
      
      // Floating Action Button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 8,
        backgroundColor: const Color(0xFF4FC3F7),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade600.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF4FC3F7),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Typography optimizada para glassmorphism
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.3,
        ),
      ),
    );
  }

  /// Genera rutas personalizadas con transiciones suaves
  Route<dynamic>? _generateRoute(RouteSettings settings) {
    Widget page;
    PageRouteBuilder Function({required Widget child}) transition;

    // Definir la página y tipo de transición según la ruta
    switch (settings.name) {
      case '/':
        page = const SplashPage();
        transition = BreatheTransitions.fadeRoute;
        break;
      case '/login':
        page = const LoginPage();
        transition = BreatheTransitions.slideUpRoute;
        break;
      case '/home':
        page = const HomePage();
        transition = BreatheTransitions.fadeRoute;
        break;
      case '/breathing-exercise':
        page = const BreathingExercisePage();
        transition = BreatheTransitions.slideUpRoute;
        break;
      case '/settings':
        page = const SettingsPage();
        transition = BreatheTransitions.slideUpRoute;
        break;
      default:
        // Ruta no encontrada - usar transición fade
        page = const NotFoundPage();
        transition = BreatheTransitions.fadeRoute;
        break;
    }

    // Retornar la ruta con transición personalizada
    return transition(child: page);
  }

  /// Cambia el tema de la aplicación
  void changeTheme(ThemeMode themeMode) {
    _themeNotifier.value = themeMode;
  }
}

/// Página que se muestra cuando una ruta no es encontrada
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página no encontrada'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.grey.shade400,
            ),
            
            const SizedBox(height: 20),
            
            Text(
              '404',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 10),
            
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            
            const SizedBox(height: 30),
            
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
              },
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extensión para obtener el tema actual de la aplicación
extension BreatheTheme on BuildContext {
  /// Obtiene si el tema actual es oscuro
  bool get isDarkMode {
    return Theme.of(this).brightness == Brightness.dark;
  }
  
  /// Obtiene el color primario del tema
  Color get primaryColor {
    return Theme.of(this).colorScheme.primary;
  }
  
  /// Obtiene el color de superficie del tema
  Color get surfaceColor {
    return Theme.of(this).colorScheme.surface;
  }
  
  /// Obtiene el color de fondo del tema
  Color get backgroundColor {
    return Theme.of(this).colorScheme.background;
  }
}