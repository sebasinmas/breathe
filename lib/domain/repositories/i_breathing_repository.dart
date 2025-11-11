import '../entities/breathing_exercise.dart';

/// Interfaz del repositorio de ejercicios de respiración
/// 
/// Define el contrato para acceder a los datos de ejercicios de respiración.
/// Las implementaciones concretas pueden obtener datos de diferentes fuentes
/// (local, remoto, caché, etc.)
abstract class IBreathingRepository {
  /// Obtiene la lista de ejercicios de respiración disponibles
  /// 
  /// Retorna un [Future] que completa con una lista de [BreathingExercise].
  /// Puede lanzar excepciones en caso de error al obtener los datos.
  Future<List<BreathingExercise>> getExercises();
}
