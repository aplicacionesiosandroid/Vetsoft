import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/models/buscador/cliente_model.dart';
import 'package:vet_sotf_app/providers/perfiles/model/perfilMascota.dart';

import '../../config/global/palet_colors.dart';

class PerfilMascotaProvider extends ChangeNotifier {
  List<String> patientData = [
    'Consulta',
    'Cirugía',
    'Vacunación',
    'Desparasitación',
    'Peluquería'
  ];
  List<Color> patientColors = [
    ColorPalet.backGroundColor,
    ColorPalet.secondaryLight,
    ColorPalet.primaryLight,
    ColorPalet.acentLigth,
    ColorPalet.complementVerde1
  ];
  int selectedIndex = 0;
  void setselectedIndex(int valor) {
    selectedIndex = valor;
    setExpedienteSelect(patientData[valor]);

    print(valor);
  }

  String expedienteSeleccionado = '';
  void setExpedienteSelect(String index) {
    expedienteSeleccionado = index;
  }

  void moveToTop(int index) {
    if (index != selectedIndex && index >= 0 && index < patientData.length) {
      // Solo si el índice es diferente al índice actual y está dentro del rango
      List<String> updatedData = List.from(patientData);
      updatedData.removeAt(index);
      updatedData.insert(0, patientData[index]);
      setExpedienteSelect(patientData[index]);
      patientData = updatedData;

      List<Color> updatedDataColor = List.from(patientColors);
      updatedDataColor.removeAt(index);
      updatedDataColor.insert(0, patientColors[index]);
      patientColors = updatedDataColor;

      selectedIndex = 0;
      notifyListeners();
    }
  }

  //obteniendo listado de razas
  PerfilMascota? _perfilMascota;
  PerfilMascota? get getPerfilMascota => _perfilMascota;

  void setPerfilMascota(PerfilMascota? perfilMascota) {
    _perfilMascota = perfilMascota;
    notifyListeners();
  }

  ClienteResponse? _perfilCliente;
  ClienteResponse? get getPerfilCliente => _perfilCliente;

  void setPerfilCliente(ClienteResponse? perfilCliente) {
    _perfilCliente = perfilCliente;
    notifyListeners();
  }



  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchPerfilMascota(int id) async {

    final url = Uri.parse('${apiUrlGlobal}perfil/paciente/$id');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';

    _isLoading = true;
    notifyListeners();
    Map<String, String> headers = {
      'Authorization': 'Bearer $token', // Incluye el token en el encabezado de autorización
    };
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data['data'][0]);
      setPerfilMascota(PerfilMascota.fromJson(data['data'][0]));
      print(getPerfilMascota!.edadPaciente);
      // _perfilMascota = data['data'][0];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getCliente(int id) async {

    final url = Uri.parse('${apiUrlGlobal}perfil/propietario/$id');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';

    _isLoading = true;
    notifyListeners();
    Map<String, String> headers = {
      'Authorization': 'Bearer $token', // Incluye el token en el encabezado de autorización
    };
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> parsedJson = json.decode(response.body);
      setPerfilCliente(ClienteResponse.fromJson(parsedJson));
      print(_perfilCliente!.data[0].nombresPropietario);
    }
    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _perfilMascota = null;
    _isLoading = false;
    // notifyListeners();
  }

}
