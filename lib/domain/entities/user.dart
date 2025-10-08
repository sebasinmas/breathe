/// Entidad que representa un usuario de la aplicación
/// Contiene información básica del perfil y configuraciones de la app
class User {
  final String id;
  final String? name;
  final String? email;
  final String? photoUrl;
  final bool isAnonymous;
  final bool isPremium;
  final UserPreferences preferences;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  const User({
    required this.id,
    this.name,
    this.email,
    this.photoUrl,
    required this.isAnonymous,
    required this.isPremium,
    required this.preferences,
    required this.createdAt,
    required this.lastLoginAt,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    bool? isAnonymous,
    bool? isPremium,
    UserPreferences? preferences,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isPremium: isPremium ?? this.isPremium,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }
}

/// Preferencias del usuario para personalizar la experiencia
class UserPreferences {
  final String language; // 'es', 'en', etc.
  final String theme; // 'light', 'dark', 'system'
  final bool soundEnabled;
  final double soundVolume;
  final bool notificationsEnabled;
  final String defaultBreathingPattern;

  const UserPreferences({
    required this.language,
    required this.theme,
    required this.soundEnabled,
    required this.soundVolume,
    required this.notificationsEnabled,
    required this.defaultBreathingPattern,
  });

  UserPreferences copyWith({
    String? language,
    String? theme,
    bool? soundEnabled,
    double? soundVolume,
    bool? notificationsEnabled,
    String? defaultBreathingPattern,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      soundVolume: soundVolume ?? this.soundVolume,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      defaultBreathingPattern: defaultBreathingPattern ?? this.defaultBreathingPattern,
    );
  }

  /// Configuración predeterminada para nuevos usuarios
  static const UserPreferences defaultPreferences = UserPreferences(
    language: 'es',
    theme: 'system',
    soundEnabled: true,
    soundVolume: 0.7,
    notificationsEnabled: true,
    defaultBreathingPattern: '4-7-8',
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserPreferences &&
        other.language == language &&
        other.theme == theme &&
        other.soundEnabled == soundEnabled &&
        other.soundVolume == soundVolume &&
        other.notificationsEnabled == notificationsEnabled &&
        other.defaultBreathingPattern == defaultBreathingPattern;
  }

  @override
  int get hashCode {
    return Object.hash(
      language,
      theme,
      soundEnabled,
      soundVolume,
      notificationsEnabled,
      defaultBreathingPattern,
    );
  }
}