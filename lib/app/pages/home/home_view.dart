import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import '../../../app/styles/app_theme.dart';
import 'home_controller.dart';

/// Vista principal de Home siguiendo Clean Architecture
/// Versión simplificada y funcional
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
      body: ControlledWidgetBuilder<HomeController>(
        builder: (context, controller) {
          return SafeArea(
            child: Column(
              children: [
                // Header con saludo y estadísticas
                _buildHeader(controller),
                
                // Navegación de secciones
                _buildSectionNavigation(controller),
                
                // Contenido principal
                Expanded(
                  child: _buildMainContent(controller),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(HomeController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.white.withOpacity(0.8),
                    highlightColor: Colors.white,
                    child: Text(
                      'Hola, ${controller.userName}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ).animate()
                    .fadeIn(duration: 800.ms)
                    .slideX(begin: -0.3, end: 0),
                  Text(
                    'Respira y relájate',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ).animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms)
                    .slideX(begin: -0.2, end: 0),
                ],
              ),
              IconButton(
                onPressed: () => controller.onSettingsPressed(),
                icon: const Icon(Icons.settings),
                iconSize: 28,
              ).animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .rotate(delay: 1000.ms, duration: 800.ms),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Estadísticas rápidas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                'Sesiones',
                '${controller.totalSessions}',
                Icons.play_circle,
                Colors.blue,
              ),
              _buildStatCard(
                'Minutos',
                '${controller.totalMinutes}',
                Icons.timer,
                Colors.green,
              ),
              _buildStatCard(
                'Racha',
                '${controller.currentStreak} días',
                Icons.local_fire_department,
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.lightGlass,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: color.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: color, size: 22),
            ).animate()
              .scale(delay: 400.ms, duration: 500.ms)
              .then()
              .shimmer(delay: 1000.ms, duration: 2000.ms),
            
            const SizedBox(height: 12),
            
            Text(
              value,
              style: AppTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: -0.5,
              ),
            ).animate()
              .fadeIn(delay: 600.ms, duration: 400.ms)
              .slideY(begin: 0.3, end: 0),
            
            Text(
              title,
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ).animate()
              .fadeIn(delay: 700.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0),
          ],
        ),
      ).animate()
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.5, end: 0, duration: 800.ms),
    );
  }

  Widget _buildSectionNavigation(HomeController controller) {
    return Container(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildSectionTab('Ejercicios', 0, controller),
          _buildSectionTab('Progreso', 1, controller),
          _buildSectionTab('Meditación', 2, controller),
          _buildSectionTab('Favoritos', 3, controller),
        ],
      ),
    );
  }

  Widget _buildSectionTab(String title, int index, HomeController controller) {
    final isSelected = controller.currentSection == index;
    
    return GestureDetector(
      onTap: () => controller.onSectionChanged(index),
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ).animate()
        .fadeIn(delay: (index * 100).ms, duration: 500.ms)
        .slideX(begin: 0.3, end: 0),
    );
  }

  Widget _buildMainContent(HomeController controller) {
    switch (controller.currentSection) {
      case 0:
        return _buildExercisesSection(controller);
      case 1:
        return _buildProgressSection(controller);
      case 2:
        return _buildMeditationSection(controller);
      case 3:
        return _buildFavoritesSection(controller);
      default:
        return _buildExercisesSection(controller);
    }
  }

  Widget _buildExercisesSection(HomeController controller) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Ejercicios de Respiración',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        _buildExerciseCard(
          'Respiración 4-7-8',
          'Técnica para relajación profunda',
          'assets/images/breathing_478.png',
          () => controller.onStartBreathingExercise(),
        ),
        
        _buildExerciseCard(
          'Respiración Cuadrada',
          'Equilibra tu sistema nervioso',
          'assets/images/breathing_square.png',
          () => controller.onStartBreathingExercise(),
        ),
        
        _buildExerciseCard(
          'Respiración Triangular',
          'Para principiantes',
          'assets/images/breathing_triangle.png',
          () => controller.onStartBreathingExercise(),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(String title, String description, String imagePath, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.lightGlass,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryBlue.withOpacity(0.8),
                        AppTheme.mintGreen.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.air,
                    color: Colors.white,
                    size: 32,
                  ),
                ).animate()
                  .scale(delay: 200.ms, duration: 300.ms)
                  .then()
                  .shimmer(delay: 800.ms, duration: 1200.ms),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.charcoal,
                        ),
                      ).animate()
                        .fadeIn(delay: 100.ms, duration: 400.ms)
                        .slideX(begin: 0.2, end: 0),
                      
                      const SizedBox(height: 4),
                      
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.darkGlass,
                        ),
                      ).animate()
                        .fadeIn(delay: 200.ms, duration: 400.ms)
                        .slideX(begin: 0.3, end: 0),
                    ],
                  ),
                ),
                
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.darkGlass,
                  size: 20,
                ).animate()
                  .fadeIn(delay: 300.ms, duration: 400.ms)
                  .slideX(begin: 0.5, end: 0),
              ],
            ),
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: 600.ms)
      .slideY(begin: 0.3, end: 0, duration: 600.ms);
  }

  Widget _buildProgressSection(HomeController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tu Progreso',
            style: AppTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 24),
          
          // Progreso semanal
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Esta Semana',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: controller.weeklyProgress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(controller.weeklyProgress * 100).round()}% completado',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Logros recientes
          Text(
            'Logros Recientes',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildAchievementItem('Primera sesión completada', Icons.star),
          _buildAchievementItem('3 días consecutivos', Icons.local_fire_department),
          _buildAchievementItem('10 minutos totales', Icons.timer),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }

  Widget _buildMeditationSection(HomeController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meditación',
            style: AppTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(
                      color: AppTheme.lightGlass,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.self_improvement,
                    size: 60,
                    color: AppTheme.mintGreen,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Próximamente',
                  style: AppTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.darkGlass,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Estamos preparando ejercicios de\nmeditación para ti',
                  textAlign: TextAlign.center,
                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.darkGlass.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesSection(HomeController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Favoritos',
            style: AppTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(
                      color: AppTheme.lightGlass,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite_outline,
                    size: 60,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Aún no tienes favoritos',
                  style: AppTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.darkGlass,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Guarda tus ejercicios favoritos\npara acceder rápidamente',
                  textAlign: TextAlign.center,
                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.darkGlass.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}