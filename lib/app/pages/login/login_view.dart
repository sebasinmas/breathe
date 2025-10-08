import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/input_field.dart';
import '../../widgets/animations/breathe_transitions.dart';

/// Vista de login/registro con diseño glassmorphism
/// Permite al usuario autenticarse con Google o email/password
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Controladores para los campos de texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Keys para formularios separados
  final _loginFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Maneja el login con Google
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    
    try {
      // Aquí iría la lógica de login con Google
      await Future.delayed(const Duration(seconds: 2)); // Simular delay
      
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      _showErrorSnackBar('Error al iniciar sesión con Google: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Maneja el login con email y contraseña
  Future<void> _signInWithEmail() async {
    if (!_loginFormKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Aquí iría la lógica de login con email
      await Future.delayed(const Duration(seconds: 1)); // Simular delay
      
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      _showErrorSnackBar('Error al iniciar sesión: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Maneja el registro con email y contraseña
  Future<void> _signUpWithEmail() async {
    if (!_signUpFormKey.currentState!.validate()) return;
    
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Las contraseñas no coinciden');
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      // Aquí iría la lógica de registro
      await Future.delayed(const Duration(seconds: 1)); // Simular delay
      
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      _showErrorSnackBar('Error al registrarse: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Muestra un SnackBar con error y feedback háptico
  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    
    // Feedback háptico para indicar error
    HapticFeedback.heavyImpact();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(milliseconds: 4000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      // Clave para evitar overflow del teclado
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Responsive layout
              final isTablet = constraints.maxWidth > 600;
              final contentWidth = isTablet ? 500.0 : double.infinity;
              
              return Center(
                child: SingleChildScrollView(
                  // FIX: Physics mejoradas y padding dinámico
                  physics: const BouncingScrollPhysics(),
                  // Padding dinámico para adaptarse al teclado y dispositivo
                  padding: EdgeInsets.only(
                    left: isTablet ? 0 : 20,
                    right: isTablet ? 0 : 20,
                    top: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 40, // Más espacio inferior
                  ),
                  child: ConstrainedBox(
                    // FIX: Usar ConstrainedBox para mejor control de altura
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 80, // Asegurar altura mínima
                    ),
                    child: Container(
                      width: contentWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // FIX: Evitar conflictos de layout
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Header con logo y título
                          _buildHeader(),
                          
                          const SizedBox(height: 40),
                          
                          // Formulario principal
                          _buildAuthCard(),
                          
                          // FIX: Espacio extra en lugar de Spacer
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Logo con glassmorphism y animación de entrada
        FadeSlideIn(
          delay: const Duration(milliseconds: 200),
          child: InteractiveScale(
            onTap: () {
              HapticFeedback.lightImpact();
            },
            child: GlassCard(
              width: 100,
              height: 100,
              borderRadius: BorderRadius.circular(25),
              child: Icon(
                Icons.air,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Título con animación staggered
        FadeSlideIn(
          delay: const Duration(milliseconds: 400),
          child: Text(
            'Breathe',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Subtítulo con delay adicional
        FadeSlideIn(
          delay: const Duration(milliseconds: 600),
          child: Text(
            'Tu compañero de bienestar',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthCard() {
    return FadeSlideIn(
      delay: const Duration(milliseconds: 800),
      child: GlassFormCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tabs para Login/Registro con microinteracción
            _buildTabBar(),
            
            const SizedBox(height: 24),
            
            // FIX: TabBarView con altura fija para evitar overflow
            SizedBox(
              height: 450, // Altura fija suficiente para todo el contenido
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLoginTab(),
                  _buildSignUpTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: colorScheme.onSurface.withOpacity(0.7),
        indicator: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        onTap: (index) {
          // Feedback háptico suave al cambiar de pestaña
          HapticFeedback.selectionClick();
        },
        tabs: const [
          Tab(
            child: Text(
              'Iniciar Sesión',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Tab(
            child: Text(
              'Registrarse',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginTab() {
    return SingleChildScrollView(
      // FIX: Padding más generoso para evitar que el contenido se corte
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 40, // Más espacio inferior
        left: 0,
        right: 0,
      ),
      physics: const BouncingScrollPhysics(), // Mejor experiencia de scroll
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min, // FIX: Tamaño mínimo para evitar overflow
          children: [
          
          // Email field con animación staggered
          FadeSlideIn(
            delay: const Duration(milliseconds: 200),
            child: EmailField(
              labelText: 'Correo electrónico',
              controller: _emailController,
              onSubmitted: (_) => _signInWithEmail(),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Password field con animación staggered
          FadeSlideIn(
            delay: const Duration(milliseconds: 400),
            child: PasswordField(
              labelText: 'Contraseña',
              controller: _passwordController,
              onSubmitted: (_) => _signInWithEmail(),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Login button con animación
          FadeSlideIn(
            delay: const Duration(milliseconds: 600),
            child: InteractiveScale(
              child: PrimaryButton(
                text: 'Iniciar Sesión',
                onPressed: _isLoading ? null : _signInWithEmail,
                isLoading: _isLoading,
                width: double.infinity,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Separador con animación
          FadeSlideIn(
            delay: const Duration(milliseconds: 800),
            child: Text(
              'o',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Google button con animación final
          FadeSlideIn(
            delay: const Duration(milliseconds: 1000),
            child: InteractiveScale(
              child: SecondaryButton(
                text: 'Continuar con Google',
                icon: const Icon(Icons.login),
                onPressed: _isLoading ? null : _signInWithGoogle,
                width: double.infinity,
              ),
            ),
          ),
          
          // FIX: Espacio adicional al final para asegurar visibilidad completa
          const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpTab() {
    return SingleChildScrollView(
      // FIX: Padding más generoso para evitar que el contenido se corte
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 40, // Más espacio inferior
        left: 0,
        right: 0,
      ),
      physics: const BouncingScrollPhysics(), // Mejor experiencia de scroll
      child: Form(
        key: _signUpFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min, // FIX: Tamaño mínimo para evitar overflow
          children: [
          
          // Name field con animación staggered
          FadeSlideIn(
            delay: const Duration(milliseconds: 200),
            child: InputField(
              labelText: 'Nombre completo',
              hintText: 'Ingresa tu nombre',
              controller: _nameController,
              prefixIcon: const Icon(Icons.person_outline),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu nombre';
                }
                if (value.length < 2) {
                  return 'El nombre debe tener al menos 2 caracteres';
                }
                return null;
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Email field con animación
          FadeSlideIn(
            delay: const Duration(milliseconds: 400),
            child: EmailField(
              labelText: 'Correo electrónico',
              controller: _emailController,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Password field con animación
          FadeSlideIn(
            delay: const Duration(milliseconds: 600),
            child: PasswordField(
              labelText: 'Contraseña',
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa una contraseña';
                }
                if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Confirm password field con animación
          FadeSlideIn(
            delay: const Duration(milliseconds: 800),
            child: PasswordField(
              labelText: 'Confirmar contraseña',
              hintText: 'Confirma tu contraseña',
              controller: _confirmPasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor confirma tu contraseña';
                }
                if (value != _passwordController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Sign up button con animación
          FadeSlideIn(
            delay: const Duration(milliseconds: 1000),
            child: InteractiveScale(
              child: PrimaryButton(
                text: 'Crear Cuenta',
                onPressed: _isLoading ? null : _signUpWithEmail,
                isLoading: _isLoading,
                width: double.infinity,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Separador con animación
          FadeSlideIn(
            delay: const Duration(milliseconds: 1200),
            child: Text(
              'o',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Google button con animación final
          FadeSlideIn(
            delay: const Duration(milliseconds: 1400),
            child: InteractiveScale(
              child: SecondaryButton(
                text: 'Registrarse con Google',
                icon: const Icon(Icons.login),
                onPressed: _isLoading ? null : _signInWithGoogle,
                width: double.infinity,
              ),
            ),
          ),
          
          // FIX: Espacio adicional al final para asegurar visibilidad completa
          const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}