import 'package:breathe/domain/entities/user.dart';

/// Modelo de datos para User que extiende la entidad del dominio
/// Agrega funcionalidades de serialización para Firebase/API
class UserModel extends User {
  const UserModel({
    required super.id,
    super.name,
    super.email,
    super.photoUrl,
    required super.isAnonymous,
    required super.isPremium,
    required super.preferences,
    required super.createdAt,
    required super.lastLoginAt,
  });

  /// Crea un modelo desde un Map (útil para Firebase/JSON)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String?,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      isPremium: json['isPremium'] as bool? ?? false,
      preferences: UserPreferencesModel.fromJson(
        json['preferences'] as Map<String, dynamic>? ?? {}
      ),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      lastLoginAt: DateTime.tryParse(json['lastLoginAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  /// Crea un modelo desde una entidad del dominio
  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      photoUrl: entity.photoUrl,
      isAnonymous: entity.isAnonymous,
      isPremium: entity.isPremium,
      preferences: UserPreferencesModel.fromEntity(entity.preferences),
      createdAt: entity.createdAt,
      lastLoginAt: entity.lastLoginAt,
    );
  }

  /// Convierte el modelo a Map (útil para Firebase/JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'isAnonymous': isAnonymous,
      'isPremium': isPremium,
      'preferences': (preferences as UserPreferencesModel).toJson(),
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
    };
  }

  /// Crea una copia del modelo con valores modificados
  @override
  UserModel copyWith({
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
    return UserModel(
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
}

/// Modelo de datos para UserPreferences
class UserPreferencesModel extends UserPreferences {
  const UserPreferencesModel({
    required super.language,
    required super.theme,
    required super.soundEnabled,
    required super.soundVolume,
    required super.notificationsEnabled,
    required super.defaultBreathingPattern,
  });

  /// Crea un modelo desde un Map (útil para Firebase/JSON)
  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      language: json['language'] as String? ?? 'es',
      theme: json['theme'] as String? ?? 'system',
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      soundVolume: (json['soundVolume'] as num?)?.toDouble() ?? 0.7,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      defaultBreathingPattern: json['defaultBreathingPattern'] as String? ?? '4-7-8',
    );
  }

  /// Crea un modelo desde una entidad del dominio
  factory UserPreferencesModel.fromEntity(UserPreferences entity) {
    return UserPreferencesModel(
      language: entity.language,
      theme: entity.theme,
      soundEnabled: entity.soundEnabled,
      soundVolume: entity.soundVolume,
      notificationsEnabled: entity.notificationsEnabled,
      defaultBreathingPattern: entity.defaultBreathingPattern,
    );
  }

  /// Convierte el modelo a Map (útil para Firebase/JSON)
  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'theme': theme,
      'soundEnabled': soundEnabled,
      'soundVolume': soundVolume,
      'notificationsEnabled': notificationsEnabled,
      'defaultBreathingPattern': defaultBreathingPattern,
    };
  }

  /// Crea una copia del modelo con valores modificados
  @override
  UserPreferencesModel copyWith({
    String? language,
    String? theme,
    bool? soundEnabled,
    double? soundVolume,
    bool? notificationsEnabled,
    String? defaultBreathingPattern,
  }) {
    return UserPreferencesModel(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      soundVolume: soundVolume ?? this.soundVolume,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      defaultBreathingPattern: defaultBreathingPattern ?? this.defaultBreathingPattern,
    );
  }
}