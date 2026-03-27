# ===============================
# CONFIGURACIÓN
# ===============================
$origen  = "D:\flutter_windows_3.41.5-stable\flutter"
$destino = "C:\flutter"

$usuario = $env:USERNAME

$carpetasAEliminar = @(
    "C:\Users\$usuario\flutter",
    "C:\Users\$usuario\dev\flutter"
)

$flutterBin = "C:\flutter\bin"

# ===============================
# ELIMINAR CARPETAS ANTIGUAS
# ===============================
foreach ($carpeta in $carpetasAEliminar) {
    if (Test-Path $carpeta) {
        Write-Host "Eliminando $carpeta..."
        Remove-Item -Path $carpeta -Recurse -Force
    } else {
        Write-Host "$carpeta no existe, se omite."
    }
}


# ===============================
# COPIAR FLUTTER A C:\
# ===============================
if (Test-Path $destino) {
    Write-Host "Flutter ya existe en C:\flutter, se omite la copia."
}
else {
    if (Test-Path $origen) {
        Write-Host "Copiando Flutter a C:\..."
        Copy-Item -Path $origen -Destination $destino -Recurse -Force
    }
    else {
        Write-Error "No se encontró la carpeta origen: $origen"
        exit 1
    }
}

# ===============================
# AGREGAR FLUTTER AL PATH
# ===============================
function Agregar-Path {
    param (
        [string]$ruta,
        [ValidateSet("Machine", "User")]
        [string]$scope
    )

    $path = [Environment]::GetEnvironmentVariable("Path", $scope)

    if ($path -like "*$ruta*") {
        Write-Host "Flutter ya existe en el PATH ($scope)."
        return $true
    }

    try {
        [Environment]::SetEnvironmentVariable(
            "Path",
            "$path;$ruta",
            $scope
        )
        Write-Host "Flutter agregado al PATH ($scope)."
        return $true
    }
    catch {
        Write-Warning "No se pudo modificar el PATH ($scope)."
        return $false
    }
}


Write-Host "Configurando PATH..."

if (-not (Agregar-Path -ruta $flutterBin -scope "Machine")) {
    Write-Host "Intentando PATH del usuario..."
    Agregar-Path -ruta $flutterBin -scope "User"
}

Write-Host "Aceptando licencias de Android automáticamente..."

"y`n" * 50 | flutter doctor --android-licenses

Write-Host "`nEjecutando flutter doctor..."
flutter doctor

flutter upgrade
Write-Host "`nProceso finalizado correctamente"
Write-Host "Presiona cualquier tecla para salir..."
[System.Console]::ReadKey($true)
