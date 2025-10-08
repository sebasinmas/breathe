import 'package:breathe/domain/entities/user.dart';
import 'package:breathe/app/pages/splash/splash_presenter.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

/// Controller para la pantalla de splash
/// Maneja la lógica de navegación inicial de la aplicación
class SplashController extends Controller {
  final SplashPresenter _presenter;

  /// Constructor que inicializa el presenter
  SplashController(userRepository) : _presenter = SplashPresenter(userRepository) {
    _initListeners();
  }

  /// Inicializa los listeners del presenter
  void _initListeners() {
    _presenter.checkAuthOnNext = (User? user) {
      // Usuario encontrado, navegar a home
      if (user != null) {
        navigateToHome();
      } else {
        // Usuario no autenticado, navegar a login
        navigateToLogin();
      }
    };

    _presenter.checkAuthOnError = (error) {
      // Error al verificar autenticación, ir a login
      print('Error checking auth: $error');
      navigateToLogin();
    };

    _presenter.checkAuthOnComplete = () {
      // Completado
    };
  }

  /// Verifica el estado de autenticación
  void checkAuthentication() {
    _presenter.checkAuthenticationStatus();
  }

  /// Navega a la pantalla de home
  void navigateToHome() {
    // En un caso real usaríamos el router
    print('Navegando a Home');
    // Navigator.pushReplacementNamed(getContext(), '/home');
  }

  /// Navega a la pantalla de login
  void navigateToLogin() {
    // En un caso real usaríamos el router
    print('Navegando a Login');
    // Navigator.pushReplacementNamed(getContext(), '/login');
  }

  @override
  void initListeners() {
    // Ya inicializado en el constructor
  }

  /// Limpia los recursos cuando el controller se destruye
  void cleanUp() {
    _presenter.dispose();
  }
}