import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import '../../../domain/entities/user.dart';
import 'login_controller.dart';

/// Presenter para la pantalla de login siguiendo Clean Architecture
/// Maneja la presentación de datos y la navegación
class LoginPresenter extends Presenter {
  late LoginController loginController;
  final Logger _logger = Logger('LoginPresenter');
  
  // Referencias para navegación y mostrar mensajes
  late Function onNavigateToHome;
  late Function(String) onShowError;
  late Function(String) onShowSuccess;
  
  @override
  void dispose() {
    loginController.dispose();
  }
  
  /// Configura las callbacks de la vista
  void setViewCallbacks({
    required Function navigateToHome,
    required Function(String) showError,
    required Function(String) showSuccess,
  }) {
    onNavigateToHome = navigateToHome;
    onShowError = showError;
    onShowSuccess = showSuccess;
  }
  
  /// Maneja el login con email
  void signInWithEmail(String email, String password) {
    // Validaciones básicas
    if (email.isEmpty || password.isEmpty) {
      onShowError('Por favor ingresa email y contraseña');
      return;
    }
    
    if (!_isValidEmail(email)) {
      onShowError('Por favor ingresa un email válido');
      return;
    }
    
    loginController.authenticateWithEmail(email, password);
  }
  
  /// Maneja el login con Google
  void signInWithGoogle() {
    loginController.authenticateWithGoogle();
  }
  
  /// Maneja el registro de usuario
  void registerUser(String name, String email, String password, String confirmPassword) {
    // Validaciones básicas
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      onShowError('Todos los campos son requeridos');
      return;
    }
    
    if (!_isValidEmail(email)) {
      onShowError('Por favor ingresa un email válido');
      return;
    }
    
    if (password.length < 6) {
      onShowError('La contraseña debe tener al menos 6 caracteres');
      return;
    }
    
    if (password != confirmPassword) {
      onShowError('Las contraseñas no coinciden');
      return;
    }
    
    loginController.registerUser(name, email, password);
  }
  
  /// Limpia mensajes de error
  void clearError() {
    loginController.clearError();
  }
  
  /// Callback para autenticación exitosa
  void onAuthenticationSuccess(User user) {
    _logger.info('Presentando resultado exitoso para usuario: ${user.id}');
    
    // Feedback háptico
    HapticFeedback.lightImpact();
    
    // Mensaje de éxito
    String welcomeMessage = user.name != null 
        ? 'Bienvenido/a, ${user.name}!'
        : 'Bienvenido/a!';
    onShowSuccess(welcomeMessage);
    
    // Navegar a home con delay para mostrar el mensaje
    Future.delayed(const Duration(milliseconds: 1500), () {
      onNavigateToHome();
    });
  }
  
  /// Callback para error de autenticación
  void onAuthenticationError(String error) {
    _logger.warning('Presentando error: $error');
    
    // Feedback háptico para error
    HapticFeedback.heavyImpact();
    
    // Mostrar error con mensaje user-friendly
    String userFriendlyError = _getUserFriendlyError(error);
    onShowError(userFriendlyError);
  }
  
  /// Valida formato de email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  /// Convierte errores técnicos en mensajes user-friendly
  String _getUserFriendlyError(String error) {
    if (error.contains('user-not-found')) {
      return 'No existe una cuenta con este email';
    } else if (error.contains('wrong-password')) {
      return 'Contraseña incorrecta';
    } else if (error.contains('email-already-in-use')) {
      return 'Ya existe una cuenta con este email';
    } else if (error.contains('weak-password')) {
      return 'La contraseña es muy débil';
    } else if (error.contains('invalid-email')) {
      return 'El formato del email no es válido';
    } else if (error.contains('network')) {
      return 'Error de conexión. Verifica tu internet';
    } else if (error.contains('too-many-requests')) {
      return 'Demasiados intentos. Inténtalo más tarde';
    } else {
      return error.isEmpty ? 'Error desconocido' : error;
    }
  }
}