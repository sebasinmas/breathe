import 'package:flutter/material.dart';
import 'dart:ui';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';

/// Vista de configuración de la aplicación con diseño glassmorphism
/// Permite cambiar tema, idioma, perfil y otras preferencias
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Estados de configuración
  String _selectedTheme = 'Sistema';
  String _selectedLanguage = 'Español';
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  double _soundVolume = 0.7;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Configuración',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.8),
              colorScheme.secondary.withOpacity(0.6),
              colorScheme.tertiary.withOpacity(0.4),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Sección de perfil
              _buildProfileSection(),
              
              const SizedBox(height: 24),
              
              // Sección de apariencia
              _buildAppearanceSection(),
              
              const SizedBox(height: 24),
              
              // Sección de notificaciones
              _buildNotificationsSection(),
              
              const SizedBox(height: 24),
              
              // Sección de audio
              _buildAudioSection(),
              
              const SizedBox(height: 24),
              
              // Sección de cuenta
              _buildAccountSection(),
              
              const SizedBox(height: 24),
              
              // Sección de información
              _buildInfoSection(),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required Widget leading,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
            )
          : null,
      trailing: trailing ??
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.white.withOpacity(0.6),
          ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required Widget leading,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: leading,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
            )
          : null,
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildProfileSection() {
    return _buildSection(
      title: 'Perfil',
      children: [
        _buildSettingsTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(Icons.person, color: Colors.white),
          ),
          title: 'Usuario Demo',
          subtitle: 'usuario@breathe.com',
          onTap: () {
            _showEditProfileDialog();
          },
        ),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    return _buildSection(
      title: 'Apariencia',
      children: [
        _buildSettingsTile(
          leading: const Icon(Icons.palette_outlined, color: Colors.white),
          title: 'Tema',
          subtitle: _selectedTheme,
          onTap: () {
            _showThemeDialog();
          },
        ),
        _buildSettingsTile(
          leading: const Icon(Icons.language_outlined, color: Colors.white),
          title: 'Idioma',
          subtitle: _selectedLanguage,
          onTap: () {
            _showLanguageDialog();
          },
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return _buildSection(
      title: 'Notificaciones',
      children: [
        _buildSwitchTile(
          leading: const Icon(Icons.notifications_outlined, color: Colors.white),
          title: 'Recordatorios',
          subtitle: 'Recibir recordatorios para meditar',
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        if (_notificationsEnabled)
          _buildSettingsTile(
            leading: const Icon(Icons.schedule_outlined, color: Colors.white),
            title: 'Horarios',
            subtitle: 'Configurar horarios de recordatorio',
            onTap: () {
              _showScheduleDialog();
            },
          ),
      ],
    );
  }

  Widget _buildAudioSection() {
    return _buildSection(
      title: 'Audio',
      children: [
        _buildSwitchTile(
          leading: const Icon(Icons.volume_up_outlined, color: Colors.white),
          title: 'Sonidos',
          subtitle: 'Habilitar sonidos ambientales',
          value: _soundEnabled,
          onChanged: (value) {
            setState(() {
              _soundEnabled = value;
            });
          },
        ),
        if (_soundEnabled)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.volume_mute_outlined, color: Colors.white),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Volumen',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${(_soundVolume * 100).round()}%',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _soundVolume,
                  onChanged: (value) {
                    setState(() {
                      _soundVolume = value;
                    });
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Colors.white.withOpacity(0.3),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return _buildSection(
      title: 'Cuenta',
      children: [
        _buildSettingsTile(
          leading: const Icon(Icons.backup_outlined, color: Colors.white),
          title: 'Respaldo y sincronización',
          subtitle: 'Guardar progreso en la nube',
          onTap: () {
            _showBackupDialog();
          },
        ),
        _buildSettingsTile(
          leading: const Icon(Icons.analytics_outlined, color: Colors.white),
          title: 'Estadísticas',
          subtitle: 'Ver tu progreso detallado',
          onTap: () {
            _showStatsDialog();
          },
        ),
        _buildSettingsTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: 'Cerrar sesión',
          onTap: () {
            _showLogoutDialog();
          },
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return _buildSection(
      title: 'Información',
      children: [
        _buildSettingsTile(
          leading: const Icon(Icons.help_outline, color: Colors.white),
          title: 'Ayuda y soporte',
          onTap: () {
            _showHelpDialog();
          },
        ),
        _buildSettingsTile(
          leading: const Icon(Icons.star_outline, color: Colors.white),
          title: 'Calificar la app',
          onTap: () {
            _showRatingDialog();
          },
        ),
        _buildSettingsTile(
          leading: const Icon(Icons.info_outline, color: Colors.white),
          title: 'Acerca de Breathe',
          subtitle: 'Versión 1.0.0',
          onTap: () {
            _showAboutDialog();
          },
        ),
      ],
    );
  }

  // Dialog methods
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildGlassDialog(
        title: 'Editar Perfil',
        content: const Text(
          'Función próximamente disponible',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildGlassDialog(
        title: 'Seleccionar Tema',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Claro', style: TextStyle(color: Colors.white)),
              value: 'Claro',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Oscuro', style: TextStyle(color: Colors.white)),
              value: 'Oscuro',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Sistema', style: TextStyle(color: Colors.white)),
              value: 'Sistema',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildGlassDialog(
        title: 'Seleccionar Idioma',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Español', style: TextStyle(color: Colors.white)),
              value: 'Español',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('English', style: TextStyle(color: Colors.white)),
              value: 'English',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildGlassDialog(
        title: 'Configurar Horarios',
        content: const Text(
          'Aquí podrás configurar recordatorios personalizados para tus sesiones de meditación.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildGlassDialog(
        title: 'Respaldo y Sincronización',
        content: const Text(
          'Sincroniza tu progreso con la nube para no perder tus estadísticas.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showStatsDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildGlassDialog(
        title: 'Estadísticas Detalladas',
        content: const Text(
          'Visualiza gráficos y métricas de tu progreso en meditación.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildGlassDialog(
        title: 'Cerrar Sesión',
        content: const Text(
          '¿Estás seguro de que deseas cerrar sesión?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          SecondaryButton(
            text: 'Cancelar',
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          PrimaryButton(
            text: 'Cerrar Sesión',
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildGlassDialog(
        title: 'Ayuda y Soporte',
        content: const Text(
          'Para obtener ayuda, visita nuestro centro de soporte o contacta con nosotros.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildGlassDialog(
        title: 'Calificar Breathe',
        content: const Text(
          '¿Te gusta nuestra app? ¡Ayúdanos calificándola en la tienda!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildGlassDialog(
        title: 'Acerca de Breathe',
        content: const Text(
          'Breathe v1.0.0\n\nUna aplicación de meditación y bienestar diseñada para ayudarte a encontrar la calma en tu día a día.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildGlassDialog({
    required String title,
    required Widget content,
    List<Widget>? actions,
  }) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            content,
            if (actions != null) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions,
              ),
            ] else ...[
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Entendido',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ],
        ),
      ),
    );
  }
}