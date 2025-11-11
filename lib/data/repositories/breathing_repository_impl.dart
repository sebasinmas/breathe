import '../../domain/entities/breathing_exercise.dart';
import '../../domain/entities/breathing_step_type.dart';
import '../../domain/repositories/i_breathing_repository.dart';
import '../models/breathing_exercise_model.dart';
import '../models/breathing_step_model.dart';

/// Implementación del repositorio de ejercicios de respiración con datos hardcodeados
/// 
/// Esta implementación devuelve una lista predefinida de ejercicios
/// sin necesidad de acceso a base de datos o APIs externas.
class BreathingRepositoryImpl implements IBreathingRepository {
  @override
  Future<List<BreathingExercise>> getExercises() async {
    // Simulamos un pequeño delay como si estuviéramos accediendo a una BD
    await Future.delayed(const Duration(milliseconds: 300));

    final List<BreathingExerciseModel> exercises = [
      // Respiración Cuadrada (Box Breathing)
      const BreathingExerciseModel(
        id: 'box-breathing',
        name: 'Respiración Cuadrada',
        description:
            'También conocida como Box Breathing, esta técnica es utilizada por Navy SEALs '
            'para mantener la calma bajo presión. Ayuda a reducir el estrés, mejorar la '
            'concentración y controlar la respuesta del sistema nervioso.',
        steps: [
          BreathingStepModel(
            type: BreathingStepType.inhale,
            duration: Duration(seconds: 4),
            instructionalText: 'Inhala profundamente por la nariz durante 4 segundos...',
          ),
          BreathingStepModel(
            type: BreathingStepType.hold,
            duration: Duration(seconds: 4),
            instructionalText: 'Mantén el aire en tus pulmones por 4 segundos...',
          ),
          BreathingStepModel(
            type: BreathingStepType.exhale,
            duration: Duration(seconds: 4),
            instructionalText: 'Exhala lentamente por la boca durante 4 segundos...',
          ),
          BreathingStepModel(
            type: BreathingStepType.holdOut,
            duration: Duration(seconds: 4),
            instructionalText: 'Mantén los pulmones vacíos por 4 segundos...',
          ),
        ],
      ),

      // Técnica 4-7-8
      const BreathingExerciseModel(
        id: '4-7-8-technique',
        name: 'Técnica 4-7-8',
        description:
            'Desarrollada por el Dr. Andrew Weil, esta técnica es conocida como '
            '"tranquilizante natural del sistema nervioso". Excelente para reducir '
            'la ansiedad, facilitar el sueño y gestionar los antojos o impulsos.',
        steps: [
          BreathingStepModel(
            type: BreathingStepType.inhale,
            duration: Duration(seconds: 4),
            instructionalText: 'Inhala silenciosamente por la nariz contando hasta 4...',
          ),
          BreathingStepModel(
            type: BreathingStepType.hold,
            duration: Duration(seconds: 7),
            instructionalText: 'Retén la respiración contando hasta 7...',
          ),
          BreathingStepModel(
            type: BreathingStepType.exhale,
            duration: Duration(seconds: 8),
            instructionalText: 'Exhala completamente por la boca con un sonido "whoosh" durante 8 segundos...',
          ),
        ],
      ),

      // Respiración Triangular
      const BreathingExerciseModel(
        id: 'triangle-breathing',
        name: 'Respiración Triangular',
        description:
            'Una técnica simple y efectiva que utiliza tres fases iguales. '
            'Ideal para principiantes, ayuda a establecer un ritmo respiratorio '
            'calmante y mejorar la conciencia corporal.',
        steps: [
          BreathingStepModel(
            type: BreathingStepType.inhale,
            duration: Duration(seconds: 5),
            instructionalText: 'Inhala profundamente contando hasta 5...',
          ),
          BreathingStepModel(
            type: BreathingStepType.hold,
            duration: Duration(seconds: 5),
            instructionalText: 'Sostén suavemente por 5 segundos...',
          ),
          BreathingStepModel(
            type: BreathingStepType.exhale,
            duration: Duration(seconds: 5),
            instructionalText: 'Exhala completamente durante 5 segundos...',
          ),
        ],
      ),

      // Respiración de Coherencia Cardíaca
      const BreathingExerciseModel(
        id: 'cardiac-coherence',
        name: 'Coherencia Cardíaca',
        description:
            'También conocida como respiración de resonancia. Esta técnica de 6 respiraciones '
            'por minuto optimiza la variabilidad del ritmo cardíaco, reduciendo el estrés '
            'y mejorando el bienestar emocional.',
        steps: [
          BreathingStepModel(
            type: BreathingStepType.inhale,
            duration: Duration(seconds: 5),
            instructionalText: 'Inhala suavemente durante 5 segundos...',
          ),
          BreathingStepModel(
            type: BreathingStepType.exhale,
            duration: Duration(seconds: 5),
            instructionalText: 'Exhala suavemente durante 5 segundos...',
          ),
        ],
      ),

      // Respiración Energizante (Bhastrika modificada)
      const BreathingExerciseModel(
        id: 'energizing-breath',
        name: 'Respiración Energizante',
        description:
            'Adaptación suave de la técnica de yoga Bhastrika. Aumenta la energía, '
            'despeja la mente y mejora el estado de alerta. Ideal para comenzar el día '
            'o superar la fatiga de la tarde.',
        steps: [
          BreathingStepModel(
            type: BreathingStepType.inhale,
            duration: Duration(seconds: 2),
            instructionalText: 'Inhalación rápida y vigorosa por la nariz...',
          ),
          BreathingStepModel(
            type: BreathingStepType.exhale,
            duration: Duration(seconds: 2),
            instructionalText: 'Exhalación rápida y forzada por la nariz...',
          ),
          BreathingStepModel(
            type: BreathingStepType.inhale,
            duration: Duration(seconds: 2),
            instructionalText: 'Inhalación rápida y vigorosa...',
          ),
          BreathingStepModel(
            type: BreathingStepType.exhale,
            duration: Duration(seconds: 2),
            instructionalText: 'Exhalación rápida y forzada...',
          ),
          BreathingStepModel(
            type: BreathingStepType.hold,
            duration: Duration(seconds: 3),
            instructionalText: 'Pausa breve para estabilizar...',
          ),
        ],
      ),

      // Respiración 5-5-5 (Para Dormir)
      const BreathingExerciseModel(
        id: 'sleep-breathing',
        name: 'Respiración para Dormir',
        description:
            'Una técnica suave y relajante diseñada para preparar el cuerpo y la mente '
            'para el sueño. El ritmo lento activa el sistema nervioso parasimpático, '
            'promoviendo la relajación profunda.',
        steps: [
          BreathingStepModel(
            type: BreathingStepType.inhale,
            duration: Duration(seconds: 5),
            instructionalText: 'Inhala lenta y profundamente...',
          ),
          BreathingStepModel(
            type: BreathingStepType.hold,
            duration: Duration(seconds: 5),
            instructionalText: 'Sostén suavemente sin tensión...',
          ),
          BreathingStepModel(
            type: BreathingStepType.exhale,
            duration: Duration(seconds: 5),
            instructionalText: 'Exhala completamente, liberando toda tensión...',
          ),
        ],
      ),
    ];

    // Convertimos los modelos a entidades puras del dominio
    return exercises.map((model) => model.toEntity()).toList();
  }
}
