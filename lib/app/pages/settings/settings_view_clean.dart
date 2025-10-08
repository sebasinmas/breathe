import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'settings_controller.dart';
import 'settings_presenter.dart';

/// Vista de configuración siguiendo Clean Architecture
/// Utiliza CleanView para seguir el patrón establecido
class SettingsViewClean extends CleanView {
  const SettingsViewClean({super.key});

  @override
  _SettingsViewCleanState createState() => _SettingsViewCleanState();
}

class _SettingsViewCleanState extends CleanViewState<SettingsViewClean, SettingsController> {
  _SettingsViewCleanState() : super(SettingsController(SettingsPresenter()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: const Text('Configuración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ControlledWidgetBuilder<SettingsController>(
        builder: (context, controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileSection(controller),
                const SizedBox(height: 24),
                _buildAppearanceSection(controller),
                const SizedBox(height: 24),
                _buildNotificationSection(controller),
                const SizedBox(height: 24),
                _buildAudioSection(controller),
                const SizedBox(height: 24),
                _buildAboutSection(controller),
                const SizedBox(height: 24),
                _buildAccountSection(controller),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(SettingsController controller) {
    return _buildSection(
      title: 'Perfil',
      icon: Icons.person,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: controller.userAvatar != null 
                ? NetworkImage(controller.userAvatar!)
                : null,
            child: controller.userAvatar == null 
                ? const Icon(Icons.person) 
                : null,
          ),
          title: Text(controller.userName),
          subtitle: Text(controller.userEmail),
          trailing: const Icon(Icons.edit),
          onTap: () => controller.onEditProfilePressed(),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(SettingsController controller) {
    return _buildSection(
      title: 'Apariencia',
      icon: Icons.palette,
      children: [
        ListTile(
          leading: const Icon(Icons.brightness_6),
          title: const Text('Tema'),
          subtitle: Text(controller.selectedTheme),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => controller.onThemePressed(),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Idioma'),
          subtitle: Text(controller.selectedLanguage),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => controller.onLanguagePressed(),
        ),
      ],
    );
  }

  Widget _buildNotificationSection(SettingsController controller) {
    return _buildSection(
      title: 'Notificaciones',
      icon: Icons.notifications,
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.notifications_active),
          title: const Text('Notificaciones'),
          subtitle: const Text('Recibir recordatorios y actualizaciones'),
          value: controller.notificationsEnabled,
          onChanged: (value) => controller.onNotificationsToggled(value),
        ),
        if (controller.notificationsEnabled) ...[
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Horario de notificaciones'),
            subtitle: const Text('8:00 AM - 10:00 PM'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => controller.onNotificationSchedulePressed(),
          ),
        ],
      ],
    );
  }

  Widget _buildAudioSection(SettingsController controller) {
    return _buildSection(
      title: 'Audio',
      icon: Icons.volume_up,
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.music_note),
          title: const Text('Sonidos'),
          subtitle: const Text('Música y efectos de sonido'),
          value: controller.soundEnabled,
          onChanged: (value) => controller.onSoundToggled(value),
        ),
        if (controller.soundEnabled) ...[
          ListTile(
            leading: const Icon(Icons.volume_up),
            title: const Text('Volumen'),
            subtitle: Slider(
              value: controller.soundVolume,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: '${(controller.soundVolume * 100).round()}%',
              onChanged: (value) => controller.onSoundVolumeChanged(value),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAboutSection(SettingsController controller) {
    return _buildSection(
      title: 'Acerca de',
      icon: Icons.info,
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Acerca de la aplicación'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => controller.onAboutPressed(),
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Términos y condiciones'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => controller.onTermsPressed(),
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Política de privacidad'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => controller.onPrivacyPressed(),
        ),
        ListTile(
          leading: const Icon(Icons.support),
          title: const Text('Soporte'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => controller.onSupportPressed(),
        ),
        ListTile(
          leading: const Icon(Icons.file_download),
          title: const Text('Exportar datos'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => controller.onExportDataPressed(),
        ),
      ],
    );
  }

  Widget _buildAccountSection(SettingsController controller) {
    return _buildSection(
      title: 'Cuenta',
      icon: Icons.account_circle,
      children: [
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            minimumSize: const Size(double.infinity, 48),
          ),
          onPressed: () => controller.onLogoutPressed(),
          child: const Text('Cerrar sesión'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          onPressed: () => controller.onDeleteAccountPressed(),
          child: Text(
            'Eliminar cuenta',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            minimumSize: const Size(double.infinity, 48),
          ),
          onPressed: () => controller.onResetSettingsPressed(),
          child: const Text('Restablecer configuración'),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }



  void _showThemeDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Sistema'),
              value: 'Sistema',
              groupValue: controller.selectedTheme,
              onChanged: (value) {
                if (value != null) {
                  controller.onThemeSelected(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Claro'),
              value: 'Claro',
              groupValue: controller.selectedTheme,
              onChanged: (value) {
                if (value != null) {
                  controller.onThemeSelected(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Oscuro'),
              value: 'Oscuro',
              groupValue: controller.selectedTheme,
              onChanged: (value) {
                if (value != null) {
                  controller.onThemeSelected(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(List<String> languages) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((language) => RadioListTile<String>(
            title: Text(language),
            value: language,
            groupValue: controller.selectedLanguage,
            onChanged: (value) {
              if (value != null) {
                controller.onLanguageSelected(value);
                Navigator.of(context).pop();
              }
            },
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: controller.userName);
    final emailController = TextEditingController(text: controller.userEmail);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar perfil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              controller.onProfileUpdated(
                nameController.text,
                emailController.text,
                controller.userAvatar,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _navigateToAbout() {
    // Navegar a la pantalla de información
    Navigator.of(context).pushNamed('/about');
  }

  void _navigateToTerms() {
    // Navegar a términos y condiciones
    Navigator.of(context).pushNamed('/terms');
  }

  void _navigateToPrivacy() {
    // Navegar a política de privacidad
    Navigator.of(context).pushNamed('/privacy');
  }

  void _navigateToSupport() {
    // Navegar a soporte
    Navigator.of(context).pushNamed('/support');
  }

  void _performLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
            child: Text(
              'Cerrar sesión',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _performDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text(
          'Esta acción no se puede deshacer. Se eliminarán todos tus datos permanentemente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Aquí se implementaría la lógica de eliminación
              _showSuccess('Cuenta programada para eliminación');
            },
            child: Text(
              'Eliminar',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _performDataExport() {
    _showSuccess('Datos exportados correctamente');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _onSettingsUpdated(Map<String, dynamic> settings) {
    // Actualizar la configuración en la vista
    setState(() {
      // Los cambios ya están reflejados en el controller
    });
  }

  void _onProfileUpdated(Map<String, dynamic> profile) {
    // Actualizar el perfil en la vista
    setState(() {
      // Los cambios ya están reflejados en el controller
    });
  }
}