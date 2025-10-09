import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

/// Presenter para la pantalla de configuración siguiendo Clean Architecture
/// Maneja la lógica de presentación y la comunicación con la vista
class SettingsPresenter extends Presenter {
  final Logger _logger = Logger('SettingsPresenter');
  
  // Referencias para la vista - usando nullable para evitar late initialization error
  Function(String)? onShowThemeDialogView;
  Function(List<String>)? onShowLanguageDialogView;
  Function? onShowEditProfileDialogView;
  Function? onNavigateToAboutView;
  Function? onNavigateToTermsView;
  Function? onNavigateToPrivacyView;
  Function? onNavigateToSupportView;
  Function? onLogoutView;
  Function? onDeleteAccountView;
  Function? onExportDataView;
  Function(String)? onShowError;
  Function(String)? onShowSuccess;
  Function(Map<String, dynamic>)? onSettingsUpdated;
  Function(Map<String, dynamic>)? onProfileUpdated;
  
  @override
  void dispose() {
    // Limpiar recursos si es necesario
  }
  
  /// Configura las callbacks de la vista
  void setViewCallbacks({
    required Function(String) showThemeDialog,
    required Function(List<String>) showLanguageDialog,
    required Function showEditProfileDialog,
    required Function navigateToAbout,
    required Function navigateToTerms,
    required Function navigateToPrivacy,
    required Function navigateToSupport,
    required Function logout,
    required Function deleteAccount,
    required Function exportData,
    required Function(String) showError,
    required Function(String) showSuccess,
    required Function(Map<String, dynamic>) settingsUpdated,
    required Function(Map<String, dynamic>) profileUpdated,
  }) {
    onShowThemeDialogView = showThemeDialog;
    onShowLanguageDialogView = showLanguageDialog;
    onShowEditProfileDialogView = showEditProfileDialog;
    onNavigateToAboutView = navigateToAbout;
    onNavigateToTermsView = navigateToTerms;
    onNavigateToPrivacyView = navigateToPrivacy;
    onNavigateToSupportView = navigateToSupport;
    onLogoutView = logout;
    onDeleteAccountView = deleteAccount;
    onExportDataView = exportData;
    onShowError = showError;
    onShowSuccess = showSuccess;
    onSettingsUpdated = settingsUpdated;
    onProfileUpdated = profileUpdated;
  }
  
  /// Se llama cuando se inicializa la pantalla de configuración
  void onSettingsInitialized() {
    _logger.info('Settings screen initialized');
    onShowSuccess?.call('Configuración cargada');
  }
  
  /// Se llama cuando se cambia el tema
  void onThemeChanged(String theme) {
    _logger.info('Theme changed to: $theme');
    
    // Feedback háptico
    HapticFeedback.selectionClick();
    
    // Mostrar confirmación
    onShowSuccess?.call('Tema cambiado a: ${_getThemeDisplayName(theme)}');
    
    // Aplicar el tema (en producción se comunicaría con el sistema de temas)
    _applyTheme(theme);
  }
  
  /// Se llama cuando se cambia el idioma
  void onLanguageChanged(String language) {
    _logger.info('Language changed to: $language');
    
    // Feedback háptico
    HapticFeedback.selectionClick();
    
    // Mostrar confirmación
    onShowSuccess?.call('Idioma cambiado a: $language');
    
    // Aplicar el idioma (en producción se comunicaría con el sistema de localización)
    _applyLanguage(language);
  }
  
  /// Se llama cuando se alternan las notificaciones
  void onNotificationsToggled(bool enabled) {
    _logger.info('Notifications toggled: $enabled');
    
    // Feedback háptico
    HapticFeedback.lightImpact();
    
    if (enabled) {
      onShowSuccess?.call('Notificaciones activadas');
      _requestNotificationPermissions();
    } else {
      onShowSuccess?.call('Notificaciones desactivadas');
    }
  }
  
  /// Se llama cuando se alterna el sonido
  void onSoundToggled(bool enabled) {
    _logger.info('Sound toggled: $enabled');
    
    // Feedback háptico
    HapticFeedback.lightImpact();
    
    if (enabled) {
      onShowSuccess?.call('Sonidos activados');
    } else {
      onShowSuccess?.call('Sonidos desactivados');
    }
  }
  
  /// Se llama cuando se cambia el volumen
  void onSoundVolumeChanged(double volume) {
    _logger.info('Sound volume changed to: $volume');
    
    // Feedback háptico suave
    HapticFeedback.selectionClick();
    
    // Reproducir sonido de prueba con el nuevo volumen
    _playTestSound(volume);
  }
  
  /// Se llama cuando se actualiza el perfil
  void onProfileUpdateRequested(String name, String email, String? avatar) {
    _logger.info('Profile updated: $name, $email');
    
    // Feedback háptico
    HapticFeedback.lightImpact();
    
    // Validar datos del perfil
    if (_validateProfileData(name, email)) {
      onShowSuccess?.call('Perfil actualizado correctamente');
      
      final profileData = {
        'name': name,
        'email': email,
        'avatar': avatar,
      };
      
      onProfileUpdated?.call(profileData);
    } else {
      onShowError?.call('Error: Datos del perfil inválidos');
    }
  }
  
  /// Se llama cuando se muestra el diálogo de tema
  void onShowThemeDialog() {
    _logger.info('Showing theme dialog');
    onShowThemeDialogView?.call('Seleccionar tema');
  }
  
  /// Se llama cuando se muestra el diálogo de idioma
  void onShowLanguageDialog() {
    _logger.info('Showing language dialog');
    final languages = ['Español', 'English', 'Français', 'Português'];
    onShowLanguageDialogView?.call(languages);
  }
  
