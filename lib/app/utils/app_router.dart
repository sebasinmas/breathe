import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/splash/splash_view.dart';
import '../pages/home/home_view.dart';
import '../pages/breathing_exercise/breathing_exercise_view.dart';
import '../pages/settings/settings_view.dart';
import '../pages/login/login_view.dart';

/// Configuración de rutas usando GoRouter para navegación moderna
/// Implementa rutas declarativas con transiciones suaves
class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String breathingExercise = '/breathing-exercise';
  static const String settings = '/settings';

  /// Configuración del router principal
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    routes: [
      // Ruta de splash (inicial)
      GoRoute(
        path: splash,
        name: 'splash',
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const SplashPage(),
          transitionType: _TransitionType.fade,
        ),
      ),

      // Ruta de login
      GoRoute(
        path: login,
        name: 'login',
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const LoginPage(),
          transitionType: _TransitionType.slideUp,
        ),
      ),

      // Ruta de home (pantalla principal)
      GoRoute(
        path: home,
        name: 'home',
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const HomePage(),
          transitionType: _TransitionType.fade,
        ),
      ),

      // Ruta de ejercicio de respiración
      GoRoute(
        path: breathingExercise,
        name: 'breathing-exercise',
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const BreathingExercisePage(),
          transitionType: _TransitionType.slideLeft,
        ),
      ),

      // Ruta de configuración
      GoRoute(
        path: settings,
        name: 'settings',
        pageBuilder: (context, state) => _buildPageWithTransition(
          child: const SettingsPage(),
          transitionType: _TransitionType.slideRight,
        ),
      ),
    ],

    // Manejo de errores de navegación
    errorPageBuilder: (context, state) => _buildPageWithTransition(
      child: _ErrorPage(error: state.error.toString()),
      transitionType: _TransitionType.fade,
    ),

    // Redirección según el estado de la app
    redirect: (context, state) {
      // Aquí puedes agregar lógica de redirección
      // Por ejemplo, verificar si el usuario está autenticado
      return null; // No redirigir por ahora
    },
  );

  /// Construye una página con transición personalizada
  static Page<void> _buildPageWithTransition({
    required Widget child,
    required _TransitionType transitionType,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage<void>(
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _getTransition(
          animation: animation,
          child: child,
          transitionType: transitionType,
        );
      },
    );
  }

  /// Retorna la transición según el tipo especificado
  static Widget _getTransition({
    required Animation<double> animation,
    required Widget child,
    required _TransitionType transitionType,
  }) {
    switch (transitionType) {
      case _TransitionType.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );

      case _TransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        );

      case _TransitionType.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        );

      case _TransitionType.slideRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        );

      case _TransitionType.scale:
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: child,
        );
    }
  }

  /// Métodos de navegación helper
  static void goToSplash(BuildContext context) {
    context.go(splash);
  }

  static void goToLogin(BuildContext context) {
    context.go(login);
  }

  static void goToHome(BuildContext context) {
    context.go(home);
  }

  static void goToBreathingExercise(BuildContext context) {
    context.go(breathingExercise);
  }

  static void goToSettings(BuildContext context) {
    context.go(settings);
  }

  /// Métodos de navegación que mantienen historial
  static void pushBreathingExercise(BuildContext context) {
    context.push(breathingExercise);
  }

  static void pushSettings(BuildContext context) {
    context.push(settings);
  }

  /// Navegar atrás
  static void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      // Si no puede ir atrás, ir al home
      context.go(home);
    }
  }
}

/// Tipos de transición disponibles
enum _TransitionType {
  fade,
  slideUp,
  slideLeft,
  slideRight,
  scale,
}

/// Página de error personalizada
class _ErrorPage extends StatelessWidget {
  final String error;

  const _ErrorPage({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Error de Navegación',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => AppRouter.goToHome(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Ir al Inicio'),
            ),
          ],
        ),
      ),
    );
  }
}