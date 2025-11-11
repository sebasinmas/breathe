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

  /// Header con saludo personalizado y acciones rápidas
  /// Nielsen #1: Visibilidad del estado - Muestra hora del día y estado
  /// Nielsen #6: Reconocimiento - Saludo contextual visible
  Widget _buildHeader() {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 
        ? '☀️ Buenos días' 
        : hour < 18 
            ? '🌤️ Buenas tardes' 
            : '🌙 Buenas noches';
    
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saludo contextual con hora del día
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.foreground,
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                      ),
                    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                    
                    const SizedBox(height: 4),
                    
                    // Nielsen #2: Correspondencia con mundo real - Lenguaje natural
                    Text(
                      'Tómate un momento para respirar',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.mutedForeground,
                        fontSize: 15,
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
                  ],
                ),
              ),
              
              // Nielsen #7: Flexibilidad - Acceso rápido a configuración
              Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: AppColors.mutedForeground,
                  ),
                  onPressed: () {
                    context.push('/settings');
                  },
                  tooltip: 'Configuración',
                ),
              ).animate().fadeIn(duration: 600.ms).scale(),
            ],
          ),
        ],
      ),
    );
  }

  /// Cards de estadísticas principales
  /// Nielsen #1: Visibilidad - Muestra progreso claramente
  /// Nielsen #8: Diseño minimalista - Solo métricas importantes
  Widget _buildStatsCards() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          // Título de sección con ícono descriptivo
          Row(
            children: [
              Icon(
                Icons.insights,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Tu Progreso Hoy',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.foreground,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Nielsen #4: Consistencia - Layout predecible en grid
          Row(
            children: [
              // Card de sesiones - Nielsen #6: Reconocimiento visual con íconos
              Expanded(
                child: _buildStatCard(
                  icon: Icons.self_improvement,
                  iconColor: AppColors.primary,
                  value: '3',
                  label: 'Sesiones hoy',
                  trend: '+1',
                  trendPositive: true,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Card de minutos totales
              Expanded(
                child: _buildStatCard(
                  icon: Icons.access_time_filled,
                  iconColor: AppColors.secondary,
                  value: '24',
                  label: 'Minutos hoy',
                  unit: 'min',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Card grande de racha - Nielsen #5: Prevención - Motiva continuidad
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // TODO: Navegar a detalles de racha
              },
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.local_fire_department,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '14',
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 36,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    'días',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '¡Sigue así! Tu racha va excelente',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Nielsen #7: Flexibilidad - Acceso rápido a detalles
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 300.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }

  /// Widget helper para cards de estadísticas
  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    String? unit,
    String? trend,
    bool? trendPositive,
  }) {
    return Container(
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
          // Ícono con badge de tendencia
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (trendPositive ?? true)
                        ? AppColors.success.withValues(alpha: 0.15)
                        : AppColors.destructive.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trend,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: (trendPositive ?? true)
                          ? AppColors.success
                          : AppColors.destructive,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Valor principal
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.foreground,
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    unit,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedForeground,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          // Label descriptivo
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.mutedForeground,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2);
  }

  /// Sección de ejercicios de respiración
  /// Nielsen #2: Mundo real - Usa metáforas visuales claras (íconos)
  /// Nielsen #7: Eficiencia - Acceso directo a ejercicios más usados
  Widget _buildBreathingSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título con ícono y acción secundaria
          Row(
            children: [
              Icon(
                Icons.air,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Ejercicios Guiados',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.foreground,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              // Nielsen #7: Flexibilidad - Ver todos los ejercicios
              TextButton(
                onPressed: () {
                  context.push('/breathing');
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ver todos',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Nielsen #8: Minimalismo - Solo 3 ejercicios principales
          // Nielsen #6: Reconocimiento - Cards visuales descriptivas
          Column(
            children: [
              _buildExerciseCardHorizontal(
                title: '4-7-8 Respiración',
                subtitle: 'Ideal para dormir • Reduce ansiedad',
                duration: '5 min',
                icon: Icons.bedtime,
                iconBg: AppColors.primary,
                difficulty: 'Principiante',
                onTap: () {
                  context.push('/breathing');
                },
              ),
              const SizedBox(height: 12),
              _buildExerciseCardHorizontal(
                title: 'Box Breathing',
                subtitle: 'Mejora concentración • Calma mental',
                duration: '8 min',
                icon: Icons.center_focus_strong,
                iconBg: AppColors.secondary,
                difficulty: 'Intermedio',
                onTap: () {
                  context.push('/breathing');
                },
              ),
              const SizedBox(height: 12),
              _buildExerciseCardHorizontal(
                title: 'Coherencia Cardíaca',
                subtitle: 'Equilibrio emocional • Bienestar',
                duration: '10 min',
                icon: Icons.favorite,
                iconBg: AppColors.accent,
                difficulty: 'Todos',
                onTap: () {
                  context.push('/breathing');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Card horizontal de ejercicio - Diseño mejorado según Nielsen
  /// Nielsen #3: Control - Botones claros y reversibles
  /// Nielsen #6: Reconocimiento - Info visual completa sin necesidad de recordar
  Widget _buildExerciseCardHorizontal({
    required String title,
    required String subtitle,
    required String duration,
    required IconData icon,
    required Color iconBg,
    required String difficulty,
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
          child: Row(
            children: [
              // Ícono grande descriptivo
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: iconBg.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconBg,
                  size: 28,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Información del ejercicio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título del ejercicio
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.foreground,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Descripción de beneficios
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                        fontSize: 13,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Metadata: duración y dificultad
                    Row(
                      children: [
                        // Badge de duración
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: iconBg.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 12,
                                color: iconBg,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                duration,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: iconBg,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Badge de dificultad
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.muted,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            difficulty,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.mutedForeground,
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Nielsen #3: Control - Botón de acción claro
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: iconBg,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1);
  }

  /// Sección de progreso y logros
  /// Nielsen #1: Visibilidad - Muestra progreso claramente
  /// Nielsen #10: Ayuda - Consejos contextuales para motivar
  Widget _buildProgressSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título con ícono
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: AppColors.warning,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Tus Logros',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.foreground,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Card motivacional con próximo hito
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
                    Icon(
                      Icons.star_border,
                      color: AppColors.warning,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Próximo logro',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.foreground,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Maestro de la Respiración • 15 días',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.mutedForeground,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Nielsen #1: Visibilidad - Barra de progreso clara
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 14 / 15,
                    minHeight: 8,
                    backgroundColor: AppColors.muted,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.warning),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '¡Solo 1 día más! 🎉',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.2),
          
          const SizedBox(height: 16),
          
          // Nielsen #10: Ayuda contextual - Consejo del día
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Consejo del día',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Practica antes de dormir para mejorar la calidad del sueño',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.foreground,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
          
          const SizedBox(height: 20),
          
          // Progreso semanal - Gráfico simple
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