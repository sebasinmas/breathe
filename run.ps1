# Script de inicio de Breathe App
# Solución permanente para problemas de caché de Gradle

Write-Host "🫁 Iniciando Breathe App..." -ForegroundColor Cyan
Write-Host ""

# Configurar Gradle para usar directorio alternativo (evita corrupción de caché)
$env:GRADLE_USER_HOME = "E:\breatheFlutter\.gradle_temp"

Write-Host "✓ Configuración de Gradle aplicada" -ForegroundColor Green
Write-Host "  GRADLE_USER_HOME = $env:GRADLE_USER_HOME" -ForegroundColor Gray
Write-Host ""

# Ejecutar Flutter
Write-Host "📱 Lanzando aplicación en dispositivo..." -ForegroundColor Cyan
Write-Host "   Esto puede tomar unos momentos en el primer build" -ForegroundColor DarkGray
Write-Host ""

flutter run

Write-Host ""
Write-Host "✨ Breathe App finalizada" -ForegroundColor Cyan
