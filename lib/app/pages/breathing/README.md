# 🫁 Módulo de Ejercicios de Respiración - Documentación Completa

## 📋 Resumen de Implementación

Se ha implementado un módulo completo de ejercicios de respiración siguiendo **Clean Architecture** con las siguientes características:

### ✅ Arquitectura Implementada

```
lib/
├── domain/                         # Capa de dominio (entidades y casos de uso)
│   ├── entities/
│   │   ├── breathing_step_type.dart       # Enum: inhale, hold, exhale, holdOut
│   │   ├── breathing_step.dart            # Entidad de paso individual
│   │   └── breathing_exercise.dart        # Entidad de ejercicio completo
│   ├── repositories/
│   │   └── i_breathing_repository.dart    # Interfaz del repositorio
│   └── usecases/
│       └── get_breathing_exercises.dart   # Caso de uso para obtener ejercicios
│
├── data/                           # Capa de datos
│   ├── models/
│   │   ├── breathing_step_model.dart      # Modelo con JSON serialization
│   │   └── breathing_exercise_model.dart  # Modelo con JSON serialization
│   └── repositories/
│       └── breathing_repository_impl.dart # Implementación con 6 ejercicios hardcoded
│
└── app/pages/breathing/            # Capa de presentación
    ├── breathing_state.dart                # Estado inmutable con Freezed
    ├── breathing_cubit.dart                # Lógica de negocio (timer, navegación)
    ├── breathing_page.dart                 # Página principal con BlocProvider
    └── widgets/
        ├── exercise_selection_list.dart    # Lista animada de ejercicios
        └── breathing_animation_view.dart   # Vista de animación activa
```

---

## 🎯 Funcionalidades Implementadas

### 1. Gestión de Estado (flutter_bloc + freezed)
- **BreathingCubit**: 
  - Timer con ticks cada 50ms (20 FPS) para animaciones fluidas
  - Control de ejercicios: start, pause, reset
  - Navegación entre pasos: next, previous
  - Carga de ejercicios desde repositorio
  
- **BreathingState** (immutable con freezed):
  - `status`: initial, loading, loaded, running, paused, finished, error
  - `currentStep`, `currentStepIndex`, `stepProgress` (0.0-1.0)
  - `totalProgress`: calculado automáticamente
  - `remainingTimeMs`: tiempo restante del paso actual

### 2. Ejercicios Precargados (6 tipos)
1. **Box Breathing** (4-4-4-4): Respiración cuadrada para reducir estrés
2. **4-7-8 Technique**: Técnica del Dr. Weil para dormir mejor
3. **Triangle Breathing** (5-5-5): Respiración triangular para concentración
4. **Cardiac Coherence** (5-5): Coherencia cardíaca, 6 ciclos/minuto
5. **Energizing Breathing**: Respiración energizante con múltiples ciclos rápidos
6. **Sleep Breathing** (5-5-5): Respiración para dormir, múltiples ciclos largos

### 3. Animaciones y UI

#### Exercise Selection List (`exercise_selection_list.dart`)
- ✨ **Glassmorphism** en cards (blur: 20, opacity: 0.15)
- 🎬 **Staggered animations**: Aparición progresiva con slide + fade
- 📱 **Responsive**: Usa `flutter_screenutil` para dimensiones adaptativas
- 🎨 Degradados con `AppColors.primary` y `secondary`
- 📊 Muestra: nombre, duración total, descripción (3 líneas max), número de pasos

#### Breathing Animation View (`breathing_animation_view.dart`)
- 🎭 **Lottie Animation**: Círculo respiratorio animado
  - Fallback a animación programática si no existe JSON
  - Escala suavemente según duración del paso
  
- ✍️ **AnimatedTextKit**: 
  - TypewriterAnimatedText para instrucciones
  - `ValueKey` para reiniciar en cada cambio de paso
  
- 🔊 **AudioPlayers**: 
  - Feedback sonoro al cambiar de paso
  - Maneja gracefully si el archivo no existe
  
- 📊 **Progress Indicators**:
  - Barra de progreso del paso actual (stepProgress)
  - Barra de progreso total del ejercicio (totalProgress)
  - Countdown en segundos restantes
  
- 🎮 **Controles**:
  - Botón Play/Pause con gradiente
  - Botón Reset/Finish
  - Animaciones con `flutter_animate`

---

## 🔧 Dependencias Agregadas

```yaml
dependencies:
  flutter_bloc: ^8.1.6              # Estado con Cubit
  equatable: ^2.0.5                 # Comparación de objetos
  glassmorphism: ^3.0.0             # Efecto glassmorphism
  flutter_screenutil: ^5.9.3        # Responsive design
  flutter_animate: ^4.5.0           # Animaciones declarativas
  lottie: ^3.1.2                    # Animaciones Lottie
  flutter_staggered_animations: ^1.1.1  # Animaciones escalonadas
  animated_text_kit: ^4.2.2         # Texto animado
  audioplayers: ^6.1.0              # Reproducción de audio
  google_fonts: ^6.2.1              # Fuentes tipográficas

dev_dependencies:
  freezed: ^2.5.7                   # Generación de código inmutable
  freezed_annotation: ^2.4.4        # Anotaciones para freezed
  build_runner: ^2.4.13             # Generador de código
```

