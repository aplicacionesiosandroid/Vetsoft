import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stack_trace/stack_trace.dart';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Patrón para terminaciones de archivo con .jpg o .jpeg
const Pattern jpgPattern = r"\.(jpeg|jpg)$";
final RegExp jpgRegEx = RegExp(jpgPattern.toString());

/// clase con métodos para usar en toda la aplicación
class Utilidades {

  /// Preferencias de sistema
  static final Future<SharedPreferences> prefs =
      SharedPreferences.getInstance();


  static Future<String?> readPreferenceString({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getString(key);
  }

  static Future<dynamic> readPreference({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.get(key);
  }

  static Future<void> savePreference(
      {required key, required String value}) async {
    final prefs = await SharedPreferences.getInstance();
    await await prefs.setString(key, value);
  }

  static Future<void> savePreferenceBoolean(
      {required key, required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await await prefs.setBool(key, value);
  }

  static Future<bool?> readPreferenceBoolean({required key}) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(key);
  }

  static Future<void> savePreferenceStringList(
      {required key, required List<String> value}) async {
    final prefs = await SharedPreferences.getInstance();
    await await prefs.setStringList(key, value);
  }

  static Future<List<String>?> readPreferenceStringList({required key}) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getStringList(key);
  }

  /// Función que completa ceros en un código que no contenga n caracteres
  static String completarZeroIzquierda(String text, int nro) {
    return text.padLeft(nro, '0');
  }

  /// Función que convierte la primera letra en mayúscula
  /// DANIELA HUERTAS
  static String capitalize(String value) {
    if (value.isNotEmpty) {
      List<String> cadenas = value.split(' ');
      cadenas = cadenas
          .map((e) => ("${e[0].toUpperCase()}${e.substring(1).toLowerCase()}"))
          .toList();
      return cadenas.join(' ');
    } else {
      return value;
    }
  }

  static String uppercase(String value) {
    if (value.isNotEmpty) {
      return value.toUpperCase();
    } else {
      return value;
    }
  }

  /// Método que imprime logs en caso de no estar en entorno de producción
  static void imprimir(String mensaje) {
    // if (Config.ambiente != Config.Ambiente.PROD.name ||
    //     Config.ambiente != Config.Ambiente.SEG.name) {
      log(mensaje, name: '${Trace.current().frames[1].member}');
    // }
  }

  /// Función que describe una fecha y hora a partir de un campo datetime
  static String parseHoraFecha(
      {required String fechaInicial,
      bool fechaRequerida = true,
      String separador = '/',
      bool horaRequerida = true,
      bool mesNumerico = false,
      bool segundosRequerido = false}) {
    List<String> monthArray = [
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    DateTime date = DateTime.now();
    try {
      date = DateTime.parse(fechaInicial).toLocal();
    } catch (e) {
      Utilidades.imprimir('Error analizando fecha: ${e.toString()}');
    }

    String parsed = horaRequerida
        ? '${completarZeroIzquierda(date.hour.toString(), 2)}:${completarZeroIzquierda(date.minute.toString(), 2)}'
        : '';
    parsed += segundosRequerido
        ? ':${completarZeroIzquierda(date.second.toString(), 2)}'
        : '';
    if (fechaRequerida) {
      parsed =
          '${completarZeroIzquierda(date.day.toString(), 2)}$separador${mesNumerico ? completarZeroIzquierda(date.month.toString(), 2) : monthArray[date.month]}$separador${date.year} $parsed';
    }
    return parsed.trimRight();
  }

  static String parseHoraFechaFormato(DateTime fecha, String formato) {
    return DateFormat(formato).format(fecha);
  }

  static String? obtieneFechaLiteral(String fecha) {
    try {
      DateTime fecha1 = DateTime.parse(fecha).toLocal();
      var newFormat = DateFormat.yMMMMd('es_ES');
      return newFormat.format(fecha1);
    } catch (onError) {
      return null;
    }
  }

  /// Parámetros:
  /// - `dateStr`: La cadena de fecha a formatear (en formato ISO 8601).
  /// - `format`: El formato de salida deseado (por defecto es 'dd/MM/yyyy').
  ///
  /// Retorna:
  /// - Una cadena formateada según el formato especificado.
  /// - Si la cadena de fecha es nula, vacía o no se puede parsear, retorna 'No disponible'.
  static String formatFechaString(String? dateStr,
      {String format = 'dd/MM/yyyy'}) {
    try {
      // Validar si la cadena de fecha es nula o vacía
      if (dateStr == null || dateStr.isEmpty) {
        return 'No disponible';
      }

      // Parsear la cadena de fecha a DateTime
      final DateTime date = DateTime.parse(dateStr);

      // Formatear la fecha usando el formato especificado
      final DateFormat formatter = DateFormat(format);
      return formatter.format(date);
    } catch (e) {
      // Manejar errores de parsing o formato
      return 'No disponible';
    }
  }

  static String obtieneFechaLiteral2(String fecha) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

    DateTime dateToCheck = DateTime.parse(fecha).toLocal();

    String? respuesta = obtieneFechaLiteral(fecha);

    if (respuesta == null) return '';

    DateTime aDate =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    if (aDate == today) {
      respuesta = "Hoy";
    } else if (aDate == yesterday) {
      respuesta = "Ayer";
    }

    return respuesta;
  }

  static Future<String> guardarPDF(Uint8List data,
      {required String nombre}) async {
    Directory location = await getApplicationDocumentsDirectory();
    String pathPdf = '${location.path}/$nombre.pdf';
    Utilidades.imprimir('Ruta PDF: $pathPdf');
    try {
      File file = await File(pathPdf).writeAsBytes(data.toList());
      Utilidades.imprimir('PDF guardado ✅: $pathPdf');
      return file.path;
    } catch (onError) {
      Utilidades.imprimir('Error guardando PDF ❌: $pathPdf: $onError');
      return throw ("Error guardar PDF");
    }
  }

  static void ocultarSnackbar({
    required BuildContext context,
  }) {
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    } on Exception catch (e, s) {
      Utilidades.imprimir('Error ocultando snackbar: ${s.toString()}');
    }
  }

