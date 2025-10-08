import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:logging/logging.dart';
import 'package:breathe/domain/entities/breathing_exercise.dart';
import 'package:breathe/domain/repositories/breathing_exercise_repository.dart';

/// Caso de uso para obtener ejercicios de respiración
/// Permite filtrar por categoría y obtener ejercicios favoritos del usuario
class GetBreathingExercisesUseCase
    extends UseCase<GetBreathingExercisesUseCaseResponse, GetBreathingExercisesUseCaseParams> {
  
  final BreathingExerciseRepository breathingExerciseRepository;
  final Logger _logger;

  /// Constructor del caso de uso
  GetBreathingExercisesUseCase(this.breathingExerciseRepository)
      : _logger = Logger('GetBreathingExercisesUseCase');

  @override
  Future<Stream<GetBreathingExercisesUseCaseResponse>> buildUseCaseStream(
      GetBreathingExercisesUseCaseParams? params) async {
    final StreamController<GetBreathingExercisesUseCaseResponse> controller =
        StreamController();
    
    try {
      _logger.info('Obteniendo ejercicios de respiración...');
      
      List<BreathingExercise> exercises;
      
      // Si se especifica una categoría, filtrar por ella
      if (params?.category != null && params!.category!.isNotEmpty) {
        exercises = await breathingExerciseRepository.getExercisesByCategory(params.category!);
        _logger.info('Obtenidos ${exercises.length} ejercicios de la categoría: ${params.category}');
      } 
      // Si se solicitan favoritos
      else if (params?.userId != null && params!.favoritesOnly) {
        exercises = await breathingExerciseRepository.getFavoriteExercises(params.userId!);
        _logger.info('Obtenidos ${exercises.length} ejercicios favoritos para usuario: ${params.userId}');
      }
      // Obtener todos los ejercicios
      else {
        exercises = await breathingExerciseRepository.getAllExercises();
        _logger.info('Obtenidos ${exercises.length} ejercicios en total');
      }

      // Enviar respuesta exitosa
      controller.add(GetBreathingExercisesUseCaseResponse(exercises));
      _logger.info('Ejercicios obtenidos exitosamente');
      
    } catch (e, stackTrace) {
      _logger.severe('Error al obtener ejercicios de respiración', e, stackTrace);
      controller.addError(e);
    } finally {
      controller.close();
    }
    
    return controller.stream;
  }
}

/// Parámetros de entrada para el caso de uso GetBreathingExercisesUseCase
class GetBreathingExercisesUseCaseParams {
  final String? category; // Categoría opcional para filtrar
  final String? userId; // ID del usuario para obtener favoritos
  final bool favoritesOnly; // Si solo se quieren los favoritos

  GetBreathingExercisesUseCaseParams({
    this.category,
    this.userId,
    this.favoritesOnly = false,
  });
}

/// Respuesta del caso de uso GetBreathingExercisesUseCase
class GetBreathingExercisesUseCaseResponse {
  final List<BreathingExercise> exercises;

  GetBreathingExercisesUseCaseResponse(this.exercises);
}