import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/models/clinica/consulta/veterinariosEncargados.dart';

import '../../config/global/global_variables.dart';
import '../../models/clinica/citasMedicas_model.dart';

class CitaMedicaProvider extends ChangeNotifier {
  final String _urlBase = apiUrlGlobal;
  String _fechaCalendarioClinica = '';
  String get fechaCalendarioClinica => _fechaCalendarioClinica;
  set fechaCalendarioClinica(String value) {
    _fechaCalendarioClinica = value;
    notifyListeners();
  }

  DateTime nowDate = DateTime.now();
  late String fechaDeHoy;

  CitaMedicaProvider() {
    fechaDeHoy = DateFormat("yyyy-MM-dd").format(nowDate);
    getCitasMedicas(fechaDeHoy);
  }
  //Listando citas medicas

  List<CitaMedica> _citasMedicas = [];
  List<CitaMedica> get getcitasMedicas => _citasMedicas;

  Future<void> getCitasMedicas(String date) async {
    date = date == '' ? fechaDeHoy : date;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(Uri.parse('${_urlBase}clinica/citas-dia?fecha_citas=$date'), headers: headers);

    if (response.statusCode == 200) {
      final resp = modelCitasMedicasFromJson(response.body);
      _citasMedicas.clear();
      _citasMedicas.addAll(resp.data);
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

  Future<bool> marcarCitaComo(String tituloMarcarComof, int idFicha) async {
    String urlFinal = '${_urlBase}clinica/estado-consulta?ficha_id=$idFicha&estado=$tituloMarcarComof';

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(urlFinal), headers: headers);

    final jsonResponse = jsonDecode(response.body);

    try {
      if (jsonResponse['code'] == 200 && jsonResponse['data']['ficha_clinica_id'] != '') {
        print('Solicitud exitosa');
        getCitasMedicas(fechaDeHoy);

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

  final List<String> _TabsPantalla = [
    'NORMAL',
    'CIRUGIA',
    'VACUNAS',
    'DESPARASITACION',
    'PROCEDIMIENTO',
    'HOSPITALIZACION',
  ];

  bool esTipoClinica(String valor) {
    return _TabsPantalla.contains(valor.toUpperCase());
  }

  int _idEncargadoSeleccionado = 0;
  int get idEncargadoSeleccionado => _idEncargadoSeleccionado;

  void setIdEncargadoSeleccionado(int value, String nombre) {
    _idEncargadoSeleccionado = value;
    notifyListeners();
  }

  String _inicialEncargado = '';
  String get inicialEncargado => _inicialEncargado;

  void setInicialEncargado(String value) {
    _inicialEncargado = value;
    notifyListeners();
  }

  List<EncargadosVete> _listaFiltradaParticipante = [];

  List<EncargadosVete> get listaFiltradaParticipante =>
      _listaFiltradaParticipante;

  void filtrarListaParticipante(List<EncargadosVete> listaCompleta, String query) {
    _listaFiltradaParticipante = listaCompleta
        .where((elemento) =>
    elemento.nombres.toLowerCase().contains(query.toLowerCase()) ||
        elemento.apellidos.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  bool isSelectedMap(int idEncargado, int idVeterinario) {
    return idEncargado == idVeterinario;
  }

  //cambio a true si el POST se realizo de manera correcta
  bool _OKpostDatosPCita = false;
  bool get OkpostDatosPCita => _OKpostDatosPCita;

  setOKsendDatosPCita(bool value) {
    _OKpostDatosPCita = value;
    notifyListeners();
  }

  Future<bool> enviarDatosActualizarCitaAgenda(String tipo, int fichaID, String fecha, String hora, int idEncargado) async {
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
      "hora": hora.length <= 5 ? '$hora:00' : hora,
      "encargados": [idEncargado],
    };

    String body = jsonEncode(datos);
    print('Datos envio actualiazar cita $body');
    final response = await http.post(Uri.parse(urlFinal), headers: headers, body: body);

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