  /// Método que convierte html en una cadena
  static String loadHtmlFromString(String? body) {
    String url = Uri.dataFromString("""<!DOCTYPE html>
    <html>
      <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
      <body style='"margin: 0; padding: 0;'>
        <div>
          $body
        </div>
      </body>
    </html>""", mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();
    return url;
  }

  /// Patrón para terminaciones de archivo con .svg, .jpg, .png
  final RegExp imgRegEx = RegExp(r'\.(jpg|jpeg|png)$');

  /// Método que convierte una cadena en base64
  static String toBase64(String value) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(value);
  }

  /// Método que convierte base64 en una cadena
  static String fromBase64(String value) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.decode(value);
  }

  /// Método que convierte un archivo en base64
  static FutureOr<String> base64FromFile(String path) async {
    final bytes = await File(path).readAsBytes();
    Utilidades.imprimir('LENGTH BYTES: ${bytes.length}');
    String encoded64 = base64Encode(bytes);
    return encoded64;
  }

  static bool versionMenorQue(String versionLocal, String versionOnline) {
    List<String> arrayVersionLocal = versionLocal.split('.');
    List<String> arrayVersionOnline = versionOnline.split('.');

    if (arrayVersionOnline.length == arrayVersionLocal.length &&
        arrayVersionOnline.length == 3) {
      if (int.parse(arrayVersionLocal[0]) > int.parse(arrayVersionOnline[0])) {
        return false;
      }
      bool majorUpgrade =
          int.parse(arrayVersionLocal[0]) < int.parse(arrayVersionOnline[0]);

      if (!majorUpgrade) {
        if (int.parse(arrayVersionLocal[1]) >
            int.parse(arrayVersionOnline[1])) {
          return false;
        } else if (int.parse(arrayVersionLocal[1]) <
            int.parse(arrayVersionOnline[1])) {
          return true;
        } else if (int.parse(arrayVersionLocal[2]) <
            int.parse(arrayVersionOnline[2])) {
          return true;
        }
      } else {
        return true;
      }
    }
    return false;
  }

  /// Método que copia el código generado en el portapapeles
  static void copiarPortapapeles(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text)).then((value) {
      const snackBar = SnackBar(
        content: Text('Copiado a portapaleles '),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  /// Función que procesa el mensaje en una respuesta, tambien indica la cantidad de intentos en caso de que se requiera, según formato del proveedor
  static String obtenerMensajeRespuesta(dynamic respuesta) {
    try {
      String mensaje =
          "${respuesta["mensaje"] ?? respuesta["message"] ?? respuesta["error"] ?? "Solicitud erronea"}";

      if (respuesta["error"] != null &&
          ["invalid_token_error", "invalid_token"]
              .contains(respuesta["error"])) {
        mensaje = "Sesión expirada";
      }

      return mensaje;
    } catch (error) {
      Utilidades.imprimir(
          "Error interpretando el mensaje '${respuesta.toString()}' ✉️: ${error.toString()}");
      return respuesta.toString();
    }
  }

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
