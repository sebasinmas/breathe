import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:logging/logging.dart';
import 'package:breathe/domain/entities/breathing_exercise.dart';
import 'package:breathe/domain/repositories/breathing_exercise_repository.dart';

/// Caso de uso para crear ejercicios de respiración personalizados
/// Permite a los usuarios crear sus propios patrones de respiración
class CreateCustomExerciseUseCase
    extends UseCase<CreateCustomExerciseUseCaseResponse, CreateCustomExerciseUseCaseParams> {
  
  final BreathingExerciseRepository breathingExerciseRepository;
  final Logger _logger;

  /// Constructor del caso de uso
  CreateCustomExerciseUseCase(this.breathingExerciseRepository)
      : _logger = Logger('CreateCustomExerciseUseCase');

  @override
  Future<Stream<CreateCustomExerciseUseCaseResponse>> buildUseCaseStream(
      CreateCustomExerciseUseCaseParams? params) async {
    final StreamController<CreateCustomExerciseUseCaseResponse> controller =
        StreamController();
    
    try {
      // Validar parámetros de entrada
      if (params == null) {
        throw ArgumentError('Los parámetros son requeridos para crear un ejercicio');
      }

      _logger.info('Creando ejercicio personalizado: ${params.name}');
      
      // Validar que los tiempos sean positivos
      if (params.inhaleTime <= 0 || params.exhaleTime <= 0 || params.cycles <= 0) {
        throw ArgumentError('Los tiempos y ciclos deben ser valores positivos');
      }

      // Crear el ejercicio con los datos proporcionados
      final now = DateTime.now();
      final exercise = BreathingExercise(
        id: '', // El repositorio asignará un ID único
        name: params.name,
        description: params.description,
        inhaleTime: params.inhaleTime,
        holdTime: params.holdTime,
        exhaleTime: params.exhaleTime,
        cycles: params.cycles,
        category: 'personalizado',
        isPremium: false, // Los ejercicios personalizados son gratuitos
        createdAt: now,
        updatedAt: now,
      );

      // Guardar el ejercicio usando el repositorio
      final savedExercise = await breathingExerciseRepository.createCustomExercise(exercise);
      
      _logger.info('Ejercicio personalizado creado exitosamente con ID: ${savedExercise.id}');

      // Enviar respuesta exitosa
      controller.add(CreateCustomExerciseUseCaseResponse(savedExercise));
      
    } catch (e, stackTrace) {
      _logger.severe('Error al crear ejercicio personalizado', e, stackTrace);
      controller.addError(e);
    } finally {
      controller.close();
    }
    
    return controller.stream;
  }
}

/// Parámetros de entrada para el caso de uso CreateCustomExerciseUseCase
class CreateCustomExerciseUseCaseParams {
  final String name;
  final String description;
  final int inhaleTime; // Tiempo de inhalación en segundos
  final int holdTime; // Tiempo de retención en segundos
  final int exhaleTime; // Tiempo de exhalación en segundos
  final int cycles; // Número de ciclos

  CreateCustomExerciseUseCaseParams({
    required this.name,
    required this.description,
    required this.inhaleTime,
    required this.holdTime,
    required this.exhaleTime,
    required this.cycles,
  });

  /// Validar que los parámetros sean correctos
  bool get isValid {
    return name.isNotEmpty &&
           description.isNotEmpty &&
           inhaleTime > 0 &&
           holdTime >= 0 &&
           exhaleTime > 0 &&
           cycles > 0;
  }
}

/// Respuesta del caso de uso CreateCustomExerciseUseCase
class CreateCustomExerciseUseCaseResponse {
  final BreathingExercise exercise;

  CreateCustomExerciseUseCaseResponse(this.exercise);
}