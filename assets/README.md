# Assets de Respiración

## Archivos de Audio

### chime.wav
**Ubicación requerida**: `assets/sounds/chime.wav`

**Propósito**: Sonido de feedback al cambiar entre pasos de respiración

**Especificaciones recomendadas**:
- Formato: WAV o MP3
- Duración: 0.5-1 segundo
- Volumen: Moderado (no estridente)
- Tono: Agradable, relajante (campana, cuenco tibetano, o sonido suave)

**Dónde obtenerlo**:
1. Sitios de audio libre:
   - Freesound.org (buscar "bell chime meditation")
   - Zapsplat.com (efectos de sonido gratuitos)
   - Pixabay.com/sound-effects/

2. Generar con apps:
   - GarageBand (iOS/Mac)
   - Audacity (multiplataforma)

3. Placeholder temporal:
   - Usar cualquier sonido corto y agradable
   - O comentar la línea de audio en `breathing_animation_view.dart` (línea 47)

## Animaciones Lottie

### breathing_circle.json
**Ubicación**: `assets/animations/breathing_circle.json`

**Estado**: ✅ Archivo placeholder incluido

**Para mejorar la animación**:
1. Visitar LottieFiles.com
2. Buscar "breathing circle" o "meditation circle"
3. Descargar JSON y reemplazar el archivo actual

**Con State Machine (avanzado)**:
- La versión actual usa AnimationController simple
- Para State Machine real, necesitas After Effects + Lottie plugin
- El código está preparado para usar `stateInput` (1-4) cuando tengas un archivo con State Machine

## Iconos SVG

### Carpeta icons/
**Ubicación**: `assets/icons/`

**Estado**: 📁 Carpeta creada, iconos opcionales

**Uso futuro**: 
- Iconos personalizados para tipos de ejercicios
- Badges de logros
- Indicadores de progreso especiales
