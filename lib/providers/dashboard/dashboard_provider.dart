import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/models/inicio/mode_citasDash.dart';
import 'package:vet_sotf_app/models/inicio/model_avance_dash.dart';
import 'package:http/http.dart' as http;
import 'package:vet_sotf_app/models/inicio/model_caja.dart';

import '../../config/global/global_variables.dart';
import '../../models/inicio/model_dash_graficos.dart';

class DashBoardProvider extends ChangeNotifier {
  DashBoardProvider() {
    getAvencesDash();
    getDataGraficos();
    getCitasDash();
    getDetalleCaja();
  }

  final String _urlBase = apiUrlGlobal;

  //obtener detalle de caja
  bool _loadingDetalleCaja = false;
  bool get loadingDetalleCaja => _loadingDetalleCaja;
  set loadingDetalleCaja(bool state) {
    _loadingDetalleCaja = state;
    notifyListeners();
  }

  DataCajaDetalle? cajaDetalle;

  Future<void> getDetalleCaja() async {
    loadingDetalleCaja = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(Uri.parse('${_urlBase}inicio/estadisticas-cajas'), headers: headers);

    try {
      if (response.statusCode == 200) {
        final resp = ModelDetalleCaja.fromJson(response.body);
        cajaDetalle = resp.data;
        notifyListeners();
        loadingDetalleCaja = false;
      } else {
        loadingDetalleCaja = false;
        throw Exception('Error al obtener los datos de la API');
      }
    } catch (e) {
      loadingDetalleCaja = false;
      print('Error al obtener los datos de la API catch $e');
    }

  }

  //lista y metodo para obtener los avances en el dashboard prinicipal

  final List<AvanceDashboard> _avanceDashBoardList = [];
  List<AvanceDashboard> get avanceDashBoardList => _avanceDashBoardList;

  Future<void> getAvencesDash() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = prefs.getString('myToken') ?? '';
      Map<String, String> headers = {
        'Authorization': 'Bearer $token', // Incluye el token en el encabezado de autorización
      };

      final response = await http.get(Uri.parse('${_urlBase}inicio/avance-modulos'), headers: headers);

      final jsonResponse = jsonDecode(response.body);
      print("lista de objetos pantalla principal $jsonResponse");

