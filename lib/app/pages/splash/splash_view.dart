import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Vista de splash screen
/// Muestra el logo de la app y verifica el estado de autenticación
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Esperar 2 segundos antes de verificar autenticación
    Future.delayed(const Duration(seconds: 2), () {
      _checkAuthentication();
    });
  }

  void _checkAuthentication() {
    // Aquí iría la lógica de verificación de autenticación
    // Por ahora simularemos navegación a login
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo de la aplicación
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.air, // Icono temporal para respiración
                size: 60,
                color: Colors.blue,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Nombre de la aplicación
            Text(
              'Breathe',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Subtítulo
            Text(
              'Respiración • Mindfulness • Bienestar',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.8),
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 50),
            
            // Indicador de carga
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'Iniciando...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}