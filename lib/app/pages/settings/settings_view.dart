import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:go_router/go_router.dart';
import 'settings_controller.dart';

/// Vista de configuración siguiendo Clean Architecture
/// Versión simplificada y funcional
class SettingsPage extends CleanView {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends CleanViewState<SettingsPage, SettingsController> {
  _SettingsPageState() : super(SettingsController());

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: const Text('Configuración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ControlledWidgetBuilder<SettingsController>(
        builder: (context, controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección de Perfil
                _buildSection(
                  title: 'Perfil',
                  icon: Icons.person,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: controller.userAvatar != null 
                          ? null
                          : const Icon(Icons.person),
                      backgroundImage: controller.userAvatar != null 
                          ? NetworkImage(controller.userAvatar!)
                          : null,
                    ),
                    title: Text(controller.userName),
                    subtitle: Text(controller.userEmail),
                    trailing: const Icon(Icons.edit),
                    onTap: () => _showEditProfileDialog(controller),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Sección de Apariencia
                _buildSection(
                  title: 'Apariencia',
                  icon: Icons.palette,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.brightness_6),
                        title: const Text('Tema'),
                        subtitle: Text(controller.selectedTheme),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showThemeDialog(controller),
                      ),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: const Text('Idioma'),
                        subtitle: Text(controller.selectedLanguage),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showLanguageDialog(controller),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Sección de Notificaciones
                _buildSection(
                  title: 'Notificaciones',
                  icon: Icons.notifications,
                  child: SwitchListTile(
                    secondary: const Icon(Icons.notifications_active),
                    title: const Text('Notificaciones'),
                    subtitle: const Text('Recibir recordatorios y actualizaciones'),
                    value: controller.notificationsEnabled,
                    onChanged: (value) => controller.onNotificationsToggled(value),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Sección de Audio
                _buildSection(
                  title: 'Audio',
                  icon: Icons.volume_up,
                  child: Column(
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
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Sección Acerca de
                _buildSection(
                  title: 'Acerca de',
                  icon: Icons.info,
                  child: Column(
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
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Sección de Cuenta
                _buildSection(
                  title: 'Cuenta',
                  icon: Icons.account_circle,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: () => _showLogoutConfirmation(controller),
                        child: const Text('Cerrar sesión'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          side: BorderSide(color: Theme.of(context).colorScheme.error),
                        ),
                        onPressed: () => _showDeleteAccountConfirmation(controller),
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
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
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
            child,
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar tema'),
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
                  context.pop();
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
                  context.pop();
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
                  context.pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(SettingsController controller) {
    final languages = ['Español', 'English', 'Français', 'Português'];
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
                context.pop();
              }
            },
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(SettingsController controller) {
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
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              controller.onProfileUpdated(
                nameController.text,
                emailController.text,
                controller.userAvatar,
              );
              context.pop();
              _showSuccess('Perfil actualizado correctamente');
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              controller.onLogoutPressed();
              context.go('/login');
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

  void _showDeleteAccountConfirmation(SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text(
          'Esta acción no se puede deshacer. Se eliminarán todos tus datos permanentemente.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              controller.onDeleteAccountPressed();
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

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
