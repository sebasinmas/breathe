import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'styles/app_theme.dart';
import 'utils/app_router.dart';

/// Aplicación principal que configura el tema y navegación
/// Utiliza GoRouter para navegación moderna y AppTheme para estilos glassmorphism
class BreatheApp extends StatefulWidget {
  const BreatheApp({super.key});

  @override
  State<BreatheApp> createState() => _BreatheAppState();
}

class _BreatheAppState extends State<BreatheApp> {
  // Notificador para cambios de tema
  final ValueNotifier<ThemeMode> _themeNotifier = ValueNotifier(ThemeMode.system);

  @override
  void dispose() {
    _themeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 13 como referencia
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: _themeNotifier,
          builder: (context, themeMode, child) {
            return MaterialApp.router(
              title: 'Breathe',
              debugShowCheckedModeBanner: false,
              
              // Configuración de tema usando AppTheme
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              
              // Configuración de rutas usando GoRouter
              routerConfig: AppRouter.router,
              
              // Configuración adicional
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!,
                );
              },
            );
          },
        );
      },
    );
  }

  /// Cambia el tema de la aplicación
  void changeTheme(ThemeMode themeMode) {
    _themeNotifier.value = themeMode;
  }
}