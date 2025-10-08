import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:logging/logging.dart';
import '../../../domain/usecases/authenticate_user_usecase.dart';
import '../../../domain/entities/user.dart';

/// Controller para la pantalla de login siguiendo Clean Architecture
/// Maneja la lógica de UI y se comunica con los Use Cases
class LoginController extends Controller {
  final AuthenticateUserUseCase _authenticateUserUseCase;
  final Logger _logger = Logger('LoginController');
  
  // Estado del controller
  bool _isLoading = false;
  String? _errorMessage;
  User? _authenticatedUser;
  
  // Getters para el presenter
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get authenticatedUser => _authenticatedUser;
  
  LoginController(this._authenticateUserUseCase);
  
  /// Autentica usuario con email y contraseña
  void authenticateWithEmail(String email, String password) {
    _logger.info('Iniciando autenticación con email: $email');
    
    _setLoadingState(true);
    
    _authenticateUserUseCase.execute(
      _AuthenticateUserObserver(this),
      AuthenticateUserUseCaseParams(
        authType: AuthType.emailPassword,
        email: email,
        password: password,
      ),
    );
  }
  
  /// Autentica usuario con Google
  void authenticateWithGoogle() {
    _logger.info('Iniciando autenticación con Google');
    
    _setLoadingState(true);
    
    _authenticateUserUseCase.execute(
      _AuthenticateUserObserver(this),
      AuthenticateUserUseCaseParams(
        authType: AuthType.google,
      ),
    );
  }
  
  /// Registra nuevo usuario
  void registerUser(String name, String email, String password) {
    _logger.info('Iniciando registro para email: $email');
    
    _setLoadingState(true);
    
    _authenticateUserUseCase.execute(
      _AuthenticateUserObserver(this),
      AuthenticateUserUseCaseParams(
        authType: AuthType.register,
        name: name,
        email: email,
        password: password,
      ),
    );
  }
  
  /// Limpia el estado de error
  void clearError() {
    _errorMessage = null;
    refreshUI();
  }
  
  /// Establece el estado de carga
  void _setLoadingState(bool loading) {
    _isLoading = loading;
    if (loading) {
      _errorMessage = null; // Limpiar errores al iniciar nueva acción
    }
    refreshUI();
  }
  
  /// Callback para autenticación exitosa
  void _onAuthenticationSuccess(User user) {
    _logger.info('Autenticación exitosa para usuario: ${user.id}');
    
    _isLoading = false;
    _errorMessage = null;
    _authenticatedUser = user;
    refreshUI();
  }
  
  /// Callback para error de autenticación
  void _onAuthenticationError(String error) {
    _logger.warning('Error de autenticación: $error');
    
    _isLoading = false;
    _errorMessage = error;
    _authenticatedUser = null;
    refreshUI();
  }
  
  @override
  void initListeners() {
    // No hay listeners específicos en este caso
  }
}

/// Observer para el UseCase de autenticación
class _AuthenticateUserObserver extends Observer<AuthenticateUserUseCaseResponse> {
  final LoginController _controller;
  
  _AuthenticateUserObserver(this._controller);
  
  @override
  void onComplete() {
    // Operación completada
  }
  
  @override
  void onError(e) {
    String errorMessage = 'Error desconocido';
    
    if (e is Exception) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } else if (e is String) {
      errorMessage = e;
    }
    
    _controller._onAuthenticationError(errorMessage);
  }
  
  @override
  void onNext(AuthenticateUserUseCaseResponse? response) {
    if (response?.user != null) {
      _controller._onAuthenticationSuccess(response!.user);
    } else {
      _controller._onAuthenticationError('Usuario no encontrado');
    }
  }
}