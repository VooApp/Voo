================================================
       GUÍA DE INSTALACIÓN Y ARRANQUE - VOO
================================================

REQUISITOS PREVIOS
-------------------
Necesitas instalar 3 cosas antes de poder correr el proyecto:

1. .NET SDK 8
   - Ve a: https://dotnet.microsoft.com/download
   - Descarga ".NET 10.0 SDK" e instálalo
   - Para verificar, abre PowerShell y escribe:
       dotnet --version
   - Debería mostrar algo como: 10.0.x

2. Flutter SDK
   - Ve a: https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.41.6-stable.zip
   - Descarga el ZIP de Flutter y extráelo en C:\flutter
     ⚠️ NO lo pongas en C:\Program Files ni en OneDrive

3. Configurar Flutter
   - Ejecutar "flutterEnv.ps1",‼️DOS VECES‼️ para descargar flutter en pc
   - ‼️ ATENCION‼️SI PC YA TIENE FLUTTER FUNCIONAL, NO EJECUTAR.

================================================
       CÓMO ARRANCAR EL PROYECTO
================================================

Tienes dos partes que arrancar: la API (C#) y la app (Flutter).
Necesitas DOS ventanas de PowerShell abiertas al mismo tiempo.

------------------------------------------------
PARTE 1: Arrancar la API en C#
------------------------------------------------

1. Abre PowerShell
2. Navega a la carpeta de la API:
       cd [RUTA_DEL_DISCO]\VooApi

3. Instala las dependencias (solo la primera vez):
       dotnet restore

4. Arranca la API:
       dotnet run

5. Cuando veas este mensaje, la API está lista:
       Now listening on: http://localhost:5011

   ✅ Para verificar que funciona, abre Chrome y ve a:
       http://localhost:5011/mensaje
   Debería devolver [] o una lista de mensajes guardados.

   ⚠️ Deja esta ventana de PowerShell abierta mientras usas la app.


------------------------------------------------
PARTE 2: Arrancar la app Flutter
------------------------------------------------

1. Abre UNA NUEVA ventana de PowerShell
2. Navega a la carpeta de Flutter:
       cd [RUTA_DEL_PENDRIVE]\voo_app

3. Instala las dependencias (solo la primera vez):
       flutter pub get

4. Corre la app en Chrome:
       flutter run -d chrome

5. Se abrirá Chrome automáticamente con la app.


------------------------------------------------
CÓMO USAR LA APP
------------------------------------------------

1. Escribe un mensaje en el campo de texto
2. Pulsa el botón "Enviar a MongoDB"
3. Si aparece ✅ Guardado correctamente, el mensaje
   se guardó en MongoDB Atlas (la nube)
4. Para verificar, ve a: http://localhost:5011/mensaje
   y verás todos los mensajes guardados


================================================
       NOTAS IMPORTANTES
================================================

- La API (Parte 1) debe estar corriendo ANTES de usar la app
- Necesitas conexión a internet para que MongoDB Atlas funcione
- Si cambias de red WiFi puede que necesites actualizar
  el Network Access en MongoDB Atlas (añadir la nueva IP)
  Ve a: https://cloud.mongodb.com → Network Access → Add IP Address
  y añade 0.0.0.0/0 para permitir cualquier IP

- Para parar la API o Flutter: pulsa Ctrl+C en su ventana


================================================
       ESTRUCTURA DEL PROYECTO
================================================

VOO/
├── VooApi/          → API en C# (backend)
│   ├── Controllers/
│   │   └── MensajeController.cs
│   ├── appsettings.json   (contiene la conexión a MongoDB)
│   └── Program.cs
│
└── voo_app/         → App en Flutter (frontend)
    └── lib/
        └── main.dart

================================================