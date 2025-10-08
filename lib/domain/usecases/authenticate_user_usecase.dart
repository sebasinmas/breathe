import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:logging/logging.dart';
import 'package:breathe/domain/entities/user.dart';
import 'package:breathe/domain/repositories/user_repository.dart';

/// Caso de uso para autenticación de usuarios
/// Maneja login con Google, email/password y registro de nuevos usuarios
class AuthenticateUserUseCase
    extends UseCase<AuthenticateUserUseCaseResponse, AuthenticateUserUseCaseParams> {
  
  final UserRepository userRepository;
  final Logger _logger;

  /// Constructor del caso de uso
  AuthenticateUserUseCase(this.userRepository)
      : _logger = Logger('AuthenticateUserUseCase');

  @override
  Future<Stream<AuthenticateUserUseCaseResponse>> buildUseCaseStream(
      AuthenticateUserUseCaseParams? params) async {
    final StreamController<AuthenticateUserUseCaseResponse> controller =
        StreamController();
    
    try {
      if (params == null) {
        throw ArgumentError('Los parámetros de autenticación son requeridos');
      }

      _logger.info('Iniciando autenticación de tipo: ${params.authType}');
      
      User user;
      
      switch (params.authType) {
        case AuthType.google:
          user = await userRepository.signInWithGoogle();
          _logger.info('Autenticación con Google exitosa');
          break;
          
        case AuthType.emailPassword:
          if (params.email == null || params.password == null) {
            throw ArgumentError('Email y contraseña son requeridos para este tipo de autenticación');
          }
          user = await userRepository.signInWithEmailAndPassword(params.email!, params.password!);
          _logger.info('Autenticación con email exitosa para: ${params.email}');
          break;
          
        case AuthType.register:
          if (params.email == null || params.password == null || params.name == null) {
            throw ArgumentError('Email, contraseña y nombre son requeridos para registro');
          }
          user = await userRepository.signUpWithEmailAndPassword(
            params.email!, 
            params.password!, 
            params.name!
          );
          _logger.info('Registro exitoso para: ${params.email}');
          break;
      }

      // Enviar respuesta exitosa
      controller.add(AuthenticateUserUseCaseResponse(user));
      
    } catch (e, stackTrace) {
      _logger.severe('Error en autenticación', e, stackTrace);
      controller.addError(e);
    } finally {
      controller.close();
    }
    
    return controller.stream;
  }
}

/// Tipos de autenticación disponibles
enum AuthType {
  google,
  emailPassword,
  register,
}

/// Parámetros de entrada para el caso de uso AuthenticateUserUseCase
class AuthenticateUserUseCaseParams {
  final AuthType authType;
  final String? email;
  final String? password;
  final String? name; // Requerido solo para registro

  AuthenticateUserUseCaseParams({
    required this.authType,
    this.email,
    this.password,
    this.name,
  });
}

/// Respuesta del caso de uso AuthenticateUserUseCase
class AuthenticateUserUseCaseResponse {
  final User user;

  AuthenticateUserUseCaseResponse(this.user);
}