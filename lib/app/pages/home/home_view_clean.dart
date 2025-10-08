import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'home_controller.dart';
import 'home_presenter.dart';

/// Vista principal de Home siguiendo Clean Architecture
/// Versión simplificada y funcional
class HomeViewClean extends CleanView {
  const HomeViewClean({super.key});

  @override
  _HomeViewCleanState createState() => _HomeViewCleanState();
}

class _HomeViewCleanState extends CleanViewState<HomeViewClean, HomeController> {
  _HomeViewCleanState() : super(HomeController(HomePresenter()));

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
                
                // Botón de acción principal
                _buildMainActionButton(controller),
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
                  Text(
                    'Hola, ${controller.userName}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Respira y relájate',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => controller.onSettingsPressed(),
                icon: const Icon(Icons.settings),
                iconSize: 28,
              ),
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
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
      ),
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
          () => controller.onExerciseSelected('4-7-8'),
        ),
        
        _buildExerciseCard(
          'Respiración Cuadrada',
          'Equilibra tu sistema nervioso',
          'assets/images/breathing_square.png',
          () => controller.onExerciseSelected('square'),
        ),
        
        _buildExerciseCard(
          'Respiración Triangular',
          'Para principiantes',
          'assets/images/breathing_triangle.png',
          () => controller.onExerciseSelected('triangle'),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(String title, String description, String imagePath, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.7),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.air,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(HomeController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tu Progreso',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.self_improvement, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Meditación',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Próximamente...'),
        ],
      ),
    );
  }

  Widget _buildFavoritesSection(HomeController controller) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Favoritos',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Aún no tienes favoritos'),
        ],
      ),
    );
  }

  Widget _buildMainActionButton(HomeController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () => controller.onStartBreathingExercise(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_arrow, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Text(
              'Comenzar Ejercicio',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}