---

## 🚀 Próximos Pasos

### 1. Integrar con GoRouter
Agregar la ruta en tu configuración de `go_router`:

```dart
GoRoute(
  path: '/breathing',
  name: 'breathing',
  builder: (context, state) => const BreathingPage(),
),
```

### 2. Agregar Dependency Injection
Registrar el repositorio en tu sistema de DI (GetIt, Riverpod, etc.):

```dart
// Ejemplo con GetIt
getIt.registerLazySingleton<IBreathingRepository>(
  () => BreathingRepositoryImpl(),
);
getIt.registerFactory<GetBreathingExercises>(
  () => GetBreathingExercises(getIt<IBreathingRepository>()),
);
```

### 3. Assets Requeridos

#### Audio (obligatorio para sonido)
- **Ubicación**: `assets/sounds/chime.wav`
- **Recomendación**: Sonido suave de campana o cuenco tibetano (0.5-1 seg)
- **Fuentes**: Freesound.org, Zapsplat.com, Pixabay.com
- **Alternativa**: Comentar línea 47 en `breathing_animation_view.dart`

#### Animación Lottie (opcional, hay fallback)
- **Ubicación**: `assets/animations/breathing_circle.json`
- **Estado actual**: Placeholder funcional incluido
- **Mejorar**: Descargar de LottieFiles.com (buscar "breathing circle")

### 4. Testing (opcional pero recomendado)

```dart
// Ejemplo de test para BreathingCubit
testWidgets('should advance to next step when timer reaches duration', (tester) async {
  final cubit = BreathingCubit(
    getBreathingExercises: mockGetExercises,
  );
  
  await cubit.loadExercises();
  cubit.selectExercise(cubit.state.exercises.first);
  cubit.startTimer();
  
  await Future.delayed(Duration(seconds: 5)); // Esperar primer paso
  
  expect(cubit.state.currentStepIndex, 1);
});
```

---

## 🎨 Personalización

### Cambiar Colores
Editar `lib/app/styles/app_colors.dart`:
```dart
static const primary = Color(0xFF6366F1);    // Cambiar a tu color principal
static const secondary = Color(0xFF8B5CF6);  // Cambiar a tu color secundario
```

### Agregar Más Ejercicios
Editar `lib/data/repositories/breathing_repository_impl.dart`:
```dart
BreathingExerciseModel(
  id: 'custom-exercise',
  name: 'Mi Ejercicio Personalizado',
  description: 'Descripción del nuevo ejercicio',
  benefits: ['Beneficio 1', 'Beneficio 2'],
  steps: [
    BreathingStepModel(
      type: BreathingStepType.inhale,
      duration: const Duration(seconds: 4),
      instructionalText: 'Inhala profundamente por la nariz',
    ),
    // ... más pasos
  ],
),
```

### Cambiar Velocidad del Timer
Editar `lib/app/pages/breathing/breathing_cubit.dart`:
```dart
// Línea 75 - Cambiar de 50ms a otro valor
_timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
  _onTimerTick();
});
```

---

## 🐛 Troubleshooting

### Error: "Target of URI doesn't exist: breathing_animation_view.dart"
✅ **Resuelto**: Archivo creado en `lib/app/pages/breathing/widgets/breathing_animation_view.dart`

### Error: "Audio file not found"
- Descargar un archivo de audio WAV/MP3
- Colocarlo en `assets/sounds/chime.wav`
- O comentar las líneas 46-51 en `breathing_animation_view.dart`

### Error: "Lottie animation doesn't load"
- El código tiene un fallback automático a animación programática
- Para usar animación real, descargar JSON de LottieFiles.com
- Verificar que `pubspec.yaml` incluya la carpeta: `- assets/animations/`

### Problema: Las animaciones se ven lentas
- Aumentar la frecuencia del timer en `breathing_cubit.dart`
- Cambiar de `Duration(milliseconds: 50)` a `Duration(milliseconds: 30)`

---

## 📚 Recursos Adicionales

- **Flutter Bloc**: https://bloclibrary.dev/
- **Freezed**: https://pub.dev/packages/freezed
- **Lottie Files**: https://lottiefiles.com/
- **Clean Architecture**: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html

---

## ✨ Características Destacadas

1. **Arquitectura Escalable**: Fácil agregar nuevos ejercicios, tipos de pasos, o funcionalidades
2. **Animaciones Fluidas**: Timer a 20 FPS (50ms) para transiciones suaves
3. **State Management Robusto**: Inmutabilidad con Freezed, lógica separada en Cubit
4. **UI Moderna**: Glassmorphism, gradientes, animaciones escalonadas
5. **Error Handling**: Manejo graceful de assets faltantes
6. **Extensible**: Fácil conectar con backend, agregar persistencia, o integrar con otras features

---

**Implementado con ❤️ siguiendo Clean Architecture + Material Design 3**
