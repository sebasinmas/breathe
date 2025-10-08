import 'package:breathe/domain/entities/breathing_exercise.dart';

/// Modelo de datos para BreathingExercise que extiende la entidad del dominio
/// Agrega funcionalidades de serialización para Firebase/API
class BreathingExerciseModel extends BreathingExercise {
  const BreathingExerciseModel({
    required super.id,
    required super.name,
    required super.description,
    required super.inhaleTime,
    required super.holdTime,
    required super.exhaleTime,
    required super.cycles,
    required super.category,
    required super.isPremium,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Crea un modelo desde un Map (útil para Firebase/JSON)
  factory BreathingExerciseModel.fromJson(Map<String, dynamic> json) {
    return BreathingExerciseModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      inhaleTime: json['inhaleTime'] as int? ?? 4,
      holdTime: json['holdTime'] as int? ?? 0,
      exhaleTime: json['exhaleTime'] as int? ?? 4,
      cycles: json['cycles'] as int? ?? 10,
      category: json['category'] as String? ?? 'básico',
      isPremium: json['isPremium'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  /// Crea un modelo desde una entidad del dominio
  factory BreathingExerciseModel.fromEntity(BreathingExercise entity) {
    return BreathingExerciseModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      inhaleTime: entity.inhaleTime,
      holdTime: entity.holdTime,
      exhaleTime: entity.exhaleTime,
      cycles: entity.cycles,
      category: entity.category,
      isPremium: entity.isPremium,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convierte el modelo a Map (útil para Firebase/JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'inhaleTime': inhaleTime,
      'holdTime': holdTime,
      'exhaleTime': exhaleTime,
      'cycles': cycles,
      'category': category,
      'isPremium': isPremium,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Crea una copia del modelo con valores modificados
  @override
  BreathingExerciseModel copyWith({
    String? id,
    String? name,
    String? description,
    int? inhaleTime,
    int? holdTime,
    int? exhaleTime,
    int? cycles,
    String? category,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BreathingExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      inhaleTime: inhaleTime ?? this.inhaleTime,
      holdTime: holdTime ?? this.holdTime,
      exhaleTime: exhaleTime ?? this.exhaleTime,
      cycles: cycles ?? this.cycles,
      category: category ?? this.category,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}