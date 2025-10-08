import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

/// Presenter para la pantalla principal (Home) siguiendo Clean Architecture
/// Maneja la lógica de presentación y la comunicación con la vista
class HomePresenter extends Presenter {
  final Logger _logger = Logger('HomePresenter');
  
  // Referencias para la vista
  late Function onNavigateToBreathingExerciseView;
  late Function onNavigateToMindfulnessView;
  late Function onNavigateToEmotionalIntelligenceView;
  late Function onNavigateToNotificationsView;
  late Function onNavigateToSettingsView;
  late Function(String) onShowError;
  late Function(String) onShowSuccess;
  late Function(int) onSectionChangedInView;
  late Function(Map<String, dynamic>) onStatsUpdatedInView;
  
  @override
  void dispose() {
    // Limpiar recursos si es necesario
  }
  
  /// Configura las callbacks de la vista
  void setViewCallbacks({
    required Function navigateToBreathingExercise,
    required Function navigateToMindfulness,
    required Function navigateToEmotionalIntelligence,
    required Function navigateToNotifications,
    required Function navigateToSettings,
    required Function(String) showError,
    required Function(String) showSuccess,
    required Function(int) sectionChanged,
    required Function(Map<String, dynamic>) statsUpdated,
  }) {
    onNavigateToBreathingExerciseView = navigateToBreathingExercise;
    onNavigateToMindfulnessView = navigateToMindfulness;
    onNavigateToEmotionalIntelligenceView = navigateToEmotionalIntelligence;
    onNavigateToNotificationsView = navigateToNotifications;
    onNavigateToSettingsView = navigateToSettings;
    onShowError = showError;
    onShowSuccess = showSuccess;
    onSectionChangedInView = sectionChanged;
    onStatsUpdatedInView = statsUpdated;
  }
  
  /// Se llama cuando se inicializa la pantalla home
  void onHomeInitialized() {
    _logger.info('Home screen initialized');
    // Aquí se podría triggerar la carga de datos inicial
  }
  
  /// Se llama cuando cambia la sección seleccionada
  void onSectionChanged(int index) {
    _logger.info('Section changed to: $index');
    
    // Feedback háptico para cambio de sección
    HapticFeedback.selectionClick();
    
    // Notificar a la vista del cambio
    onSectionChangedInView(index);
    
    // Log de analytics (en producción)
    _logSectionChange(index);
  }
  
  /// Se llama cuando se navega al ejercicio de respiración
  void onNavigateToBreathingExercise() {
    _logger.info('Navigating to breathing exercise');
    
    // Feedback háptico
    HapticFeedback.lightImpact();
    
    // Navegar a la vista
    onNavigateToBreathingExerciseView();
  }
  
  /// Se llama cuando se navega a mindfulness
  void onNavigateToMindfulness() {
    _logger.info('Navigating to mindfulness');
    
    // Feedback háptico
    HapticFeedback.lightImpact();
    
    // Mostrar mensaje de funcionalidad próximamente (por ahora)
    onShowSuccess('Función de Mindfulness próximamente');
  }
  
  /// Se llama cuando se navega a inteligencia emocional
  void onNavigateToEmotionalIntelligence() {
    _logger.info('Navigating to emotional intelligence');
    
    // Feedback háptico
    HapticFeedback.lightImpact();
    
    // Mostrar mensaje de funcionalidad próximamente (por ahora)
    onShowSuccess('Función de Inteligencia Emocional próximamente');
  }
  
  /// Se llama cuando se navega a notificaciones
  void onNavigateToNotifications() {
    _logger.info('Navigating to notifications');
    
    // Feedback háptico
    HapticFeedback.lightImpact();
    
    // Mostrar mensaje de funcionalidad próximamente (por ahora)
    onShowSuccess('Función de Notificaciones próximamente');
  }
  
  /// Se llama cuando se navega a configuración
  void onNavigateToSettings() {
    _logger.info('Navigating to settings');
    
    // Feedback háptico
    HapticFeedback.lightImpact();
    
    // Navegar a la vista de configuración
    onNavigateToSettingsView();
  }
  
  /// Se llama cuando se cargan las estadísticas
  void onStatsLoaded(Map<String, dynamic> stats) {
    _logger.info('Stats loaded: $stats');
    
    // Validar las estadísticas
    if (_validateStats(stats)) {
      onStatsUpdatedInView(stats);
    } else {
      _logger.warning('Invalid stats format');
      onShowError('Error cargando estadísticas');
    }
  }
  
