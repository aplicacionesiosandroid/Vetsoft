import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vet_sotf_app/models/horario/respuesta_model.dart';
import 'package:vet_sotf_app/providers/horario/services/auth_service.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart' as global;

class AdminEventoService {
  static const String _baseUrl = '${global.apiUrlGlobal}horarios';

  static Future<void> postCrearEvento(String titulo, String fechaInicio, String fechaFin, String descripcion) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/crear-evento');
    final body = {
      'titulo': titulo,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
      'descripcion': descripcion,
    };
    final response = await http.post(url, headers: header, body: jsonEncode(body));
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al crear el evento');
    }
  }
}
