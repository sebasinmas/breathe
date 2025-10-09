import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:logging/logging.dart';
import 'settings_presenter.dart';

/// Controller para la pantalla de configuración siguiendo Clean Architecture
/// 
/// Responsabilidades:
/// - Gestionar las preferencias del usuario
/// - Controlar las configuraciones de la app
/// - Manejar el perfil del usuario
/// - Comunicarse con el presenter
class SettingsController extends Controller {
  final SettingsPresenter _presenter;
  final Logger _logger = Logger('SettingsController');
  
  // Estado de las configuraciones
  String _selectedTheme = 'Sistema';
  String _selectedLanguage = 'Español';
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  double _soundVolume = 0.7;
  
  // Información del perfil
  String _userName = 'Usuario';
  String _userEmail = 'usuario@email.com';
  String? _userAvatar;

  // Getters para el presenter
  String get selectedTheme => _selectedTheme;
  String get selectedLanguage => _selectedLanguage;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  double get soundVolume => _soundVolume;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String? get userAvatar => _userAvatar;

  SettingsController() : _presenter = SettingsPresenter();

  @override
  void initListeners() {
    // Inicializar listeners si es necesario
  }

  @override
  void onInitState() {
    super.onInitState();
    _logger.info('Initializing SettingsController');
    
    // Cargar configuraciones guardadas
    _loadSettings();
    
    // Notificar al presenter que se inicializó
    _presenter.onSettingsInitialized();
  }

  /// Cambia el tema de la aplicación
  void changeTheme(String theme) {
    if (_selectedTheme != theme) {
      _logger.info('Changing theme from $_selectedTheme to $theme');
      
      _selectedTheme = theme;
      
      // Guardar configuración
      _saveSettings();
      
      // Notificar al presenter
      _presenter.onThemeChanged(theme);
      
      refreshUI();
    }
  }

  /// Cambia el idioma de la aplicación
  void changeLanguage(String language) {
    if (_selectedLanguage != language) {
      _logger.info('Changing language from $_selectedLanguage to $language');
      
      _selectedLanguage = language;
      
      // Guardar configuración
      _saveSettings();
      
      // Notificar al presenter
      _presenter.onLanguageChanged(language);
      
      refreshUI();
    }
  }

  /// Alterna las notificaciones
  void toggleNotifications(bool enabled) {
    if (_notificationsEnabled != enabled) {
      _logger.info('Toggling notifications: $enabled');
      
      _notificationsEnabled = enabled;
      
      // Guardar configuración
      _saveSettings();
      
      // Notificar al presenter
      _presenter.onNotificationsToggled(enabled);
      
      refreshUI();
    }
  }

  /// Alterna el sonido
  void toggleSound(bool enabled) {
    if (_soundEnabled != enabled) {
      _logger.info('Toggling sound: $enabled');
      
      _soundEnabled = enabled;
      
      // Guardar configuración
      _saveSettings();
      
      // Notificar al presenter
      _presenter.onSoundToggled(enabled);
      
      refreshUI();
    }
  }

  /// Cambia el volumen del sonido
  void changeSoundVolume(double volume) {
    if (_soundVolume != volume) {
      _logger.info('Changing sound volume to: $volume');
      
      _soundVolume = volume;
      
      // Guardar configuración
      _saveSettings();
      
      // Notificar al presenter
      _presenter.onSoundVolumeChanged(volume);
      
      refreshUI();
    }
  }

  /// Actualiza el perfil del usuario
  void updateProfile({
    String? name,
    String? email,
    String? avatar,
  }) {
    bool updated = false;
    
    if (name != null && name != _userName) {
      _userName = name;
      updated = true;
    }
    
    if (email != null && email != _userEmail) {
      _userEmail = email;
      updated = true;
    }
    
    if (avatar != null && avatar != _userAvatar) {
      _userAvatar = avatar;
      updated = true;
    }
    
    if (updated) {
      _logger.info('Profile updated: name=$_userName, email=$_userEmail');
      
      // Guardar perfil
      _saveProfile();
      
      // Notificar al presenter
      _presenter.onProfileUpdated?.call({
        'name': _userName,
        'email': _userEmail,
        'avatar': _userAvatar,
      });
      
      refreshUI();
    }
  }

  /// Muestra el diálogo de cambio de tema
  void showThemeDialog() {
    _presenter.onShowThemeDialog();
  }

  /// Muestra el diálogo de cambio de idioma
  void showLanguageDialog() {
    _presenter.onShowLanguageDialog();
  }

  /// Muestra el diálogo de edición de perfil
  void showEditProfileDialog() {
    _presenter.onShowEditProfileDialog();
  }

  /// Navega a la información de la app
  void navigateToAbout() {
    _logger.info('Navigating to about');
    _presenter.onNavigateToAbout();
  }

  /// Navega a los términos y condiciones
  void navigateToTerms() {
    _logger.info('Navigating to terms');
    _presenter.onNavigateToTerms();
  }

  /// Navega a la política de privacidad
  void navigateToPrivacy() {
    _logger.info('Navigating to privacy');
    _presenter.onNavigateToPrivacy();
  }

  /// Navega al soporte
  void navigateToSupport() {
    _logger.info('Navigating to support');
    _presenter.onNavigateToSupport();
  }

  /// Cierra sesión del usuario
  void logout() {
    _logger.info('User logout initiated');
    _presenter.onLogoutRequested();
  }

  /// Elimina la cuenta del usuario
  void deleteAccount() {
    _logger.info('Account deletion requested');
    _presenter.onAccountDeletionRequested();
  }

