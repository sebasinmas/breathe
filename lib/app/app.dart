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
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 13 como referencia
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Breathe',
          debugShowCheckedModeBanner: false,
          
          // Configuración de tema usando AppTheme con Shadcn Dark
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark, // Forzamos dark mode
          
          // Configuración de rutas usando GoRouter
          routerConfig: AppRouter.router,
          
          // Configuración adicional
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
              child: child!,
            );
          },
        );
      },
    );
  }
}