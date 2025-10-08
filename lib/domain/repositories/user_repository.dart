import 'dart:async';
import 'package:breathe/domain/entities/user.dart';

/// Repositorio abstracto para manejar autenticación y datos de usuario
/// Define las operaciones de authentication y gestión de perfil
abstract class UserRepository {
  /// Obtiene el usuario actualmente autenticado
  Future<User?> getCurrentUser();

  /// Inicia sesión con Google
  Future<User> signInWithGoogle();

  /// Inicia sesión con email y contraseña
  Future<User> signInWithEmailAndPassword(String email, String password);

  /// Registra un nuevo usuario con email y contraseña
  Future<User> signUpWithEmailAndPassword(String email, String password, String name);

  /// Cierra la sesión del usuario actual
  Future<void> signOut();

  /// Actualiza el perfil del usuario
  Future<User> updateUserProfile(User user);

  /// Actualiza las preferencias del usuario
  Future<User> updateUserPreferences(String userId, UserPreferences preferences);

  /// Verifica si el usuario tiene una suscripción premium activa
  Future<bool> isPremiumUser(String userId);

  /// Stream que emite cambios en el estado de autenticación
  Stream<User?> get authStateChanges;

  /// Elimina la cuenta del usuario (solo para pruebas)
  Future<void> deleteAccount(String userId);
}