  /// Se llama cuando se actualizan las estadísticas
  void onStatsUpdated(Map<String, dynamic> stats) {
    _logger.info('Stats updated: $stats');
    
    // Validar las estadísticas
    if (_validateStats(stats)) {
      onStatsUpdatedInView(stats);
      
      // Mostrar feedback positivo si es una mejora significativa
      _checkForAchievements(stats);
    } else {
      _logger.warning('Invalid stats format in update');
      onShowError('Error actualizando estadísticas');
    }
  }
  
  /// Valida el formato de las estadísticas
  bool _validateStats(Map<String, dynamic> stats) {
    return stats.containsKey('sessionsToday') &&
           stats.containsKey('totalMinutes') &&
           stats.containsKey('streakDays') &&
           stats['sessionsToday'] is int &&
           stats['totalMinutes'] is int &&
           stats['streakDays'] is int;
  }
  
  /// Registra el cambio de sección para analytics
  void _logSectionChange(int index) {
    final sectionNames = ['Respiración', 'Mindfulness', 'Inteligencia Emocional'];
    final sectionName = index < sectionNames.length ? sectionNames[index] : 'Unknown';
    
    _logger.info('Section analytics: User viewed $sectionName section');
    // En producción aquí se enviarían los eventos a analytics
  }
  
  /// Verifica logros y muestra feedback positivo
  void _checkForAchievements(Map<String, dynamic> stats) {
    final sessionsToday = stats['sessionsToday'] as int;
    final streakDays = stats['streakDays'] as int;
    final totalMinutes = stats['totalMinutes'] as int;
    
    // Logro: Primera sesión del día
    if (sessionsToday == 1) {
      onShowSuccess('¡Primera sesión del día completada! 🎉');
    }
    
    // Logro: Múltiples sesiones
    if (sessionsToday == 3) {
      onShowSuccess('¡3 sesiones hoy! Estás en racha 🔥');
    }
    
    // Logro: Racha de días
    if (streakDays > 0 && streakDays % 7 == 0) {
      onShowSuccess('¡${streakDays} días de racha! Increíble constancia 🌟');
    }
    
    // Logro: Minutos totales
    if (totalMinutes > 0 && totalMinutes % 60 == 0) {
      final hours = totalMinutes ~/ 60;
      onShowSuccess('¡$hours hora${hours != 1 ? 's' : ''} de práctica! Sigue así 💪');
    }
  }
  
  /// Maneja errores generales de la pantalla home
  void handleError(String error) {
    _logger.severe('Error in home screen: $error');
    onShowError(error);
  }
  
  /// Formatea mensajes de éxito
  String formatSuccessMessage(String action) {
    switch (action) {
      case 'session_completed':
        return '¡Sesión completada exitosamente! 🧘‍♀️';
      case 'stats_updated':
        return 'Estadísticas actualizadas';
      case 'section_changed':
        return 'Sección cambiada';
      default:
        return 'Acción completada';
    }
  }
  
  /// Obtiene recomendaciones personalizadas
  String getPersonalizedRecommendation(Map<String, dynamic> stats) {
    final sessionsToday = stats['sessionsToday'] as int;
    final streakDays = stats['streakDays'] as int;
    
    if (sessionsToday == 0) {
      return 'Comienza tu día con una sesión de respiración de 5 minutos';
    } else if (sessionsToday >= 3) {
      return 'Has tenido un día muy productivo. Considera una sesión de relajación';
    } else if (streakDays >= 7) {
      return 'Tu constancia es admirable. Prueba un ejercicio más desafiante';
    } else {
      return 'Continúa con tu práctica diaria para mejores resultados';
    }
  }
  
  /// Calcula el progreso hacia el siguiente objetivo
  Map<String, dynamic> calculateProgress(Map<String, dynamic> stats) {
    final sessionsToday = stats['sessionsToday'] as int;
    final streakDays = stats['streakDays'] as int;
    
    // Objetivo diario: 3 sesiones
    final dailyGoal = 3;
    final dailyProgress = (sessionsToday / dailyGoal).clamp(0.0, 1.0);
    
    // Objetivo semanal: 7 días de racha
    final weeklyGoal = 7;
    final weeklyProgress = ((streakDays % weeklyGoal) / weeklyGoal).clamp(0.0, 1.0);
    
    return {
      'dailyProgress': dailyProgress,
      'weeklyProgress': weeklyProgress,
      'dailyRemaining': (dailyGoal - sessionsToday).clamp(0, dailyGoal),
      'weeklyRemaining': (weeklyGoal - (streakDays % weeklyGoal)).clamp(0, weeklyGoal),
    };
  }

  /// Se llama cuando se selecciona un ejercicio específico
  void onExerciseSelected(String exerciseType) {
    _logger.info('Exercise selected: $exerciseType');
    
    // Feedback háptico
    HapticFeedback.lightImpact();
    
    // Navegar al ejercicio específico
    onNavigateToBreathingExercise();
  }
}