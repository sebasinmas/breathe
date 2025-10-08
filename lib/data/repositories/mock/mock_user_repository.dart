import 'dart:async';

import 'package:breathe/domain/entities/user.dart';
import 'package:breathe/domain/repositories/user_repository.dart';
import 'package:breathe/data/models/user_model.dart';
import 'package:logging/logging.dart';

/// Implementación mock del repositorio de usuarios
/// Simula autenticación y gestión de usuarios para desarrollo
class MockUserRepository implements UserRepository {
  final Logger _logger;

  /// Constructor privado para patrón singleton
  MockUserRepository._internal()
      : _logger = Logger('MockUserRepository');

  /// Instancia singleton del repositorio
  static final MockUserRepository _instance = MockUserRepository._internal();

  /// Factory constructor que devuelve la instancia singleton
  factory MockUserRepository() => _instance;

  /// Usuario actualmente autenticado (simulado)
  UserModel? _currentUser;

  /// Stream controller para cambios en el estado de autenticación
  final StreamController<User?> _authStateController = 
      StreamController<User?>.broadcast();

  /// Lista de usuarios mock registrados
  static final List<UserModel> _mockUsers = [
    UserModel(
      id: 'user1',
      name: 'Juan Pérez',
      email: 'juan@example.com',
      photoUrl: null,
      isAnonymous: false,
      isPremium: false,
      preferences: const UserPreferencesModel(
        language: 'es',
        theme: 'system',
        soundEnabled: true,
        soundVolume: 0.7,
        notificationsEnabled: true,
        defaultBreathingPattern: '4-7-8',
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    UserModel(
      id: 'user2',
      name: 'María García',
      email: 'maria@example.com',
      photoUrl: 'https://example.com/avatar.jpg',
      isAnonymous: false,
      isPremium: true,
      preferences: const UserPreferencesModel(
        language: 'es',
        theme: 'dark',
        soundEnabled: true,
        soundVolume: 0.9,
        notificationsEnabled: false,
        defaultBreathingPattern: 'cuadrada',
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLoginAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
  ];

  @override
  Future<User?> getCurrentUser() async {
    _logger.info('Obteniendo usuario actual');
    
    await Future.delayed(const Duration(milliseconds: 200));
    
    return _currentUser;
  }

  @override
  Future<User> signInWithGoogle() async {
    _logger.info('Iniciando sesión con Google');
    
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Simular login exitoso con Google
    _currentUser = UserModel(
      id: 'google_user_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Usuario Google',
      email: 'usuario@gmail.com',
      photoUrl: 'https://lh3.googleusercontent.com/example',
      isAnonymous: false,
      isPremium: false,
      preferences: UserPreferencesModel.fromEntity(UserPreferences.defaultPreferences),
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
    
    _authStateController.add(_currentUser);
    _logger.info('Login con Google exitoso');
    
    return _currentUser!;
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    _logger.info('Iniciando sesión con email: $email');
    
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Buscar usuario existente
    final existingUser = _mockUsers.firstWhere(
      (user) => user.email == email,
      orElse: () => throw Exception('Usuario no encontrado'),
    );
    
    // En un caso real validaríamos la contraseña
    if (password.length < 6) {
      throw Exception('Contraseña incorrecta');
    }
    
    _currentUser = existingUser.copyWith(
      lastLoginAt: DateTime.now(),
    );
    
    _authStateController.add(_currentUser);
    _logger.info('Login con email exitoso');
    
    return _currentUser!;
  }

  @override
  Future<User> signUpWithEmailAndPassword(String email, String password, String name) async {
    _logger.info('Registrando nuevo usuario: $email');
    
    await Future.delayed(const Duration(milliseconds: 1200));
    
    // Verificar que el email no esté en uso
    final existingUser = _mockUsers.where((user) => user.email == email);
    if (existingUser.isNotEmpty) {
      throw Exception('El email ya está en uso');
    }
    
    // Validar contraseña
    if (password.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }
    
    // Crear nuevo usuario
    final newUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      photoUrl: null,
      isAnonymous: false,
      isPremium: false,
      preferences: UserPreferencesModel.fromEntity(UserPreferences.defaultPreferences),
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
    
    _mockUsers.add(newUser);
    _currentUser = newUser;
    
    _authStateController.add(_currentUser);
    _logger.info('Registro exitoso para: $email');
    
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    _logger.info('Cerrando sesión');
    
    await Future.delayed(const Duration(milliseconds: 300));
    
    _currentUser = null;
    _authStateController.add(null);
    
    _logger.info('Sesión cerrada exitosamente');
  }

  @override
  Future<User> updateUserProfile(User user) async {
    _logger.info('Actualizando perfil del usuario: ${user.id}');
    
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (_currentUser?.id != user.id) {
      throw Exception('Solo puedes actualizar tu propio perfil');
    }
    
    _currentUser = UserModel.fromEntity(user);
    
    // Actualizar en la lista mock
    final index = _mockUsers.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _mockUsers[index] = _currentUser!;
    }
    
    _authStateController.add(_currentUser);
    _logger.info('Perfil actualizado exitosamente');
    
    return _currentUser!;
  }

  @override
  Future<User> updateUserPreferences(String userId, UserPreferences preferences) async {
    _logger.info('Actualizando preferencias del usuario: $userId');
    
    await Future.delayed(const Duration(milliseconds: 600));
    
    if (_currentUser?.id != userId) {
      throw Exception('Solo puedes actualizar tus propias preferencias');
    }
    
    _currentUser = _currentUser!.copyWith(
      preferences: preferences,
      lastLoginAt: DateTime.now(),
    );
    
    _authStateController.add(_currentUser);
    _logger.info('Preferencias actualizadas exitosamente');
    
    return _currentUser!;
  }

  @override
  Future<bool> isPremiumUser(String userId) async {
    _logger.info('Verificando estado premium del usuario: $userId');
    
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (_currentUser?.id == userId) {
      return _currentUser!.isPremium;
    }
    
    final user = _mockUsers.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw Exception('Usuario no encontrado'),
    );
    
    return user.isPremium;
  }

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  Future<void> deleteAccount(String userId) async {
    _logger.info('Eliminando cuenta del usuario: $userId');
    
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (_currentUser?.id != userId) {
      throw Exception('Solo puedes eliminar tu propia cuenta');
    }
    
    _mockUsers.removeWhere((user) => user.id == userId);
    _currentUser = null;
    _authStateController.add(null);
    
    _logger.info('Cuenta eliminada exitosamente');
  }

  /// Método para limpiar recursos (opcional)
  void dispose() {
    _authStateController.close();
  }
}