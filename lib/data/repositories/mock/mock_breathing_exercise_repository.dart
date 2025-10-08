import 'dart:async';

import 'package:breathe/domain/entities/breathing_exercise.dart';
import 'package:breathe/domain/repositories/breathing_exercise_repository.dart';
import 'package:breathe/data/models/breathing_exercise_model.dart';
import 'package:logging/logging.dart';

/// Implementación mock del repositorio de ejercicios de respiración
/// Utiliza datos estáticos para desarrollo y testing
class MockBreathingExerciseRepository implements BreathingExerciseRepository {
  final Logger _logger;

  /// Constructor privado para patrón singleton
  MockBreathingExerciseRepository._internal()
      : _logger = Logger('MockBreathingExerciseRepository');

  /// Instancia singleton del repositorio
  static final MockBreathingExerciseRepository _instance =
      MockBreathingExerciseRepository._internal();

  /// Factory constructor que devuelve la instancia singleton
  factory MockBreathingExerciseRepository() => _instance;

  /// Lista de ejercicios mock con datos predefinidos
  static final List<BreathingExerciseModel> _mockExercises = [
    // Ejercicios básicos
    BreathingExerciseModel(
      id: '1',
      name: 'Respiración 4-7-8',
      description: 'Técnica de relajación profunda. Inhala 4 segundos, mantén 7, exhala 8.',
      inhaleTime: 4,
      holdTime: 7,
      exhaleTime: 8,
      cycles: 8,
      category: 'básico',
      isPremium: false,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    BreathingExerciseModel(
      id: '2',
      name: 'Respiración Cuadrada',
      description: 'Técnica equilibrada para reducir estrés. Todos los tiempos son iguales.',
      inhaleTime: 4,
      holdTime: 4,
      exhaleTime: 4,
      cycles: 10,
      category: 'básico',
      isPremium: false,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      updatedAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
    BreathingExerciseModel(
      id: '3',
      name: 'Respiración Triángulo',
      description: 'Patrón simple sin retención. Ideal para principiantes.',
      inhaleTime: 6,
      holdTime: 0,
      exhaleTime: 6,
      cycles: 12,
      category: 'básico',
      isPremium: false,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    // Ejercicios avanzados
    BreathingExerciseModel(
      id: '4',
      name: 'Wim Hof Básico',
      description: 'Respiración energizante. 30 respiraciones rápidas seguidas de retención.',
      inhaleTime: 2,
      holdTime: 0,
      exhaleTime: 2,
      cycles: 30,
      category: 'avanzado',
      isPremium: true,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    BreathingExerciseModel(
      id: '5',
      name: 'Pranayama Extendido',
      description: 'Técnica avanzada de yoga con retenciones prolongadas.',
      inhaleTime: 8,
      holdTime: 12,
      exhaleTime: 8,
      cycles: 6,
      category: 'avanzado',
      isPremium: true,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  /// Lista de ejercicios favoritos por usuario (simulado)
  static final Map<String, List<String>> _userFavorites = {
    'user1': ['1', '2'],
    'user2': ['1', '3', '4'],
  };

  /// Contador para generar IDs únicos
  static int _nextId = 6;

  @override
  Future<List<BreathingExercise>> getAllExercises() async {
    _logger.info('Obteniendo todos los ejercicios mock');
    
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    
    return List<BreathingExercise>.from(_mockExercises);
  }

  @override
  Future<List<BreathingExercise>> getExercisesByCategory(String category) async {
    _logger.info('Obteniendo ejercicios de la categoría: $category');
    
    await Future.delayed(const Duration(milliseconds: 300));
    
    final filteredExercises = _mockExercises
        .where((exercise) => exercise.category.toLowerCase() == category.toLowerCase())
        .toList();
    
    return List<BreathingExercise>.from(filteredExercises);
  }

  @override
  Future<BreathingExercise?> getExerciseById(String id) async {
    _logger.info('Obteniendo ejercicio con ID: $id');
    
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      return _mockExercises.firstWhere((exercise) => exercise.id == id);
    } catch (e) {
      _logger.warning('Ejercicio con ID $id no encontrado');
      return null;
    }
  }

  @override
  Future<BreathingExercise> createCustomExercise(BreathingExercise exercise) async {
    _logger.info('Creando ejercicio personalizado: ${exercise.name}');
    
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Crear un nuevo ejercicio con ID único
    final newExercise = BreathingExerciseModel(
      id: _nextId.toString(),
      name: exercise.name,
      description: exercise.description,
      inhaleTime: exercise.inhaleTime,
      holdTime: exercise.holdTime,
      exhaleTime: exercise.exhaleTime,
      cycles: exercise.cycles,
      category: 'personalizado',
      isPremium: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _mockExercises.add(newExercise);
    _nextId++;
    
    _logger.info('Ejercicio personalizado creado con ID: ${newExercise.id}');
    return newExercise;
  }

  @override
  Future<BreathingExercise> updateExercise(BreathingExercise exercise) async {
    _logger.info('Actualizando ejercicio: ${exercise.id}');
    
    await Future.delayed(const Duration(milliseconds: 600));
    
    final index = _mockExercises.indexWhere((e) => e.id == exercise.id);
    if (index == -1) {
      throw Exception('Ejercicio no encontrado para actualizar');
    }
    
    final updatedExercise = BreathingExerciseModel.fromEntity(exercise).copyWith(
      updatedAt: DateTime.now(),
    );
    
    _mockExercises[index] = updatedExercise;
    return updatedExercise;
  }

  @override
  Future<void> deleteExercise(String id) async {
    _logger.info('Eliminando ejercicio: $id');
    
    await Future.delayed(const Duration(milliseconds: 400));
    
    final exercise = _mockExercises.firstWhere(
      (e) => e.id == id,
      orElse: () => throw Exception('Ejercicio no encontrado para eliminar'),
    );
    
    if (exercise.category != 'personalizado') {
      throw Exception('Solo se pueden eliminar ejercicios personalizados');
    }
    
    _mockExercises.removeWhere((e) => e.id == id);
    
    // Remover de favoritos también
    _userFavorites.forEach((userId, favorites) {
      favorites.remove(id);
    });
  }

  @override
  Future<List<BreathingExercise>> getFavoriteExercises(String userId) async {
    _logger.info('Obteniendo ejercicios favoritos para usuario: $userId');
    
    await Future.delayed(const Duration(milliseconds: 300));
    
    final favoriteIds = _userFavorites[userId] ?? [];
    final favoriteExercises = _mockExercises
        .where((exercise) => favoriteIds.contains(exercise.id))
        .toList();
    
    return List<BreathingExercise>.from(favoriteExercises);
  }

  @override
  Future<void> toggleFavorite(String userId, String exerciseId) async {
    _logger.info('Cambiando estado de favorito para usuario $userId, ejercicio $exerciseId');
    
    await Future.delayed(const Duration(milliseconds: 200));
    
    _userFavorites.putIfAbsent(userId, () => <String>[]);
    
    final favorites = _userFavorites[userId]!;
    if (favorites.contains(exerciseId)) {
      favorites.remove(exerciseId);
      _logger.info('Ejercicio removido de favoritos');
    } else {
      favorites.add(exerciseId);
      _logger.info('Ejercicio agregado a favoritos');
    }
  }
}