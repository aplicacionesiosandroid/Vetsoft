import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/models/clinica/clinica_update_model.dart';

class ClinicaUpdateProvider extends ChangeNotifier {
  final String _urlBase = apiUrlGlobal;
  bool isLoading = false;
  ClinicaUpdateModel? clinicaUpdateModel;

  //Listando citas medicas
  Future<ClinicaUpdateModel?> getClinicaUpdate(int fichaId) async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(Uri.parse('${_urlBase}update/show-formulario?ficha_id=$fichaId&tipo=clinica'), headers: headers);

    final jsonResponse = jsonDecode(response.body);

    print(jsonResponse);

    if (jsonResponse['error'] == false) {
      clinicaUpdateModel = ClinicaUpdateModel.fromJson(response.body);
      notifyListeners();
      isLoading = false;
      return clinicaUpdateModel;
    } else {
      isLoading = false;
      return null;
    }
  }
}
