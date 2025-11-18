# breathe · Specialized Technology II

**Author:** Sebastián Bustos  
**Institutional Context:** Proyecto final · Asignatura _Especialización Tecnológica II_  
**Universidad:** Universidad de la Frontera  
**Profesor/a guía:** Héctor Álvarez

---

## 1. Executive Summary

**breathe** es una aplicación móvil desarrollada en Flutter cuyo objetivo es acompañar prácticas de bienestar, respiración consciente y mindfulness. El proyecto integra arquitectura limpia, principios de diseño centrados en el usuario (Nielsen Usability Heuristics) y experiencias audiovisuales guiadas para sesiones de respiración controlada.

La app representa el entregable principal del curso, demostrando dominio en:

- Arquitectura multicapa (domain · data · presentation) con inyección de dependencias.
- Gestión de estado reactivo mediante `flutter_bloc` y generación de modelos inmutables con `freezed`.
- Animaciones personalizadas (Lottie, TweenSequence) y efectos visuales (glassmorphism, glow).
- Routing declarativo con `go_router` y configuración automatizada para entornos de desarrollo.

---

## 2. Key Features

- **Módulo de respiración guiada** con animación circular hipnótica, transición inhalar/sostener/exhalar y feedback sonoro opcional.
- **Listado curado de ejercicios** (box breathing, 4-7-8, cardiac coherence, triangle breathing, etc.) con descripciones clínicas, duración y pasos detallados.
- **Interfaz oscura profesional** con tipografía `GoogleFonts.lato`, tarjetas glassmorphism y colorimetría consistente (AppColors).
- **Aplicación exhaustiva de las 10 heurísticas de Nielsen** en vistas de login, home, breathing y settings.
- **Arquitectura limpia** con repositorios, casos de uso y entidades puros; capa de datos desacoplada mediante modelos serializables.
- **Script de despliegue** (`run.ps1`) que configura `GRADLE_USER_HOME` y ejecuta `flutter run` bajo PowerShell (evitando corrupción de cache en Windows).

---

## 3. Technology Stack

| Capa | Herramientas y Paquetes |
|------|-------------------------|
| Core | Flutter 3.9.x · Dart 3 |
| Arquitectura | `flutter_clean_architecture`, `go_router` |
| Estado | `flutter_bloc`, `equatable`, `freezed`, `build_runner` |
| UI/UX | `google_fonts`, `glassmorphism`, `flutter_screenutil`, `flutter_staggered_animations`, `flutter_animate`, `shimmer`, `animated_text_kit`, `flutter_svg` |
| Animación y Audio | `lottie`, `audioplayers` |
| Logging | `logging` |

> **Nota:** Revisar `pubspec.yaml` para la lista completa de dependencias y versiones bloqueadas.

---

## 4. Arquitectura

breathe adopta el patrón **Clean Architecture**, separando responsabilidades en tres capas principales:

```
lib/
├─ domain/              # Entidades, repositorios abstractos, casos de uso
│  ├─ entities/
│  ├─ repositories/
│  └─ usecases/
├─ data/                # Modelos DTO + repositorios concretos
│  ├─ models/
│  └─ repositories/
└─ app/                 # Presentación (UI, cubits, estilos)
	├─ pages/
	│  ├─ breathing/
	│  │  ├─ widgets/
	│  │  ├─ breathing_cubit.dart
	│  │  └─ breathing_state.dart
	│  └─ ...
	├─ styles/
	└─ utils/
```

- **domain**: Define entidades puras (`BreathingExercise`, `BreathingStep`), contractos (`IBreathingRepository`) y casos de uso (`GetBreathingExercises`).
- **data**: Implementa `BreathingRepositoryImpl` con modelos serializables y datasets curados para cada ejercicio guiado.
- **app**: Gestiona el estado mediante `BreathingCubit`, expone la UI (páginas, widgets) y estilos (`AppColors`).

La navegación se orquesta con `GoRouter`, mientras que los estados se gestionan con Cubits + `BlocBuilder/BlocListener`. Esto favorece testabilidad, escalabilidad y separación de preocupaciones.

---

## 5. UX & Nielsen Heuristics

El rediseño de interfaz siguió estrictamente las 10 heurísticas de Nielsen:

