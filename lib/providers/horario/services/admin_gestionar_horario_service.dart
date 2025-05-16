import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vet_sotf_app/models/horario/horario.dart';
import 'package:vet_sotf_app/models/horario/horario_update_model.dart';
import 'package:vet_sotf_app/models/horario/respuesta_model.dart';
import 'package:vet_sotf_app/providers/horario/services/auth_service.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart' as global;

class AdminGestionarHorarioService {
  static const String _baseUrl = '${global.apiUrlGlobal}horarios';

  static Future<void> postCrearHorarioFijo(HorarioFijo horarioFijo) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = {
      'nombre_horario': horarioFijo.nombreHorario,
      'tipo_horario': horarioFijo.tipoHorario.toLowerCase(),
      'fecha_inicio': horarioFijo.fechaInicio.toIso8601String(),
      'fecha_fin': horarioFijo.fechaFin.toIso8601String(),
      ...horarioFijo.dias.map((key, value) => MapEntry('${key.toLowerCase()}_inicio', value.startTime)),
      ...horarioFijo.dias.map((key, value) => MapEntry('${key.toLowerCase()}_fin', value.endTime)),
    };
    final url = Uri.parse('$baseUrl/crear-horario');
    final response = await http.post(url, headers: header, body: jsonEncode(body));
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al crear el horario fijo');
    }
    Map<String, dynamic> data = responseModel.data;
    String base64ImagenEntradasalida = data['link_qr'];
    await saveImage(base64ImagenEntradasalida, 'horarioFijo');
  }

  static Future<void> postCrearHorarioFlexible(HorarioFlexible horarioFlexible) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = {
      'nombre_horario': horarioFlexible.nombreHorario,
      'tipo_horario': horarioFlexible.tipoHorario.toLowerCase(),
      'fecha_inicio': horarioFlexible.fechaInicio.toIso8601String(),
      'fecha_fin': horarioFlexible.fechaFin.toIso8601String(),
      ...horarioFlexible.horas.map((key, value) => MapEntry(key.toLowerCase(), value)),
    };
    final url = Uri.parse('$baseUrl/crear-horario');
    final response = await http.post(url, headers: header, body: jsonEncode(body));
    if (response.statusCode != 200) {
      throw Exception('Error al crear el horario flexible');
    }
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al crear el horario flexible');
    }
    Map<String, dynamic> data = responseModel.data;
    String base64ImagenEntradasalida = data['link_qr'];
    await saveImage(base64ImagenEntradasalida, 'horarioFlexible');
  }

  static Future<void> saveImage(String base64Str, String fileName) async {
    try {
      Uint8List bytes = base64.decode(base64Str.split(',').last);
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        String formattedDate = DateFormat('ddMMyyyy_HHmm').format(DateTime.now());
        String fileNameOrigin = '$fileName$formattedDate.jpg';

        File file = File('${directory.path}/$fileNameOrigin');
        await file.writeAsBytes(bytes);

        final result = await ImageGallerySaver.saveFile(file.path);

        if (result['isSuccess']) {
          print('PDF guardado en ${result['filePath']}');
        } else {
          throw Exception('Error al guardar el PDF: ${result['errorMessage']}');
        }
      } else {
        throw Exception('No se pudo acceder al directorio externo');
      }
    } catch (e) {
      throw Exception('Error al guardar el PDF: $e');
    }
  }

  static Future<HorarioUpdateModel> getHorarioById(int horarioId) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('$baseUrl/ver-horario/$horarioId');
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (response.statusCode != 200) {
      throw Exception('Error al obtener el horario');
    }
    print(response.body);
    return HorarioUpdateModel.fromMap(responseModel.data);
  }

  static Future<void> putActualizarHorarioFijo(HorarioFijo horarioFijo, int horarioId) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = {
      'horario_id': horarioId,
      'nombre_horario': horarioFijo.nombreHorario,
      'tipo_horario': horarioFijo.tipoHorario.toLowerCase(),
      'fecha_inicio': horarioFijo.fechaInicio.toIso8601String(),
      'fecha_fin': horarioFijo.fechaFin.toIso8601String(),
      ...horarioFijo.dias.map((key, value) => MapEntry('${key.toLowerCase()}_inicio', value.startTime)),
      ...horarioFijo.dias.map((key, value) => MapEntry('${key.toLowerCase()}_fin', value.endTime)),
    };
    final url = Uri.parse('$baseUrl/update-horario');
    final response = await http.put(url, headers: header, body: jsonEncode(body));
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al actualizar el horario fijo');
    }
    Map<String, dynamic> data = responseModel.data;
    String base64ImagenEntradasalida = data['link_qr'];
    await saveImage(base64ImagenEntradasalida, 'horarioFijoAct');
  }

  static Future<void> putActualizarHorarioFlexible(HorarioFlexible horarioFlexible, int horarioId) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = {
      'horario_id': horarioId,
      'nombre_horario': horarioFlexible.nombreHorario,
      'tipo_horario': horarioFlexible.tipoHorario.toLowerCase(),
      'fecha_inicio': horarioFlexible.fechaInicio.toIso8601String(),
      'fecha_fin': horarioFlexible.fechaFin.toIso8601String(),
      ...horarioFlexible.horas.map((key, value) => MapEntry(key.toLowerCase(), value)),
    };
    final url = Uri.parse('$baseUrl/update-horario');
    final response = await http.put(url, headers: header, body: jsonEncode(body));
    print(response.body);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al actualizar el horario flexible');
    }
    Map<String, dynamic> data = responseModel.data;
    String base64ImagenEntradasalida = data['link_qr'];
    await saveImage(base64ImagenEntradasalida, 'horarioFlexibleAct');
  }

  static Future<void> deleteEliminarHorario(int horarioId) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('$baseUrl/delete-horario/$horarioId');
    final response = await http.delete(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al eliminar el horario');
    }
  }

  static Future<void> getArchivarHorario(int horarioId) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('$baseUrl/archivar-horario/$horarioId');
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al archivar el horario');
    }
  }
}
