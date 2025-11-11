import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../styles/app_colors.dart';

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
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              const Color(0xFF0A0A0B), // Más oscuro
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo de la aplicación con glassmorphism
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.air,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Nombre de la aplicación
            Text(
              'Breathe',
              style: GoogleFonts.lato(
                fontSize: 48,
                color: AppColors.foreground,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Subtítulo
            Text(
              'Respiración • Mindfulness • Bienestar',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: AppColors.mutedForeground,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 50),
            
            // Indicador de carga
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 2,
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'Iniciando...',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}