import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vet_sotf_app/models/horario/empleado_model.dart';
import 'package:vet_sotf_app/models/horario/horario.dart';
import 'package:vet_sotf_app/models/horario/horario_avance_model.dart';
import 'package:vet_sotf_app/models/horario/horario_model.dart';
import 'package:vet_sotf_app/models/horario/respuesta_model.dart';
import 'package:vet_sotf_app/providers/horario/services/auth_service.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart' as global;

class AdminHorarioService {
  static const String _baseUrl = '${global.apiUrlGlobal}horarios';

  static Future<List<HorarioAvanceModel>> getVerAvanceHorarios(String fecha) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/ver-avance-horarios');
    url.replace(queryParameters: {'fecha': fecha});
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al obtener el avance de horarios');
    }
    return (responseModel.data as List).map((e) => HorarioAvanceModel.fromMap(e)).toList();
  }

  static Future<List<EmpleadoModel>> getJornadasEmpleados() async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/jornadas-empleados');
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al obtener las jornadas de los empleados');
    }
    return (responseModel.data as List).map((e) => EmpleadoModel.fromMap(e)).toList();
  }

  static Future<void> postAsignarHorario(List<int> empleados, int horarioId) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/asignar-horario');
    final body = {
      'empleados': empleados,
      'horario_id': horarioId,
    };
    final response = await http.post(url, headers: header, body: jsonEncode(body));
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al asignar el horario');
    }
  }

  static Future<void> postAsignarJornada(Jornada jornada) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/asignar-jornada');
    final body = {
      'fecha_inicio': jornada.fechaInicio.toIso8601String(),
      'fecha_fin': jornada.fechaFin.toIso8601String(),
      'tipo_jornada': jornada.tipoHorario.toLowerCase(),
      'asignados': jornada.nombreHorario.toLowerCase(),
      'dias': Horario.transformDias(jornada)
    };
    final response = await http.post(url, headers: header, body: jsonEncode(body));
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al asignar la jornada');
    }
  }

  static Future<List<HorarioModel>> getVerHorarios() async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/ver-horarios');
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al obtener los horarios');
    }
    return (responseModel.data as List).map((e) => HorarioModel.fromMap(e)).toList();
  }
}
