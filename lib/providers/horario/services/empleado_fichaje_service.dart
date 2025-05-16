import 'package:http/http.dart' as http;
import 'package:vet_sotf_app/models/horario/respuesta_model.dart';
import 'package:vet_sotf_app/providers/horario/services/auth_service.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart' as global;

class EmpleadoFichajeService {
  static const String _baseUrl = '${global.apiUrlGlobal}horarios';

  static Future<void> getFicharEntrada(String codigo) async {
    String token = await AuthService.getAuthToken();
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse(codigo);
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al fichar entrada');
    }
  }

  static Future<void> getFicharSalida(String codigo) async {
    String token = await AuthService.getAuthToken();
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse(codigo);
    final response = await http.get(url, headers: header);
    RespuestaModel responseModel = RespuestaModel.fromJson(response.body);
    if (responseModel.code != 200) {
      throw Exception('Error al fichar salida');
    }
  }
}
