import 'package:http/http.dart' as http;
import 'package:vet_sotf_app/models/horario/dashboard_model.dart';
import 'package:vet_sotf_app/models/horario/jornada_avance_model.dart';
import 'package:vet_sotf_app/models/horario/novedades_model.dart';
import 'package:vet_sotf_app/models/horario/proximos_dias_libres_model.dart';
import 'package:vet_sotf_app/models/horario/respuesta_model.dart';
import 'package:vet_sotf_app/providers/horario/services/auth_service.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart' as global;

class DashboardService {
  static const String _baseUrl = '${global.apiUrlGlobal}horarios';

  static Future<DashboardModel> getGraficaInicio(int numeroDias) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/grafica-inicio?numero_dias=$numeroDias');
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al obtener los datos');
    }
    return DashboardModel.fromMap(responseModel.data);
  }

  static Future<List<NovedadesModel>> getNovedadesSemana() async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/novedades-semana');
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al obtener los datos');
    }
    return (responseModel.data as List).map((e) => NovedadesModel.fromMap(e)).toList();
  }

  static Future<List<JornadaAvanceModel>> getGraficaJornadas(String fecha) async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/grafica-jornadas?fecha=$fecha');
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al obtener los datos');
    }
    return (responseModel.data as List).map((e) => JornadaAvanceModel.fromMap(e)).toList();
  }

  static Future<List<ProximosDiasLibresModel>> getProximosDiasLibres() async {
    String token = await AuthService.getAuthToken();
    String baseUrl = _baseUrl;
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl/proximos-dias-libres');
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al obtener los datos');
    }
    return (responseModel.data as List).map((e) => ProximosDiasLibresModel.fromMap(e)).toList();
  }
}
