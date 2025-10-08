import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/animations/breathe_transitions.dart';

/// Vista principal de la aplicación con diseño glassmorphism y animaciones fluidas
/// Muestra las tres secciones principales: Respiración, Mindfulness e Inteligencia Emocional
/// 
/// Mejoras implementadas:
/// - Transiciones suaves entre secciones con FadeTransition
/// - Animaciones de entrada staggered para elementos
/// - Microinteracciones con feedback háptico
/// - Hero transitions para navegación fluida
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  late AnimationController _sectionAnimationController;
  late Animation<double> _sectionFadeAnimation;
  bool _animationsInitialized = false; // FIX: Control de inicialización de animaciones

  // Crear las secciones como const para evitar recrearlas en cada build
  static const List<Widget> _staticSections = [
    BreathingSection(),
    MindfulnessSection(),
    EmotionalIntelligenceSection(),
  ];

  @override
  void initState() {
    super.initState();
    
    // FIX: Inicializar PageController inmediatamente
    _pageController = PageController();
    
    // FIX: Inicializar animaciones sincrónicamente para evitar LateInitializationError
    _sectionAnimationController = AnimationController(
      duration: BreatheTransitions.medium,
      vsync: this,
    );
    
    _sectionFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sectionAnimationController,
      curve: BreatheTransitions.easeInOutCubic,
    ));
    
    _animationsInitialized = true;
    
    // Diferir solo el inicio de la animación, no la inicialización
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _sectionAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    // FIX: Dispose seguro de los controladores
    if (_animationsInitialized) {
      _sectionAnimationController.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _onSectionChanged(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      
      // Feedback háptico suave para cambio de sección
      HapticFeedback.selectionClick();
      
      // Animar transición de página
      _pageController.animateToPage(
        index,
        duration: BreatheTransitions.medium,
        curve: BreatheTransitions.easeInOutCubic,
      );
      
      // Animar fade de contenido
      _sectionAnimationController.reset();
      _sectionAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: BreatheTransitions.heroTransition(
          tag: 'app_logo',
          child: Text(
            'Breathe',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          // Botón de notificaciones con microinteracción
          FadeSlideIn(
            delay: const Duration(milliseconds: 300),
            child: InteractiveScale(
              onTap: () {
                // Navegar a notificaciones
              },
              child: GlassIconButton(
                icon: Icons.notifications_outlined,
                onPressed: () {
                  // Navegar a notificaciones
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Botón de configuración con microinteracción y delay
          FadeSlideIn(
            delay: const Duration(milliseconds: 500),
            child: InteractiveScale(
              onTap: () {
                Navigator.of(context).pushNamed('/settings');
              },
              child: GlassIconButton(
                icon: Icons.settings_outlined,
                onPressed: () {
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.8),
              colorScheme.secondary.withOpacity(0.6),
              colorScheme.tertiary.withOpacity(0.4),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header con saludo y estadísticas rápidas con animación staggered
              FadeSlideIn(
                delay: const Duration(milliseconds: 100),
                child: _buildHeader(theme, colorScheme),
              ),
              
              const SizedBox(height: 20),
              
              // Navegación de secciones con animación
              FadeSlideIn(
                delay: const Duration(milliseconds: 200),
                child: _buildSectionTabs(theme, colorScheme),
              ),
              
              const SizedBox(height: 20),
              
              // Contenido de secciones con transición animada
              Expanded(
                child: AnimatedBuilder(
                  animation: _sectionFadeAnimation,
                  builder: (context, child) {
                    // FIX: Usar valor seguro en caso de que la animación no esté inicializada
                    final opacity = _animationsInitialized ? _sectionFadeAnimation.value : 1.0;
                    return Opacity(
                      opacity: opacity,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                          HapticFeedback.selectionClick();
                        },
                        itemCount: _staticSections.length,
                        itemBuilder: (context, index) {
                          return RepaintBoundary(
                            child: FadeSlideIn(
                              delay: const Duration(milliseconds: 300),
                              child: _staticSections[index],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el header con saludo y estadísticas
  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Hola! 👋',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Respira profundo y encuentra tu paz interior',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('7', 'días seguidos', Icons.local_fire_department, colorScheme),
                _buildStatItem('45', 'min hoy', Icons.timer, colorScheme),
                _buildStatItem('12', 'sesiones', Icons.check_circle, colorScheme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construye las pestañas de navegación entre secciones
  Widget _buildSectionTabs(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: InteractiveScale(
              onTap: () => _onSectionChanged(0),
              child: _buildTabItem(
                'Respiración',
                Icons.air,
                0,
                theme,
                colorScheme,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InteractiveScale(
              onTap: () => _onSectionChanged(1),
              child: _buildTabItem(
                'Mindfulness',
                Icons.self_improvement,
                1,
                theme,
                colorScheme,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InteractiveScale(
              onTap: () => _onSectionChanged(2),
              child: _buildTabItem(
                'Emocional',
                Icons.favorite,
                2,
                theme,
                colorScheme,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye un elemento de estadística
  Widget _buildStatItem(String value, String label, IconData icon, ColorScheme colorScheme) {
    return Column(
      children: [
        Icon(icon, color: colorScheme.primary, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// Construye un tab de sección
  Widget _buildTabItem(String title, IconData icon, int index, ThemeData theme, ColorScheme colorScheme) {
    final isSelected = _selectedIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected 
            ? colorScheme.primary.withOpacity(0.3)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: isSelected 
            ? Border.all(color: colorScheme.primary, width: 1.5)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            size: 20,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Sección de ejercicios de respiración con glassmorphism
class BreathingSection extends StatelessWidget {
  const BreathingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ejercicios de Respiración',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Encuentra tu ritmo perfecto y reduce el estrés',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Ejercicios populares con glassmorphism
          _buildExerciseCard(
            context,
            'Respiración 4-7-8',
            'Técnica de relajación profunda',
            Icons.air,
            Colors.blue.shade300,
            '8 ciclos • 5 min',
          ),
          
          const SizedBox(height: 16),
          
          _buildExerciseCard(
            context,
            'Respiración Cuadrada',
            'Equilibra tu sistema nervioso',
            Icons.crop_square,
            Colors.green.shade300,
            '10 ciclos • 6 min',
          ),
          
          const SizedBox(height: 16),
          
          _buildExerciseCard(
            context,
            'Respiración Triángulo',
            'Ideal para principiantes',
            Icons.change_history,
            Colors.orange.shade300,
            '12 ciclos • 4 min',
          ),
          
          const SizedBox(height: 24),
          
          // Botón para crear ejercicio personalizado
          SecondaryButton(
            text: 'Crear Ejercicio Personalizado',
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navegar a crear ejercicio personalizado
            },
            width: double.infinity,
          ),
          
          const SizedBox(height: 100), // Espacio para el FAB
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    String duration,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/breathing-exercise');
      },
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: color, size: 30),
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
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 6),
                  
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    duration,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.6),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

/// Sección de mindfulness con diseño glassmorphism
class MindfulnessSection extends StatelessWidget {
  const MindfulnessSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GlassCard(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.self_improvement,
                size: 80,
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(height: 24),
              Text(
                'Mindfulness',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Próximamente...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Meditaciones guiadas, ejercicios de atención plena y técnicas de relajación mental.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sección de inteligencia emocional con diseño glassmorphism
class EmotionalIntelligenceSection extends StatelessWidget {
  const EmotionalIntelligenceSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GlassCard(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.psychology,
                size: 80,
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(height: 24),
              Text(
                'Inteligencia Emocional',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Próximamente...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Herramientas para desarrollar la conciencia emocional, regulación y bienestar mental.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}