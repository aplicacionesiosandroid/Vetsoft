import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vet_sotf_app/models/tareas/participantes_tareas_model.dart';

import '../config/global/global_variables.dart';
import '../models/agenda/response_agenda.dart';

class AgendaProvider extends ChangeNotifier {
  final String _urlBase = apiUrlGlobal;

  CampainProvider() {}

  //lista de productos

  /* List<Productos> _products = [];
  List<Productos> get getproducts => _products;

  Future<void> getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http
        .get(Uri.parse('${_urlBase}petshop/todos-productos'), headers: headers);

    final responseData = jsonDecode(response.body);

    print(responseData);

    if (responseData['code'] == 200) {
      final resp = modelProductosFromJson(response.body);
      _products.clear();
      _products.addAll(resp.data);

      notifyListeners();
    } else {
      throw Exception('Error al obtener los datos de la API');
    }
  }
 */

  //Almacenar fecha de fin codigo promocional

  String _fechaSelected = '';
  String get fechaSelected => _fechaSelected;

  void setFechaSelected(String value) {
    _fechaSelected = value;
  }

  List<ClinicaModel> clinicaList = [];
  List<PeluqueriaModel> peluqueriaList = [];
  List<TareaModel> tareaList = [];

  Future<void> getAgendaDia(String fecha) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
        Uri.parse('${_urlBase}agenda/agenda?fecha=${fecha}'),
        headers: headers);
    print('URL get agenda catch ${_urlBase}agenda/agenda?fecha=${fecha}');

    try {
      if (response.statusCode == 200) {
        final resp = ResponseModel.fromJson(response.body);
        clinicaList = resp.data.clinica;
        peluqueriaList = resp.data.peluqueria;
        tareaList = resp.data.tareas;
        notifyListeners();
      } else {
        throw Exception('Error al obtener los datos de la API');
      }
    } catch (e) {
      print('Error al obtener los datos de la API get agenda catch $e');
    }
  }

  //cambio a true si el POST se realizo de manera correcta
  bool _OKpostDatosPCita = false;
  bool get OkpostDatosPCita => _OKpostDatosPCita;

  setOKsendDatosPCita(bool value) {
    _OKpostDatosPCita = value;
    notifyListeners();
  }

//METODO PARA ENVIAR TODO A LA API

  Future<bool> enviarDatosActualizarCita(
      String tipo, int fichaID, String fecha, String hora) async {
    String urlFinal = '${_urlBase}agenda/actualizar-fecha';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final datos = <String, dynamic>{
      "tipo": tipo,
      "ficha_id": fichaID,
      "fecha": fecha,
      "hora": hora,
    };

    String body = jsonEncode(datos);

    final response =
        await http.post(Uri.parse(urlFinal), headers: headers, body: body);

    final responseData = jsonDecode(response.body);

    try {
      if (responseData['code'] == 200 &&
          responseData['data']['ficha_clinica_id'] != '') {
        print('Solicitud exitosa');
        print('Data decodificada: ${responseData['data']}');

        setOKsendDatosPCita(true);
        notifyListeners();
        return OkpostDatosPCita;
      } else {
        print('Error en la solicitud: ${responseData['data']}');
        setOKsendDatosPCita(false);
        notifyListeners();
        return OkpostDatosPCita;
      }
    } catch (e) {
      print('errooorrr $e');
      setOKsendDatosPCita(false);
      notifyListeners();
      return OkpostDatosPCita;
    }
  }

  Future<bool> enviarDatosActualizarCitaAgenda(String tipo, int fichaID,
      String fecha, String hora, Map<int, String> listaParticipantes) async {
    String urlFinal = '${_urlBase}agenda/actualizar-fecha';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // Extraer los IDs de los responsables
    List<int> encargadosIds = listaParticipantes.keys.toList();

    final datos = <String, dynamic>{
      "tipo": tipo,
      "ficha_id": fichaID,
      "fecha": fecha,
      "hora": hora.length <= 5 ? '$hora:00' : hora,
      "encargados": encargadosIds,
    };

    String body = jsonEncode(datos);
    print('Datos envio actualiazar cita $body');
    final response =
        await http.post(Uri.parse(urlFinal), headers: headers, body: body);

    final responseData = jsonDecode(response.body);

    try {
      if (responseData['code'] == 200 &&
          responseData['data']['ficha_clinica_id'] != '') {
        print('Solicitud exitosa');
        print('Data decodificada: ${responseData['data']}');

        setOKsendDatosPCita(true);
        notifyListeners();
        return OkpostDatosPCita;
      } else {
        print('Error en la solicitud: ${responseData['data']}');
        setOKsendDatosPCita(false);
        notifyListeners();
        return OkpostDatosPCita;
      }
    } catch (e) {
      print('errooorrr $e');
      setOKsendDatosPCita(false);
      notifyListeners();
      return OkpostDatosPCita;
    }
  }
}
