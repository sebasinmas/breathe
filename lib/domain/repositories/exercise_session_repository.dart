import 'dart:async';
import 'package:breathe/domain/entities/exercise_session.dart';

/// Repositorio abstracto para manejar sesiones de ejercicios
/// Permite tracking de progreso y estadísticas del usuario
abstract class ExerciseSessionRepository {
  /// Guarda una nueva sesión de ejercicio completada
  Future<ExerciseSession> saveSession(ExerciseSession session);

  /// Obtiene todas las sesiones de un usuario
  Future<List<ExerciseSession>> getUserSessions(String userId);

  /// Obtiene sesiones de un usuario en un rango de fechas
  Future<List<ExerciseSession>> getSessionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Obtiene sesiones de un ejercicio específico
  Future<List<ExerciseSession>> getSessionsByExercise(
    String userId,
    String exerciseId,
  );

  /// Obtiene estadísticas de progreso del usuario
  Future<Map<String, dynamic>> getUserStats(String userId);

  /// Obtiene el total de minutos de meditación del usuario
  Future<double> getTotalMeditationMinutes(String userId);

  /// Obtiene la racha actual de días consecutivos con meditación
  Future<int> getCurrentStreak(String userId);

  /// Elimina una sesión específica
  Future<void> deleteSession(String sessionId);

  /// Elimina todas las sesiones de un usuario
  Future<void> deleteAllUserSessions(String userId);
}