      if (jsonResponse['code'] == 200) {
        final resp = modelAvanceDashBoardFromJson(response.body);
        _avanceDashBoardList.clear();
        _avanceDashBoardList.add(resp.data);
        //setLoadignBusqueda(false);
        notifyListeners();
      }
    } catch (e) {
      print('Error al obtener los datos pantalla principal $e');
    }
  }

  //listando datos para grafico principal

  final List<DatoGrafico> _graficosDash = [];
  List<DatoGrafico> get graficosDash => _graficosDash;

  Future<void> getDataGraficos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(Uri.parse('${_urlBase}inicio/productos-barras?numero_dias=7'), headers: headers);

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    try {
      if (jsonResponse['code'] == 200) {
        final resp = modelGraphsDashFromJson(response.body);
        _graficosDash.clear();
        _graficosDash.add(resp.data);
        //setLoadignBusqueda(false);
        notifyListeners();
        print(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener los datos de la API');
      }
    } catch (e) {
      print('Error al obtener los datos de la API catch');
    }
  }

  //lista citas del dia en el dashboard

  List<CitaDiaDash> _citasDiaDash = [];
  List<CitaDiaDash> get citasDiaDash => _citasDiaDash;

  Future<void> getCitasDash() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(Uri.parse('${_urlBase}inicio/citas-dia'), headers: headers);

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    try {
      if (jsonResponse['code'] == 200) {
        final resp = modelCitasDiaDashboardFromJson(response.body);
        _citasDiaDash.clear();
        _citasDiaDash.addAll(resp.data);
        //setLoadignBusqueda(false);
        notifyListeners();
        print(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener los datos de la API');
      }
    } catch (e) {
      print('Error al obtener los datos de la API catch');
    }
  }

  //marcar cita check o close

  bool _OKpostMarcarCita = false;
  bool get OkpostMarcarCita => _OKpostMarcarCita;

  setOKsendMarcarCita(bool value) {
    _OKpostMarcarCita = value;
    notifyListeners();
  }

  Future<bool> marcarCitaDash(String tipo, String booleano, int id) async {
    String urlFinal = '${_urlBase}inicio/marcar-cita?tipo=$tipo&id=$id&marca=$booleano';

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(urlFinal), headers: headers);

    final jsonResponse = jsonDecode(response.body);

    try {
      if (jsonResponse['code'] == 200) {
        print('Solicitud exitosa');
        setOKsendMarcarCita(true);
        getCitasDash();
        notifyListeners();
        return OkpostMarcarCita;
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');

        setOKsendMarcarCita(false);
        notifyListeners();
        return OkpostMarcarCita;
      }
    } catch (e) {
      print('errooorrr $e');

      setOKsendMarcarCita(false);
      notifyListeners();
      return OkpostMarcarCita;
    }
  }

  //metodo para abrir caja monto de apertura

  //loading mientras envian los datos de abrir caja
  bool _loadingDatosAbrirCaja = false;
  bool get loadingDatosAbrirCaja => _loadingDatosAbrirCaja;

  setLoadingDatosAbrirCaja(bool value) {
    _loadingDatosAbrirCaja = value;
    notifyListeners();
  }

  //cambio a true si el POST se realizo de manera correcta la apertura de caja
  bool _oKpostDatosAbrirCaja = false;
  bool get okpostDatosAbrirCaja => _oKpostDatosAbrirCaja;

  setOKsendDatosAbrirCaja(bool value) {
    _oKpostDatosAbrirCaja = value;
    notifyListeners();
  }

  String _mensajeDeAbrirCaja = '';
  String get mensajeDeAbrirCaja => _mensajeDeAbrirCaja;

  setMensajeDeAbrirCaja(String value) {
    _mensajeDeAbrirCaja = value;
    notifyListeners();
  }

  Future<bool> enviarDatosAbrirCaja(String montoInicialf ) async {
    String urlFinal = '${_urlBase}inicio/abrir-caja';

    setLoadingDatosAbrirCaja(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    if (montoInicialf.isEmpty) {
      montoInicialf = '0';
    }

    final datos = <String, dynamic>{
      'monto_inicial': montoInicialf,
    }; // Cuerpo de

    String body = jsonEncode(datos);
    print(body);

    final response = await http.post(Uri.parse(urlFinal), headers: headers, body: body);

    final jsonResponse = jsonDecode(response.body);

    try {
      if (jsonResponse['code'] == 200) {
        print('Solicitud exitosa');

        _mensajeDeAbrirCaja = jsonResponse['data']['mensaje'];

        setLoadingDatosAbrirCaja(false);
        setOKsendDatosAbrirCaja(true);
        notifyListeners();
        return okpostDatosAbrirCaja;
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');
        setLoadingDatosAbrirCaja(false);
        setOKsendDatosAbrirCaja(false);
        notifyListeners();
        return okpostDatosAbrirCaja;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosAbrirCaja(false);
      setOKsendDatosAbrirCaja(false);
      notifyListeners();
      return okpostDatosAbrirCaja;
    }
  }

  // metodo para cierre de caja

  //loading mientras envian los datos de cerrar caja
  bool _loadingDatosCerrarCaja = false;
  bool get loadingDatosCerrarCaja => _loadingDatosCerrarCaja;

  setLoadingDatosCerrarCaja(bool value) {
    _loadingDatosCerrarCaja = value;
    notifyListeners();
  }

  String monto_cierre_variable = '';

  setMonto_cierre_variable(String value) {
    monto_cierre_variable = value;
    notifyListeners();
  }

  //cambio a true si el POST se realizo de manera correcta el cierre de caja
  bool _oKpostDatosCerrarCaja = false;
  bool get okpostDatosCerrarCaja => _oKpostDatosCerrarCaja;

  setOKsendDatosCerrarCaja(bool value) {
    _oKpostDatosCerrarCaja = value;
    notifyListeners();
  }

  String _mensajeDeCerrarCaja = '';
  String get mensajeDeCerrarCaja => _mensajeDeCerrarCaja;

  setMensajeDeCerrarCaja(String value) {
    _mensajeDeCerrarCaja = value;
    notifyListeners();
  }

  Future<bool> enviarDatosCerrarCaja(
    String montoCierref,
  ) async {
    String urlFinal = '${_urlBase}inicio/cerrar-caja';

    setLoadingDatosCerrarCaja(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    if (montoCierref.isEmpty) {
      montoCierref = '0';
    }

    final datos = <String, dynamic>{
      'monto_cierre': montoCierref,
    }; // Cuerpo de

    String body = jsonEncode(datos);
    print(body);

    final response = await http.post(Uri.parse(urlFinal), headers: headers, body: body);

    final jsonResponse = jsonDecode(response.body);

    try {
      if (jsonResponse['code'] == 200) {
        print('Solicitud exitosa');

        _mensajeDeCerrarCaja = jsonResponse['data']['mensaje'];

        setLoadingDatosCerrarCaja(false);
        setOKsendDatosCerrarCaja(true);
        notifyListeners();
        return okpostDatosCerrarCaja;
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');
        setLoadingDatosCerrarCaja(false);
        setOKsendDatosCerrarCaja(false);
        notifyListeners();
        return okpostDatosCerrarCaja;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosCerrarCaja(false);
      setOKsendDatosCerrarCaja(false);
      notifyListeners();
      return okpostDatosCerrarCaja;
    }
  }

  ModelCaja? _estadoCaja;
  ModelCaja? get estadoCaja => _estadoCaja;

  Future<ModelCaja> getEstadoCaja() async {
    String urlFinal = '${_urlBase}inicio/estado-caja';

    setLoadingDatosCerrarCaja(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(urlFinal), headers: headers);

    final jsonResponse = jsonDecode(response.body);

    try {
      if (jsonResponse['code'] == 200) {

        _estadoCaja = ModelCaja.fromJson(response.body);

        setLoadingDatosCerrarCaja(false);
        setOKsendDatosCerrarCaja(true);
        notifyListeners();
        return _estadoCaja!;
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');
        //Attempt to read property \"estado\" on null
        if (jsonResponse['data'] == 'Attempt to read property \"estado\" on null') {
          _estadoCaja = ModelCaja(code: 200, data: Data(estadoCaja: 'CERRADA'), error: false, message: 'Caja cerrada');
        }
        setLoadingDatosCerrarCaja(false);
        setOKsendDatosCerrarCaja(false);
        notifyListeners();
        return _estadoCaja!;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosCerrarCaja(false);
      setOKsendDatosCerrarCaja(false);
      notifyListeners();
      return _estadoCaja!;
    }
  }

  //cambio a true si el POST se realizo de manera correcta el cierre de caja
  bool _oKpostDatosEgresos = false;
  bool get okpostDatosEgresos => _oKpostDatosEgresos;

  setOKsendDatosEgresos(bool value) {
    _oKpostDatosEgresos = value;
    notifyListeners();
  }

  //loading mientras envian los datos de cerrar caja
  bool _loadingDatosEgresos = false;
  bool get loadingDatosEgresos => _loadingDatosEgresos;

  setLoadingDatosEgresos(bool value) {
    _loadingDatosEgresos = value;
    notifyListeners();
  }

  String _mensajeDeEgresos = '';
  String get mensajeDeEgresos => _mensajeDeEgresos;

  setMensajeDeEgresos(String value) {
    _mensajeDeEgresos = value;
    notifyListeners();
  }

  Future<bool> enviarDatosEgresos(
    String montoEgresof,
    String descEgresof,
  ) async {
    String urlFinal = '${_urlBase}inicio/agregar-egresos';

    setLoadingDatosEgresos(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    if (montoEgresof.isEmpty) {
      montoEgresof = '0';
    }

    final datos = <String, dynamic>{
      'egreso': montoEgresof,
      'descripcion': descEgresof,
    }; // Cuerpo de

    String body = jsonEncode(datos);
    print(body);

    final response = await http.post(Uri.parse(urlFinal), headers: headers, body: body);

    final jsonResponse = jsonDecode(response.body);

    try {
      if (jsonResponse['code'] == 200) {
        print('Solicitud exitosa');

        setMensajeDeEgresos('Egreso guardado');

        setLoadingDatosEgresos(false);
        setOKsendDatosEgresos(true);
        notifyListeners();
        return okpostDatosEgresos;
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');
        setLoadingDatosEgresos(false);
        setOKsendDatosEgresos(false);
        notifyListeners();
        return okpostDatosEgresos;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosEgresos(false);
      setOKsendDatosEgresos(false);
      notifyListeners();
      return okpostDatosEgresos;
    }
  }
}