1. **Visibilidad del estado** – Feedback visual en cards con `InkWell`, loader shimmer, badges de progreso.
2. **Correspondencia con el mundo real** – Lenguaje natural (“Comenzar”, “Respiraciones por minuto”), iconografía estándar (play, timer, air).
3. **Control y libertad** – Botones de volver visibles, auto-inicio de ejercicios cancelable, navegación segura.
4. **Consistencia y estándares** – Paleta, tipografías y componentes homogéneos.
5. **Prevención de errores** – Validaciones de índices, fallback de audio cuando `chime.wav` no está disponible.
6. **Reconocimiento en lugar de recuerdo** – Cards con información completa (duración, pasos, descripción) y CTA explícito.
7. **Flexibilidad y eficiencia** – Selección de ejercicio lanza la sesión con delay controlado (800 ms) para transición suave.
8. **Diseño estético y minimalista** – Modales, cards, animaciones con el mínimo ruido visual posible.
9. **Ayuda para reconocer errores** – Snackbars y tooltips descriptivos.
10. **Documentación** – Archivos resumen (`BREATHING_NIELSEN_IMPROVEMENTS.md`, `NIELSEN_IMPROVEMENTS.md`) y este README.

---

## 6. Breathing Module · Technical Spec

- **Animación principal:** `TweenSequence<double>` controla el diámetro de un círculo (100 → 300 px) y el glow radial sincronizado con la fase respiratoria.
- **Fases:** 4 s (INHALA) · 4 s (SOSTÉN) · 7 s (EXHALA) + delay inicial de 4 s. Loop infinito mediante `AnimationController.repeat()`.
- **Audio feedback:** `audioplayers` reproduce `assets/sounds/chime.wav` al cambiar de fase (fallback silencioso si el asset no existe).
- **Estado:** `BreathingState` generado con `freezed` modela progreso total, paso actual, tipo de fase y temporización.
- **UI:** Fondo oscuro, texto superior con la fase actual, círculo animado con glow cyan y botón de cierre persistente.

Documentación ampliada disponible en `BREATHING_NIELSEN_IMPROVEMENTS.md`.

---

## 7. Instalación y Ejecución

### 7.1 Requisitos

- Flutter SDK 3.9.x
- Dart SDK 3.9.x
- Android Studio / Xcode según plataforma destino
- PowerShell 5.1+ (Windows) o Shell compatible

### 7.2 Primer arranque

```powershell
# 1. Instalar dependencias
flutter pub get

# 2. Formatear para asegurar consistencia
flutter format .

# 3. Ejecutar script de entorno (Windows)
./run.ps1

# Alternativa multiplataforma
flutter run
```

> El script `run.ps1` configura `GRADLE_USER_HOME = E:\breatheFlutter\.gradle_temp` para evitar corrupción de cache en equipos con múltiples discos.

### 7.3 Generación de código

```powershell
# Estados y modelos generado con freezed
dart run build_runner build --delete-conflicting-outputs
```

---

## 8. Estructura de Scripts

| Script | Descripción |
|--------|-------------|
| `run.ps1` | Exporta variables de entorno, aplica gradle.properties personalizados y lanza la app en modo debug. |
| `build_runner` | Genera código para `freezed`, `json_serializable` y otros builders. |

---

## 9. Testing & QA

```powershell
# Ejecutar suite de widgets
flutter test

# (Opcional) Cobertura
flutter test --coverage
```

> El enfoque actual prioriza pruebas manuales guiadas (Smoke Tests) sobre los user flows críticos: login, home, selección de ejercicio, sesión de respiración.

---

## 10. Roadmap

- ✅ Arquitectura limpia y módulo de respiración con animación.
- ✅ Rediseño Nielsen en vistas principales (home, breathing, settings, splash).
- 🚧 Integración global con `go_router` + dependency injection (`get_it`).
- 🚧 Inclusión del asset `chime.wav` para feedback auditivo.
- 🚧 Aplicación de heurísticas al resto de vistas (login, achievements, profile, etc.).

---

## 11. Referencias y Recursos

- Nielsen, J. (1994). _Heuristic Evaluation_. Nielsen Norman Group.
- Flutter Documentation: https://docs.flutter.dev
- Bloc Library: https://bloclibrary.dev

---

## 12. Autoría

Este proyecto fue diseñado y desarrollado por **Sebastián Bustos** como parte de la asignatura _Especialización Tecnológica II_.

> Para consultas académicas o soporte, contactar a: **[agregar email institucional]**.

---

**Versión del documento:** 1.0 · Actualizado: 18/11/2025
