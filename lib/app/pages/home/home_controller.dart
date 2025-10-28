import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:logging/logging.dart';
import 'package:go_router/go_router.dart';
import 'home_presenter.dart';

/// Controller para la pantalla principal (Home) siguiendo Clean Architecture
/// 
/// Responsabilidades:
/// - Gestionar la navegación entre secciones
/// - Controlar las animaciones de transición
/// - Manejar las estadísticas del usuario
/// - Comunicarse con el presenter
class HomeController extends Controller {
  final HomePresenter _presenter;
  final Logger _logger = Logger('HomeController');
  
  // Estado del controller
  int _selectedSectionIndex = 0;
  int _currentSection = 0;
  bool _animationsInitialized = false;
  String _userName = 'Usuario';
  double _weeklyProgress = 0.65;
  Map<String, dynamic> _userStats = {
    'sessionsToday': 0,
    'totalMinutes': 0,
    'streakDays': 0,
  };

  // Getters para el presenter y vista
  int get selectedSectionIndex => _selectedSectionIndex;
  int get currentSection => _currentSection;
  bool get animationsInitialized => _animationsInitialized;
  Map<String, dynamic> get userStats => _userStats;
  String get userName => _userName;
  int get totalSessions => _userStats['sessionsToday'] ?? 0;
  int get totalMinutes => _userStats['totalMinutes'] ?? 0;
  int get currentStreak => _userStats['streakDays'] ?? 0;
  double get weeklyProgress => _weeklyProgress;

  HomeController() : _presenter = HomePresenter();

  @override
  void initListeners() {
    // Inicializar listeners si es necesario
  }

  @override
  void onInitState() {
    super.onInitState();
    _logger.info('Initializing HomeController');
    
    // Cargar estadísticas del usuario
    _loadUserStats();
    
    // Notificar al presenter que se inicializó
    _presenter.onHomeInitialized();
  }

  /// Cambia la sección seleccionada
  void changeSection(int index) {
    if (_selectedSectionIndex != index) {
      _logger.info('Changing section from $_selectedSectionIndex to $index');
      
      _selectedSectionIndex = index;
      
      // Notificar al presenter del cambio
      _presenter.onSectionChanged(index);
      
      refreshUI();
    }
  }

  /// Marca las animaciones como inicializadas
  void markAnimationsAsInitialized() {
    _animationsInitialized = true;
    refreshUI();
  }

  /// Navega a la pantalla de ejercicio de respiración
  void navigateToBreathingExercise() {
    _logger.info('Navigating to breathing exercise');
    // Usar go_router para navegar
    final context = getStateKey().currentContext;
    if (context != null && context.mounted) {
      context.push('/breathing-exercise');
    }
  }

  /// Navega a la pantalla de configuración
  void navigateToSettings() {
    _logger.info('Navigating to settings');
    // Usar go_router para navegar
    final context = getStateKey().currentContext;
    if (context != null && context.mounted) {
      context.push('/settings');
    }
  }

  /// Actualiza las estadísticas del usuario
  void updateUserStats({
    int? sessionsToday,
    int? totalMinutes,
    int? streakDays,
  }) {
    if (sessionsToday != null) _userStats['sessionsToday'] = sessionsToday;
    if (totalMinutes != null) _userStats['totalMinutes'] = totalMinutes;
    if (streakDays != null) _userStats['streakDays'] = streakDays;
    
    _presenter.onStatsUpdated(_userStats);
    refreshUI();
  }

  /// Carga las estadísticas del usuario desde el repositorio
  void _loadUserStats() {
    // En una implementación real, esto cargaría desde el repositorio
    // Por ahora simulamos algunos datos
    _userStats = {
      'sessionsToday': 2,
      'totalMinutes': 45,
      'streakDays': 7,
    };
    
    _presenter.onStatsLoaded(_userStats);
  }

  /// Incrementa las sesiones de hoy
  void incrementTodaySessions() {
    _userStats['sessionsToday'] = (_userStats['sessionsToday'] ?? 0) + 1;
    _presenter.onStatsUpdated(_userStats);
    refreshUI();
  }

  /// Añade minutos al total
  void addMinutesToTotal(int minutes) {
    _userStats['totalMinutes'] = (_userStats['totalMinutes'] ?? 0) + minutes;
    _presenter.onStatsUpdated(_userStats);
    refreshUI();
  }

  /// Actualiza la racha de días
  void updateStreakDays(int days) {
    _userStats['streakDays'] = days;
    _presenter.onStatsUpdated(_userStats);
    refreshUI();
  }

  /// Retorna el saludo apropiado según la hora
  String getGreetingMessage() {
    final hour = DateTime.now().hour;
    
    if (hour >= 6 && hour < 12) {
      return '¡Buenos días! ☀️';
    } else if (hour >= 12 && hour < 18) {
      return '¡Buenas tardes! 🌤️';
    } else if (hour >= 18 && hour < 22) {
      return '¡Buenas noches! 🌙';
    } else {
      return '¡Hola! 👋';
    }
  }

  /// Retorna el mensaje motivacional apropiado
  String getMotivationalMessage() {
    final messages = [
      'Respira profundo y encuentra tu paz interior',
      'Cada respiración te acerca a la calma',
      'Hoy es un buen día para practicar mindfulness',
      'Dedica unos minutos a tu bienestar mental',
      'Tu mente merece este momento de tranquilidad',
    ];
    
    return messages[DateTime.now().day % messages.length];
  }

  /// Formatea las estadísticas para mostrar
  String formatStats(String key, dynamic value) {
    switch (key) {
      case 'sessionsToday':
        return '$value sesión${value != 1 ? 'es' : ''}';
      case 'totalMinutes':
        return '$value min';
      case 'streakDays':
        return '$value día${value != 1 ? 's' : ''}';
      default:
        return value.toString();
    }
  }

  /// Obtiene el título de una estadística
  String getStatsTitle(String key) {
    switch (key) {
      case 'sessionsToday':
        return 'Hoy';
      case 'totalMinutes':
        return 'Total';
      case 'streakDays':
        return 'Racha';
      default:
        return key;
    }
  }

  /// Métodos de interacción con la vista
  void onSettingsPressed() {
    _logger.info('Settings pressed');
    navigateToSettings();
  }

  void onSectionChanged(int index) {
    _logger.info('Section changed to: $index');
    _currentSection = index;
    changeSection(index);
    refreshUI();
  }

  void onExerciseSelected(String exerciseType) {
    _logger.info('Exercise selected: $exerciseType');
    _presenter.onExerciseSelected(exerciseType);
  }

  void onStartBreathingExercise() {
    _logger.info('Start breathing exercise pressed');
    navigateToBreathingExercise();
  }

  /// Carga el nombre del usuario
  void loadUserName() {
    // En producción esto vendría del repositorio de usuario
    _userName = 'María';
    refreshUI();
  }

  /// Actualiza el progreso semanal
  void updateWeeklyProgress(double progress) {
    _weeklyProgress = progress.clamp(0.0, 1.0);
    refreshUI();
  }

  @override
  void onDisposed() {
    _logger.info('Disposing HomeController');
    _presenter.dispose();
    super.onDisposed();
  }
}

