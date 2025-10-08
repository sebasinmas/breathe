import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:breathe/app/app.dart';
// import 'package:breathe/data/repositories/mock/mock_breathing_exercise_repository.dart';
// import 'package:breathe/data/repositories/mock/mock_user_repository.dart';

/// Punto de entrada principal de la aplicación Breathe
/// Configura los logs, inicializa dependencias y ejecuta la app
void main() async {
  // Asegurar que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar la orientación de la pantalla de manera asíncrona
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Configurar los logs para desarrollo (no bloquear el main thread)
  Future.microtask(() => _initializeLogging());
  
  // Ejecutar la aplicación inmediatamente
  runApp(const BreatheApp());
  
  // Inicializar dependencias después del primer frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _initializeDependencies();
  });
}

/// Configura el sistema de logging para desarrollo
void _initializeLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // En desarrollo mostramos todos los logs
    // En producción esto debería ser más selectivo
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    
    // Si hay un error, también mostrar el stack trace
    if (record.error != null) {
      debugPrint('Error: ${record.error}');
    }
    if (record.stackTrace != null) {
      debugPrint('Stack trace: ${record.stackTrace}');
    }
  });
  
  Logger('main').info('Sistema de logging inicializado');
}

/// Inicializa las dependencias de la aplicación
/// En un proyecto real, aquí configuraríamos get_it para inyección de dependencias
void _initializeDependencies() {
  final logger = Logger('Dependencies');
  
  try {
    // Inicializar repositorios mock
    // En un caso real, aquí configuraríamos Firebase y otros servicios
    
    // Crear instancias de repositorios (actualmente no se usan directamente)
    // En el futuro, estos se registrarían en get_it para inyección de dependencias
    // final breathingRepo = MockBreathingExerciseRepository();
    // final userRepo = MockUserRepository();
    
    logger.info('Repositorios mock inicializados');
    
    // Aquí configuraríamos get_it:
    // GetIt.instance.registerSingleton<BreathingExerciseRepository>(breathingRepo);
    // GetIt.instance.registerSingleton<UserRepository>(userRepo);
    
    logger.info('Dependencias inicializadas correctamente');
    
  } catch (e, stackTrace) {
    logger.severe('Error al inicializar dependencias', e, stackTrace);
    // En un caso real, podríamos mostrar un error al usuario
    // o usar un repositorio offline como fallback
  }
}

/// Configuración global de la aplicación
class AppConfig {
  static const String appName = 'Breathe';
  static const String version = '1.0.0';
  static const bool isDebugMode = true; // En producción esto sería false
  
  // URLs de la API (cuando se implemente)
  static const String baseUrl = 'https://api.breathe.com';
  static const String apiVersion = 'v1';
  
  // Configuración de Firebase (cuando se implemente)
  static const String firebaseProjectId = 'breathe-app';
  
  // Configuración de analytics (cuando se implemente)
  static const bool analyticsEnabled = false;
  static const bool crashlyticsEnabled = false;
}
