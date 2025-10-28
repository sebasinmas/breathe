import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../app/styles/app_colors.dart';
import 'home_controller.dart';

/// Vista principal de Home siguiendo Clean Architecture
/// Diseño Shadcn dark sin glassmorphism para evitar conflictos
class HomePage extends CleanView {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends CleanViewState<HomePage, HomeController> {
  _HomePageState() : super(HomeController());

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      backgroundColor: AppColors.background,
      body: ControlledWidgetBuilder<HomeController>(
        builder: (context, controller) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Header con saludo personalizado
                  _buildHeader(),
                  
                  // Cards de estadísticas principales
                  _buildStatsCards(),
                  
                  // Sección de ejercicios de respiración
                  _buildBreathingSection(),
                  
                  // Sección de progreso y logros
                  _buildProgressSection(),
                  
                  // Spacing inferior
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Header con saludo personalizado y animaciones
  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saludo principal
          Text(
            'Hola, respiremos juntos',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.foreground,
              fontWeight: FontWeight.w700,
            ),
          ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
          
          const SizedBox(height: 8),
          
          // Subtítulo motivacional
          Text(
            'Tu viaje hacia la calma interior',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.mutedForeground,
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
          
          const SizedBox(height: 24),
          
          // Quote inspiracional en card simple
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.border,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.format_quote,
                  color: AppColors.primary,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'La respiración es la conexión entre la mente y el cuerpo',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.foreground,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '— Sadhguru',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 1000.ms, delay: 400.ms).scale(begin: const Offset(0.8, 0.8)),
        ],
      ),
    );
  }

  /// Cards de estadísticas principales
  Widget _buildStatsCards() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Título de sección
          Row(
            children: [
              Text(
                'Tu Progreso',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Navegar a estadísticas detalladas
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ver todo',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.primary,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Grid de estadísticas
          Row(
            children: [
              // Card de sesiones completadas
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.air,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.trending_up,
                            color: AppColors.success,
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '127',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.foreground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sesiones completadas',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 800.ms, delay: 600.ms).slideY(begin: 0.3),
              ),
              
              const SizedBox(width: 12),
              
              // Card de racha actual
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.local_fire_department,
                              color: AppColors.secondary,
                              size: 20,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '+2',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '14',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.foreground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Días consecutivos',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 800.ms, delay: 700.ms).slideY(begin: 0.3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Sección de ejercicios de respiración
  Widget _buildBreathingSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          
          // Título de sección
          Text(
            'Ejercicios de Respiración',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Grid de ejercicios
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
            children: [
              _buildExerciseCard(
                title: '4-7-8',
                subtitle: 'Relajación profunda',
                duration: '5 min',
                icon: Icons.nights_stay,
                color: AppColors.primary,
                onTap: () {
                  context.push('/breathing-exercise');
                },
              ),
              _buildExerciseCard(
                title: 'Box Breathing',
                subtitle: 'Concentración',
                duration: '8 min',
                icon: Icons.crop_square,
                color: AppColors.secondary,
                onTap: () {
                  context.push('/breathing-exercise');
                },
              ),
              _buildExerciseCard(
                title: 'Respiración Calmante',
                subtitle: 'Reducir ansiedad',
                duration: '10 min',
                icon: Icons.spa,
                color: AppColors.accent,
                onTap: () {
                  context.push('/breathing-exercise');
                },
              ),
              _buildExerciseCard(
                title: 'Energizante',
                subtitle: 'Aumentar energía',
                duration: '6 min',
                icon: Icons.bolt,
                color: AppColors.warning,
                onTap: () {
                  context.push('/breathing-exercise');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Card individual de ejercicio
  Widget _buildExerciseCard({
    required String title,
    required String subtitle,
    required String duration,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon y duración
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.muted,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      duration,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.mutedForeground,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Título
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Subtítulo
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
              
              const Spacer(),
              
              // Botón de acción
              Row(
                children: [
                  Icon(
                    Icons.play_circle_filled,
                    color: color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Iniciar',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 1000.ms).scale(begin: const Offset(0.9, 0.9));
  }

  /// Sección de progreso y logros
  Widget _buildProgressSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          
          // Título de sección
          Text(
            'Logros y Progreso',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Progreso semanal
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.border,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Progreso de esta semana',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '5/7 días',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Barra de progreso
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.muted,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 5/7,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Días de la semana
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['L', 'M', 'X', 'J', 'V', 'S', 'D'].asMap().entries.map((entry) {
                    final index = entry.key;
                    final day = entry.value;
                    final isCompleted = index < 5; // Primeros 5 días completados
                    
                    return Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isCompleted 
                            ? AppColors.primary.withValues(alpha: 0.2)
                            : AppColors.muted,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: isCompleted
                            ? Icon(
                                Icons.check,
                                color: AppColors.primary,
                                size: 16,
                              )
                            : Text(
                                day,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.mutedForeground,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 1200.ms),
        ],
      ),
    );
  }
}