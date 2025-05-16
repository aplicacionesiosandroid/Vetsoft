import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../config/global/global_variables.dart';
import '../../models/peluqueria/citasPeluqueria_model.dart';

class CitaPeluqueriaProvider extends ChangeNotifier {
  final String _urlBase = apiUrlGlobal;

  DateTime nowDate = DateTime.now();
  late String fechaDeHoy;

  CitaPeluqueriaProvider() {
    fechaDeHoy = DateFormat("yyyy-MM-dd").format(nowDate);
    getCitasPeluqueria(fechaDeHoy);
  }
  //Listando citas medicas

  List<CitaPeluqueria> _citasPeluquerias = [];
  List<CitaPeluqueria> get getcitasPeluquerias => _citasPeluquerias;

  Future<void> getCitasPeluqueria(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(
        Uri.parse('${_urlBase}peluqueria/citas-dia?fecha_citas=$date'),
        headers: headers);

    if (response.statusCode == 200) {
      final resp = modelCitasPeluqueriaFromJson(response.body);
      _citasPeluquerias.clear();
      _citasPeluquerias.addAll(resp.data);
      notifyListeners();
      print(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener los datos de la API');
    }
  }


  //cambio a true si el POST se realizo de manera correcta el cambiar el estado de la cita
  bool _OKpostDatosMarcarComo = false;
  bool get OkpostDatosMarcarComo => _OKpostDatosMarcarComo;

  setOKsendDatosMarcarComo(bool value) {
    _OKpostDatosMarcarComo = value;
    notifyListeners();
  }


  Future<bool> marcarCitaPeluqueriaComo(
    String tituloMarcarComof,
    int idFicha

  ) async {
    String urlFinal = '${_urlBase}peluqueria/estado-consulta?ficha_id=$idFicha&estado=$tituloMarcarComof';

  
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };


    final response =
        await http.get(Uri.parse(urlFinal), headers: headers);

    final jsonResponse = jsonDecode(response.body);

    try {
      if (jsonResponse['code'] == 200 &&
          jsonResponse['data']['ficha_clinica_id'] != '') {
        print('Solicitud exitosa');
        getCitasPeluqueria(fechaDeHoy);

        
        setOKsendDatosMarcarComo(true);
        notifyListeners();
        return OkpostDatosMarcarComo;
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');
        
        setOKsendDatosMarcarComo(false);
        notifyListeners();
        return OkpostDatosMarcarComo;
      }
    } catch (e) {
      print('errooorrr $e');
      
      setOKsendDatosMarcarComo(false);
      notifyListeners();
      return OkpostDatosMarcarComo;
    }
  }

}