  /// Se llama cuando se muestra el diálogo de edición de perfil
  void onShowEditProfileDialog() {
    _logger.info('Showing edit profile dialog');
    onShowEditProfileDialogView?.call();
  }
  
  /// Se llama cuando se navega a la información de la app
  void onNavigateToAbout() {
    _logger.info('Navigating to about');
    HapticFeedback.lightImpact();
    onNavigateToAboutView?.call();
  }
  
  /// Se llama cuando se navega a términos y condiciones
  void onNavigateToTerms() {
    _logger.info('Navigating to terms');
    HapticFeedback.lightImpact();
    onNavigateToTermsView?.call();
  }
  
  /// Se llama cuando se navega a política de privacidad
  void onNavigateToPrivacy() {
    _logger.info('Navigating to privacy');
    HapticFeedback.lightImpact();
    onNavigateToPrivacyView?.call();
  }
  
  /// Se llama cuando se navega al soporte
  void onNavigateToSupport() {
    _logger.info('Navigating to support');
    HapticFeedback.lightImpact();
    onNavigateToSupportView?.call();
  }
  
  /// Se llama cuando se solicita cerrar sesión
  void onLogoutRequested() {
    _logger.info('Logout requested');
    HapticFeedback.mediumImpact();
    
    // Mostrar confirmación antes del logout
    _showLogoutConfirmation();
  }
  
  /// Se llama cuando se solicita eliminar cuenta
  void onAccountDeletionRequested() {
    _logger.info('Account deletion requested');
    HapticFeedback.heavyImpact();
    
    // Mostrar advertencia severa antes de la eliminación
    _showAccountDeletionWarning();
  }
  
  /// Se llama cuando se solicita exportar datos
  void onDataExportRequested() {
    _logger.info('Data export requested');
    HapticFeedback.lightImpact();
    
    onShowSuccess?.call('Preparando exportación de datos...');
    _initiateDataExport();
  }
  
  /// Se llama cuando se guardan las configuraciones
  void onSettingsSaved(Map<String, dynamic> settings) {
    _logger.info('Settings saved: $settings');
    onSettingsUpdated?.call(settings);
  }
  
  /// Se llama cuando se guarda el perfil
  void onProfileSaved(Map<String, dynamic> profile) {
    _logger.info('Profile saved: $profile');
    onProfileUpdated?.call(profile);
  }
  
  /// Se llama cuando se resetean las configuraciones
  void onSettingsReset() {
    _logger.info('Settings reset to defaults');
    HapticFeedback.mediumImpact();
    onShowSuccess?.call('Configuración restablecida a valores por defecto');
  }
  
  /// Aplica el tema seleccionado
  void _applyTheme(String theme) {
    // En producción, esto se comunicaría con el sistema de temas de la app
    _logger.info('Applying theme: $theme');
  }
  
  /// Aplica el idioma seleccionado
  void _applyLanguage(String language) {
    // En producción, esto se comunicaría con el sistema de localización
    _logger.info('Applying language: $language');
  }
  
  /// Solicita permisos de notificaciones
  void _requestNotificationPermissions() {
    // En producción, esto solicitaría permisos del sistema
    _logger.info('Requesting notification permissions');
  }
  
  /// Reproduce un sonido de prueba
  void _playTestSound(double volume) {
    // En producción, esto reproduciría un sonido con el volumen especificado
    _logger.info('Playing test sound at volume: $volume');
  }
  
  /// Valida los datos del perfil
  bool _validateProfileData(String name, String email) {
    if (name.trim().isEmpty || name.length < 2) {
      return false;
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return false;
    }
    
    return true;
  }
  
  /// Muestra confirmación de logout
  void _showLogoutConfirmation() {
    // En producción, esto mostraría un diálogo de confirmación
    _logger.info('Showing logout confirmation');
    onLogoutView?.call();
  }
  
  /// Muestra advertencia de eliminación de cuenta
  void _showAccountDeletionWarning() {
    // En producción, esto mostraría un diálogo de advertencia severa
    _logger.info('Showing account deletion warning');
    onDeleteAccountView?.call();
  }
  
  /// Inicia la exportación de datos
  void _initiateDataExport() {
    // En producción, esto iniciaría el proceso de exportación
    _logger.info('Initiating data export');
    
    // Simular proceso de exportación
    Future.delayed(const Duration(seconds: 2), () {
      onShowSuccess?.call('Datos exportados correctamente');
      onExportDataView?.call();
    });
  }
  
  /// Obtiene el nombre a mostrar para un tema
  String _getThemeDisplayName(String theme) {
    switch (theme) {
      case 'Sistema':
        return 'Sistema';
      case 'Claro':
        return 'Claro';
      case 'Oscuro':
        return 'Oscuro';
      default:
        return theme;
    }
  }
  
  /// Maneja errores generales de la configuración
  void handleError(String error) {
    _logger.severe('Error in settings: $error');
    onShowError?.call(error);
  }
  
  /// Formatea mensajes de configuración
  String formatSettingMessage(String setting, dynamic value) {
    switch (setting) {
      case 'theme':
        return 'Tema: ${_getThemeDisplayName(value)}';
      case 'language':
        return 'Idioma: $value';
      case 'notifications':
        return 'Notificaciones: ${value ? 'Activadas' : 'Desactivadas'}';
      case 'sound':
        return 'Sonidos: ${value ? 'Activados' : 'Desactivados'}';
      case 'volume':
        return 'Volumen: ${(value * 100).round()}%';
      default:
        return '$setting: $value';
    }
  }
}
