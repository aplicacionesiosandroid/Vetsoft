import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vet_sotf_app/models/horario/admin_tipo_ausencia_model.dart';
import 'package:vet_sotf_app/models/horario/ausencia_update_model.dart';
import 'package:vet_sotf_app/models/horario/ausencias_solicitadas_model.dart';
import 'package:vet_sotf_app/models/horario/respuesta_model.dart';
import 'package:vet_sotf_app/providers/horario/services/auth_service.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart' as global;

class AdminAusenciaService {
  static const String _baseUrl = '${global.apiUrlGlobal}horarios';
  static Future<void> postCrearTipoAusencia(String nombreAusencia, String color, List<String> respuestas) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/crear-tipo-ausencia');
    final body = {
      'nombre_ausencia': nombreAusencia,
      'color': color,
      'preguntas_respuestas': [
        {
          'pregunta1': 'descuenta_tiempo_de_mi_contador_de_ausencia',
          'respuesta1': respuestas[0],
        },
        {
          'pregunta2': 'necesita_ser_aprobado',
          'respuesta2': respuestas[1],
        },
        {
          'pregunta3': 'permite_documento_adjunto',
          'respuesta3': respuestas[2],
        },
        {
          'pregunta4': 'nombre_visible_para_todos',
          'respuesta4': respuestas[3],
        },
        {
          'pregunta5': 'ausencia_dia_laborable',
          'respuesta5': respuestas[4],
        },
        {
          'pregunta6': 'solicitud_minima_cada_vez',
          'respuesta6': respuestas[5],
        },
        {
          'pregunta7': 'maximo_solicitudes_a_la_vez',
          'respuesta7': respuestas[6],
        }
      ]
    };
    final response = await http.post(url, headers: header, body: jsonEncode(body));

    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al obtener las ausencias');
    }
  }

  static Future<List<AdminTipoAusenciaModel>> getTiposAusencias() async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/tipos-ausencias');
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al obtener los tipos de ausencias');
    }
    return (responseModel.data as List).map((e) => AdminTipoAusenciaModel.fromMap(e)).toList();
  }

  static Future<void> putTipoAusencia(int tipoAusenciaId, String nombreAusencia, String color, List<String> respuestas) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/update-tipo-ausencia');
    final body = {
      'tipo_ausencia_id': tipoAusenciaId.toString(),
      'nombre_ausencia': nombreAusencia,
      'color': color,
      'preguntas_respuestas': [
        {
          'pregunta1': 'descuenta_tiempo_de_mi_contador_de_ausencia',
          'respuesta1': respuestas[0],
        },
        {
          'pregunta2': 'necesita_ser_aprobado',
          'respuesta2': respuestas[1],
        },
        {
          'pregunta3': 'permite_documento_adjunto',
          'respuesta3': respuestas[2],
        },
        {
          'pregunta4': 'nombre_visible_para_todos',
          'respuesta4': respuestas[3],
        },
        {
          'pregunta5': 'ausencia_dia_laborable',
          'respuesta5': respuestas[4],
        },
        {
          'pregunta6': 'solicitud_minima_cada_vez',
          'respuesta6': respuestas[5],
        },
        {
          'pregunta7': 'maximo_solicitudes_a_la_vez',
          'respuesta7': respuestas[6],
        }
      ]
    };
    final response = await http.put(url, headers: header, body: jsonEncode(body));
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al obtener las ausencias');
    }
  }

  static Future<AusenciaUpdateModel> getTipoAusenciaById(int tipoAusenciaId) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/tipo-ausencia/$tipoAusenciaId');
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al obtener los tipos de ausencias');
    }
    return AusenciaUpdateModel.fromMap(responseModel.data);
  }

  static Future<List<AusenciasSolicitadasModel>> getAusenciasPendientes() async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/ausencias-pendientes');
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al obtener las ausencias');
    }
    return (responseModel.data as List).map((e) => AusenciasSolicitadasModel.fromMap(e)).toList();
  }

  static Future<void> getAprobarAusencia(int ausenciaId) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('$baseUrl/aprobar-ausencia?ausencia_id=$ausenciaId');
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al aprobar la ausencia');
    }
  }
}
