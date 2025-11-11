import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/input_field.dart';
import '../../widgets/animations/breathe_transitions.dart';
import 'login_controller.dart';
import '../../../domain/usecases/authenticate_user_usecase.dart';
import '../../../data/repositories/mock/mock_user_repository.dart';

/// Vista de login/registro con diseño glassmorphism siguiendo Clean Architecture
/// Solo maneja UI, delega lógica al Controller
class LoginPage extends CleanView {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends CleanViewState<LoginPage, LoginController> 
    with SingleTickerProviderStateMixin {
  
  TabController? _tabController;
  
  // Controladores para los campos de texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Keys para formularios separados
  final _loginFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  // Constructor que inicializa el controller
  _LoginViewState() : super(LoginController(
    AuthenticateUserUseCase(MockUserRepository())
  ));

  /// Getter que inicializa el TabController lazy
  TabController get tabController {
    _tabController ??= TabController(length: 2, vsync: this);
    return _tabController!;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Maneja el login con Google
  void _signInWithGoogle(LoginController loginController) {
    loginController.authenticateWithGoogle();
  }

  /// Maneja el login con email y contraseña
  void _signInWithEmail(LoginController loginController) {
    if (!_loginFormKey.currentState!.validate()) return;
    
    loginController.authenticateWithEmail(
      _emailController.text,
      _passwordController.text,
    );
  }

  /// Maneja el registro con email y contraseña
  void _signUpWithEmail(LoginController loginController) {
    if (!_signUpFormKey.currentState!.validate()) return;
    
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Las contraseñas no coinciden');
      return;
    }
    
    loginController.registerUser(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );
  }

  /// Verifica el resultado de la autenticación
  void _checkAuthenticationResult(LoginController loginController) {
    // Si hay usuario autenticado, la navegación se maneja en el controller
    // Solo mostrar mensajes de error aquí
    if (loginController.errorMessage != null) {
      _showErrorSnackBar(loginController.errorMessage!);
      loginController.clearError();
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
  Widget get view {
    return Scaffold(
      key: globalKey,
      resizeToAvoidBottomInset: true,
      body: ControlledWidgetBuilder<LoginController>(
        builder: (context, loginController) {
          // Verificar resultado de autenticación cuando el estado cambie
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkAuthenticationResult(loginController);
          });
          
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0F172A), // Slate 900
                  const Color(0xFF1E293B), // Slate 800
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildAuthCard(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
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
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.2),
                    Colors.white.withValues(alpha: 0.1),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
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
            'Bienvenido a Breathe',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Subtítulo con delay adicional
        FadeSlideIn(
          delay: const Duration(milliseconds: 600),
          child: Text(
            'Encuentra tu paz interior',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
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
          children: [
            _buildTabBar(),
            const SizedBox(height: 24),
            SizedBox(
              height: 400, // FIX: Altura fija para evitar problemas de layout
              child: TabBarView(
                controller: tabController,
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
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: tabController,
        labelColor: Colors.white,
        unselectedLabelColor: colorScheme.onSurface.withValues(alpha:0.7),
        indicator: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        onTap: (index) {
          // Feedback háptico al cambiar de tab
          HapticFeedback.selectionClick();
        },
        tabs: const [
          Tab(
            icon: Icon(Icons.login),
            text: 'Iniciar Sesión',
          ),
          Tab(
            icon: Icon(Icons.person_add),
            text: 'Registrarse',
          ),
        ],
      ),
    );
  }

  Widget _buildLoginTab() {
    return ControlledWidgetBuilder<LoginController>(
      builder: (context, loginController) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 40,
            left: 0,
            right: 0,
          ),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _loginFormKey,
            child: Column(
              children: [
                InputField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'tu@email.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.email_outlined),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Ingresa tu email';
                    if (!value!.contains('@')) return 'Email inválido';
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                InputField(
                  controller: _passwordController,
                  labelText: 'Contraseña',
                  hintText: 'Tu contraseña',
                  obscureText: true,
                  prefixIcon: Icon(Icons.lock_outline),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Ingresa tu contraseña';
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Botón de login principal
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Iniciar Sesión',
                    onPressed: loginController.isLoading ? null : () => _signInWithEmail(loginController),
                    isLoading: loginController.isLoading,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Divisor
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.3))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'O continúa con',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.3))),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Botón de Google
                SizedBox(
                  width: double.infinity,
                  child: SecondaryButton(
                    text: 'Continuar con Google',
                    onPressed: () => _signInWithGoogle(loginController),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignUpTab() {
    return ControlledWidgetBuilder<LoginController>(
      builder: (context, loginController) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 40,
            left: 0,
            right: 0,
          ),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _signUpFormKey,
            child: Column(
              children: [
                InputField(
                  controller: _nameController,
                  labelText: 'Nombre',
                  hintText: 'Tu nombre completo',
                  keyboardType: TextInputType.name,
                  prefixIcon: Icon(Icons.person_outline),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Ingresa tu nombre';
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                InputField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'tu@email.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.email_outlined),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Ingresa tu email';
                    if (!value!.contains('@')) return 'Email inválido';
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                InputField(
                  controller: _passwordController,
                  labelText: 'Contraseña',
                  hintText: 'Mínimo 6 caracteres',
                  obscureText: true,
                  prefixIcon: Icon(Icons.lock_outline),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Ingresa una contraseña';
                    if (value!.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                InputField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirmar Contraseña',
                  hintText: 'Repite tu contraseña',
                  obscureText: true,
                  prefixIcon: Icon(Icons.lock_outline),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Confirma tu contraseña';
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Botón de registro principal
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Registrarse',
                    onPressed: loginController.isLoading ? null : () => _signUpWithEmail(loginController),
                    isLoading: loginController.isLoading,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Divisor
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.3))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'O continúa con',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.3))),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Botón de Google
                SizedBox(
                  width: double.infinity,
                  child: SecondaryButton(
                    text: 'Continuar con Google',
                    onPressed: () => _signInWithGoogle(loginController),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}