# Instalación de Flutter

Este documento detalla los pasos para instalar Flutter y configurar el proyecto utilizando la versión Flutter 3.19.4-0.0.pre.1.

## Requisitos Previos

Antes de comenzar, asegúrese de tener lo siguiente instalado en su sistema:

- Git: Necesario para clonar el repositorio de Flutter.
- IDE recomendado: [Android Studio](https://developer.android.com/studio) o [Visual Studio Code](https://code.visualstudio.com/).
- Conexión a Internet.

## Paso 1: Descarga e Instalación de Flutter

1. Clona el repositorio de Flutter usando Git:

   ```bash
   git clone https://github.com/flutter/flutter.git -b stable
   ```

2. Cambia a la versión 3.19.4-0.0.pre.1 de Flutter:

   ```bash
   cd flutter
   git checkout 3.19.4-0.0.pre.1
   ```

3. Agrega Flutter a la variable de entorno `PATH`:

    - En macOS y Linux, abre el archivo `.bashrc`, `.bash_profile`, o `.zshrc` y añade la siguiente línea:

      ```bash
      export PATH="$PATH:$(pwd)/flutter/bin"
      ```

    - En Windows, busca "Variables de entorno" en el Menú Inicio, edita la variable `PATH` y añade la ruta al directorio `flutter\bin`.

4. Verifica la instalación ejecutando:

   ```bash
   flutter doctor
   ```

   Asegúrese de que todas las verificaciones estén completas.

## Paso 2: Configuración del Proyecto

1. Navega al directorio de tu proyecto Flutter.

   ```bash
   cd /ruta/a/tu/proyecto
   ```

2. Ejecuta el siguiente comando para obtener las dependencias del proyecto:

   ```bash
   flutter pub get
   ```

   Este comando descarga todas las dependencias listadas en el archivo `pubspec.yaml`.

3. Una vez completado, puedes ejecutar la aplicación en un emulador o dispositivo físico utilizando:

   ```bash
   flutter run
   ```

## Paso 3: Solución de Problemas

- Si encuentras problemas al ejecutar `flutter doctor`, asegúrate de tener las herramientas necesarias instaladas como el SDK de Android o Xcode (para iOS).
- Verifica las versiones de las dependencias en `pubspec.yaml` para asegurarte de que sean compatibles con la versión de Flutter especificada.

Con estos pasos, deberías tener tu entorno de Flutter configurado correctamente y listo para desarrollar aplicaciones.
