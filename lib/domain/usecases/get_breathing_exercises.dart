import '../entities/breathing_exercise.dart';
import '../repositories/i_breathing_repository.dart';

/// Caso de uso para obtener los ejercicios de respiración
/// 
/// Siguiendo Clean Architecture, este UseCase encapsula la lógica de negocio
/// para obtener la lista de ejercicios disponibles.
/// Depende de la abstracción [IBreathingRepository] para acceder a los datos.
class GetBreathingExercises {
  final IBreathingRepository _repository;

  const GetBreathingExercises(this._repository);

  /// Ejecuta el caso de uso
  /// 
  /// Obtiene la lista de ejercicios de respiración disponibles
  /// a través del repositorio.
  /// 
  /// Retorna un [Future] que completa con una lista de [BreathingExercise].
  /// Puede lanzar excepciones propagadas desde el repositorio.
  Future<List<BreathingExercise>> call() async {
    return await _repository.getExercises();
  }
}