  /// Exporta los datos del usuario
  void exportData() {
    _logger.info('Data export requested');
    _presenter.onDataExportRequested();
  }

  /// Resetea todas las configuraciones a valores por defecto
  void resetToDefaults() {
    _logger.info('Resetting settings to defaults');
    
    _selectedTheme = 'Sistema';
    _selectedLanguage = 'Español';
    _notificationsEnabled = true;
    _soundEnabled = true;
    _soundVolume = 0.7;
    
    _saveSettings();
    _presenter.onSettingsReset();
    
    refreshUI();
  }

  /// Carga las configuraciones guardadas
  void _loadSettings() {
    // En una implementación real, esto cargaría desde SharedPreferences o similar
    _logger.info('Loading settings from storage');
    
    // Simular carga desde almacenamiento local
    // En producción: usar SharedPreferences, Hive, etc.
  }

  /// Guarda las configuraciones actuales
  void _saveSettings() {
    // En una implementación real, esto guardaría en SharedPreferences o similar
    _logger.info('Saving settings to storage');
    
    final settings = {
      'theme': _selectedTheme,
      'language': _selectedLanguage,
      'notifications': _notificationsEnabled,
      'sound': _soundEnabled,
      'soundVolume': _soundVolume,
    };
    
    // En producción: guardar en almacenamiento local
    _presenter.onSettingsSaved(settings);
  }

  /// Guarda el perfil del usuario
  void _saveProfile() {
    // En una implementación real, esto guardaría en el backend
    _logger.info('Saving profile to storage');
    
    final profile = {
      'name': _userName,
      'email': _userEmail,
      'avatar': _userAvatar,
    };
    
    // En producción: guardar en backend/almacenamiento local
    _presenter.onProfileSaved(profile);
  }

  /// Obtiene los temas disponibles
  List<String> getAvailableThemes() {
    return ['Sistema', 'Claro', 'Oscuro'];
  }

  /// Obtiene los idiomas disponibles
  List<String> getAvailableLanguages() {
    return ['Español', 'English', 'Français', 'Português'];
  }

  /// Valida el email del usuario
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Valida el nombre del usuario
  bool isValidName(String name) {
    return name.trim().isNotEmpty && name.length >= 2;
  }

  /// Métodos de interacción con la vista
  void onEditProfilePressed() {
    _logger.info('Edit profile pressed');
    _presenter.onShowEditProfileDialog();
  }

  void onThemePressed() {
    _logger.info('Theme pressed');
    _presenter.onShowThemeDialog();
  }

  void onLanguagePressed() {
    _logger.info('Language pressed');
    _presenter.onShowLanguageDialog();
  }

  void onNotificationsToggled(bool value) {
    _logger.info('Notifications toggled: $value');
    _notificationsEnabled = value;
    _presenter.onNotificationsToggled(value);
    refreshUI();
  }

  void onNotificationSchedulePressed() {
    _logger.info('Notification schedule pressed');
    // Implementar lógica de horario de notificaciones
  }

  void onSoundToggled(bool value) {
    _logger.info('Sound toggled: $value');
    _soundEnabled = value;
    _presenter.onSoundToggled(value);
    refreshUI();
  }

  void onSoundVolumeChanged(double value) {
    _logger.info('Sound volume changed: $value');
    _soundVolume = value;
    _presenter.onSoundVolumeChanged(value);
    refreshUI();
  }

  void onAboutPressed() {
    _logger.info('About pressed');
    _presenter.onNavigateToAbout();
  }

  void onTermsPressed() {
    _logger.info('Terms pressed');
    _presenter.onNavigateToTerms();
  }

  void onPrivacyPressed() {
    _logger.info('Privacy pressed');
    _presenter.onNavigateToPrivacy();
  }

  void onSupportPressed() {
    _logger.info('Support pressed');
    _presenter.onNavigateToSupport();
  }

  void onExportDataPressed() {
    _logger.info('Export data pressed');
    _presenter.onDataExportRequested();
  }

  void onLogoutPressed() {
    _logger.info('Logout pressed');
    _presenter.onLogoutRequested();
  }

  void onDeleteAccountPressed() {
    _logger.info('Delete account pressed');
    _presenter.onAccountDeletionRequested();
  }

  void onResetSettingsPressed() {
    _logger.info('Reset settings pressed');
    _resetToDefaults();
    _presenter.onSettingsReset();
    refreshUI();
  }

  void onThemeSelected(String theme) {
    _logger.info('Theme selected: $theme');
    _selectedTheme = theme;
    _presenter.onThemeChanged(theme);
    refreshUI();
  }

  void onLanguageSelected(String language) {
    _logger.info('Language selected: $language');
    _selectedLanguage = language;
    _presenter.onLanguageChanged(language);
    refreshUI();
  }

  void onProfileUpdated(String name, String email, String? avatar) {
    _logger.info('Profile updated: $name, $email');
    _userName = name;
    _userEmail = email;
    if (avatar != null) {
      _userAvatar = avatar;
    }
    _presenter.onProfileUpdateRequested(name, email, avatar);
    refreshUI();
  }

  /// Resetea la configuración a valores por defecto
  void _resetToDefaults() {
    _selectedTheme = 'Sistema';
    _selectedLanguage = 'Español';
    _notificationsEnabled = true;
    _soundEnabled = true;
    _soundVolume = 0.8;
  }

  @override
  void onDisposed() {
    _logger.info('Disposing SettingsController');
    _presenter.dispose();
    super.onDisposed();
  }
}
