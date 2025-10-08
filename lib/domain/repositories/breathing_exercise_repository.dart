import 'dart:async';
import 'package:breathe/domain/entities/breathing_exercise.dart';

/// Repositorio abstracto para manejar ejercicios de respiración
/// Define las operaciones que se pueden realizar con los ejercicios
abstract class BreathingExerciseRepository {
  /// Obtiene todos los ejercicios de respiración disponibles
  Future<List<BreathingExercise>> getAllExercises();

  /// Obtiene ejercicios por categoría (básico, avanzado, personalizado)
  Future<List<BreathingExercise>> getExercisesByCategory(String category);

  /// Obtiene un ejercicio específico por su ID
  Future<BreathingExercise?> getExerciseById(String id);

  /// Crea un nuevo ejercicio personalizado
  Future<BreathingExercise> createCustomExercise(BreathingExercise exercise);

  /// Actualiza un ejercicio existente
  Future<BreathingExercise> updateExercise(BreathingExercise exercise);

  /// Elimina un ejercicio (solo ejercicios personalizados)
  Future<void> deleteExercise(String id);

  /// Obtiene ejercicios favoritos del usuario
  Future<List<BreathingExercise>> getFavoriteExercises(String userId);

  /// Marca/desmarca un ejercicio como favorito
  Future<void> toggleFavorite(String userId, String exerciseId);
}