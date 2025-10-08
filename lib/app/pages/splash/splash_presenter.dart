import 'package:breathe/domain/repositories/user_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

/// Presenter para la pantalla de splash
/// Se encarga de verificar el estado de autenticación del usuario
class SplashPresenter extends Presenter {
  // Funciones de callback para el controlador
  Function? checkAuthOnComplete;
  Function? checkAuthOnError;
  Function? checkAuthOnNext;

  // Repositorio de usuario para verificar autenticación
  final UserRepository _userRepository;

  /// Constructor que recibe el repositorio de usuario
  SplashPresenter(this._userRepository);

  /// Verifica si el usuario está autenticado
  void checkAuthenticationStatus() {
    _userRepository.getCurrentUser().then((user) {
      if (checkAuthOnNext != null) {
        checkAuthOnNext!(user);
      }
      if (checkAuthOnComplete != null) {
        checkAuthOnComplete!();
      }
    }).catchError((error) {
      if (checkAuthOnError != null) {
        checkAuthOnError!(error);
      }
    });
  }

  @override
  void dispose() {
    // Limpiar recursos si es necesario
  }
}