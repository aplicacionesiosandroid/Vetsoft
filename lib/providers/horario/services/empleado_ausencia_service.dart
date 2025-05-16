import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:vet_sotf_app/models/horario/lista_ausencias_model.dart';
import 'package:vet_sotf_app/models/horario/respuesta_model.dart';
import 'package:vet_sotf_app/models/horario/empleado_tipo_ausencia_model.dart';
import 'package:vet_sotf_app/providers/horario/services/auth_service.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart' as global;

class EmpleadoAusenciaService {
  static const String _baseUrl = '${global.apiUrlGlobal}horarios';
  static Future<ListaAusenciasModel> getAusenciasVistaEmpleado() async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/ausencias-vista-empleado');
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al obtener las ausencias');
    }
    return ListaAusenciasModel.fromMap(responseModel.data);
  }

  static Future<List<EmpleadoTipoAusenciaModel>> getTipoAusenciasEmpleado() async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/obtener-tipos-ausencias-empleado');
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al obtener los tipos de ausencias');
    }
    return (responseModel.data as List).map((e) => EmpleadoTipoAusenciaModel.fromMap(e)).toList();
  }

  static Future<void> postAgregarAusenciaEmpleado(
    int tipoAusenciaId,
    String descripcion,
    String tipo,
    String desde,
    String hasta,
    File? documento,
  ) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    // body as multipart/form-data
    final header = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/agregar-ausencia');
    final request = http.MultipartRequest('POST', url);
    request.headers.addAll(header);
    request.fields['tipo_ausencia_id'] = tipoAusenciaId.toString();
    request.fields['descripcion'] = descripcion;
    request.fields['tipo'] = tipo;
    request.fields['desde'] = desde;
    request.fields['hasta'] = hasta;
    if (documento != null) {
      request.files.add(await http.MultipartFile.fromPath('documento', documento.path));
    }

    final response = await request.send();

    RespuestaModel responseModel = RespuestaModel.fromJson(await response.stream.bytesToString());
    if (responseModel.code != 200) {
      throw Exception('Error al agregar la ausencia');
    }
  }
}
