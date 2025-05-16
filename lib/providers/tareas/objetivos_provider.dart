import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/models/tareas/model_tareas_progreso.dart';
import 'package:vet_sotf_app/models/tareas/objetivos/tablero_objetivos_model.dart';
import 'package:vet_sotf_app/models/tareas/participantes_tareas_model.dart';
import '../../config/global/global_variables.dart';
import '../../models/tareas/model_act_rec_tareas.dart';
import '../../models/tareas/objetivos/model_tareas_obj.dart';
import '../../models/tareas/verTarea_model.dart';

class ObjetivosProvider extends ChangeNotifier {
  final String _urlBase =
      apiUrlGlobal; //final String _urlBase = 'http://192.168.100.6:8000/api/';

  ObjetivosProvider() {
    getObjetivosPorcentajeHome();
  }

  //loading mientras envian los datos
  bool _loadingDatosCrearObjetivo = false;
  bool get loadingDatosCrearObjetivo => _loadingDatosCrearObjetivo;

  setLoadingDatosCrearObjetivo(bool value) {
    _loadingDatosCrearObjetivo = value;
    notifyListeners();
  }

  //cambio a true si el POST se realizo de manera correcta
  bool _oKpostDatosCrearObjetivo = false;
  bool get okpostDatosCrearObjetivo => _oKpostDatosCrearObjetivo;

  setOKsendDatosCrearObjetivo(bool value) {
    _oKpostDatosCrearObjetivo = value;
    notifyListeners();
  }

  //DATOS PARA CREAR OBJETIVO

  //controller para titulo de OBJETIVO, es un controller

  //dropdown estado de la tarea
  String _dropEstadoObjetivo = '';
  String get dropEstadoObjetivo => _dropEstadoObjetivo;
  void setDropEstadoObjetivo(String value) {
    _dropEstadoObjetivo = value;
    notifyListeners();
  }

  //Listando PARTICIPANTES
  List<ParticipanteTarea> _participantesObjetivo = [];
  List<ParticipanteTarea> get getParticipantesObjetivo =>
      _participantesObjetivo;

  Future<void> getParticipantesObjetivos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorizaci         ón
    };

    final response = await http.get(
        Uri.parse('${_urlBase}formulario/participantes'),
        headers: headers);

    final responseData = jsonDecode(response.body);

    if (responseData['code'] == 200) {
      final resp = modelParticipantesTareasFromJson(response.body);
      _participantesObjetivo.clear();
      _participantesObjetivo.addAll(resp.data);

      notifyListeners();
    } else {
      throw Exception('Error al obtener los datos de la API');
    }
  }

  //SELECCIONADOS DE LOS PARTICIPANTES

  Map<int, String> selectedParticipantsMap = {};
  List<int> selectedParticipantsList = [];

  void toggleSelectionMap(int participantId, String rutaImage) {
    if (selectedParticipantsMap.containsKey(participantId)) {
      selectedParticipantsMap.remove(participantId);
      if (selectedParticipantsList.contains(participantId)) {
        selectedParticipantsList.remove(participantId);
      }
    } else {
      selectedParticipantsMap[participantId] = rutaImage;
      selectedParticipantsList.add(participantId);
    }
    notifyListeners();
  }

  bool isSelectedMap(int participantId) {
    return selectedParticipantsMap.containsKey(participantId);
  }

  //BUSQUEDA DE PARTICIPANTES

  //lista de datos filtrados

  List<ParticipanteTarea> _listaFiltradaParticipante = [];

  List<ParticipanteTarea> get listaFiltradaParticipante =>
      _listaFiltradaParticipante;

  void filtrarListaParticipante(
      List<ParticipanteTarea> listaCompleta, String query) {
    _listaFiltradaParticipante = listaCompleta
        .where((elemento) =>
            elemento.nombres.toLowerCase().contains(query.toLowerCase()) ||
            elemento.apellidos.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  //Almacenar fecha de de inicio de tarea

  String _fechaInicioSelected = '';
  String get fechaInicioSelected => _fechaInicioSelected;

  void setFechaInicioSelected(String value) {
    _fechaInicioSelected = value;
    notifyListeners();
  }

  //Almacenar fecha de finalizacion de tarea

  String _fechaFinSelected = '';
  String get fechaFinSelected => _fechaFinSelected;

  void setFechaFinSelected(String value) {
    _fechaFinSelected = value;
    notifyListeners();
  }

  //dropdown para ver el tipo de medicion de progreso
  String _dropTipoProgreso = '';
  String get dropTipoProgreso => _dropTipoProgreso;
    
  void setDropTipoProgreso(String value) {
    _dropTipoProgreso = value;
    if (value == 'Progreso numérico') {
      setwidgetTipoProgreso(1);
    } else if (value == 'Progreso por tareas') {
      setwidgetTipoProgreso(2);
    } else {
      setwidgetTipoProgreso(0);
    }
    notifyListeners();
  }

  // para mostrar los tipos de progreso en widgets segun lo seleccionado
  int _widgetTipoProgreso = 0;
  int get widgetTipoProgreso => _widgetTipoProgreso;
  void setwidgetTipoProgreso(int value) {
    _widgetTipoProgreso = value;
    notifyListeners();
  }

  //obtiene porcentaje de objetivo
  TareaPorcentajeHome _objetivoPorcentajeHome = TareaPorcentajeHome( porcentaje: 0, mensaje: 'No hay Mensaje');
  TareaPorcentajeHome get getObjetivoPorcentajeHome => _objetivoPorcentajeHome;

  Future<void> getObjetivosPorcentajeHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(Uri.parse('${_urlBase}tareas/objetivos-porcentaje'), headers: headers);
    print("···················"+response.body);


    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        final resp = ModelTareaPorcentajeHome.fromJson(jsonResponse);
        _objetivoPorcentajeHome = resp.data;
        //setLoadignBusqueda(false);
        notifyListeners();
      } else {
        throw Exception('1111Error en la solicitud al servidor: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('1111Error al obtener los datos de la API: $e');
    }
  }
  //lista de tareas para los objetivos

  List<TareaObjetivo> _tareaObjetivo = [];
  List<TareaObjetivo> get tareaObjetivo => _tareaObjetivo;

  Future<void> getTareasObjetivos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(Uri.parse('${_urlBase}tareas/get-tareas'),
        headers: headers);

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    try {
      if (jsonResponse['code'] == 200) {
        final resp = modelTareasObjetivoFromJson(response.body);
        _tareaObjetivo.clear();
        _tareaObjetivo.addAll(resp.data);
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

  //SELECCIONADOS DE LAS TAREAS

  List<int> selectedTareasList = [];

  void toggleSelectionTarea(int tareaId) {
    if (selectedTareasList.contains(tareaId)) {
      selectedTareasList.remove(tareaId);
    } else {
      selectedTareasList.add(tareaId);
    }
    notifyListeners();
  }

  bool isSelectedTarea(int tareaId) {
    return selectedTareasList.contains(tareaId);
  }


  //lista de datos filtrados

  List<TareaObjetivo> _listaFiltradaTarea = [];

  List<TareaObjetivo> get listaFiltradaTarea => _listaFiltradaTarea;

  void filtrarListaTarea(List<TareaObjetivo> listaCompleta, String query) {
    _listaFiltradaTarea = listaCompleta
        .where((elemento) => elemento.tiruloTarea.contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  //checkbox si poner recompensa
  bool _isCheckedAddRecompensa = false;
  bool get isCheckedAddRecompensa => _isCheckedAddRecompensa;
  void setCheckAddRecompensa(bool value) {
    _isCheckedAddRecompensa = value;
    notifyListeners();
  }

  //METODO PARA ENVIAR TODO A LA API

  Future<bool> enviarDatosCrearObjetivo(
      Map<String, dynamic> datosEnviar) async {
    String urlFinal = '${_urlBase}tareas/crear-objetivo';

    setLoadingDatosCrearObjetivo(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final datos = datosEnviar;

    String body = jsonEncode(datos);
    print(body);

    final response =
        await http.post(Uri.parse(urlFinal), headers: headers, body: body);

    final jsonResponse = jsonDecode(response.body);

    try {
      if (jsonResponse['code'] == 200) {
        print('Solicitud exitosa');

        setLoadingDatosCrearObjetivo(false);
        setOKsendDatosCrearObjetivo(true);
        notifyListeners();
        print(datosEnviar);
        return okpostDatosCrearObjetivo;
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');
        setLoadingDatosCrearObjetivo(false);
        setOKsendDatosCrearObjetivo(false);
        notifyListeners();
        return okpostDatosCrearObjetivo;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosCrearObjetivo(false);
      setOKsendDatosCrearObjetivo(false);
      notifyListeners();
      return okpostDatosCrearObjetivo;
    }
  }

  //GET PARA VER TAREA

  bool _loadingDatosParaDetalleTarea = false;
  bool get loadingDatosParaDetalleTarea => _loadingDatosParaDetalleTarea;

  setLoadingDatosParaDetalleTarea(bool value) {
    _loadingDatosParaDetalleTarea = value;
    notifyListeners();
  }

  final List<Tarea> _verTareaDetalle = [];
  List<Tarea> get getVerTareaDetalle => _verTareaDetalle;

  Future<bool> getVerTareaID(int idTarea) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http
        .get(Uri.parse('${_urlBase}tareas/tarea/$idTarea'), headers: headers);

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    try {
      if (jsonResponse['code'] == 200) {
        final resp = modelVerTareaFromJson(response.body);
        _verTareaDetalle.clear();
        _verTareaDetalle.add(resp.data);
        print(jsonResponse);
        setLoadingDatosParaDetalleTarea(true);
        notifyListeners();
        return loadingDatosParaDetalleTarea;
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');
        setLoadingDatosParaDetalleTarea(false);
        notifyListeners();
        return loadingDatosParaDetalleTarea;
      }
    } catch (e) {
      setLoadingDatosParaDetalleTarea(false);
      notifyListeners();
      return loadingDatosParaDetalleTarea;
    }
  }

  //metodo para actualizar tareas
  Future<http.Response> cambiarEstadoDeSubtarea(
      int subtareaId, String action) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };
    //final body = {'tareaId': tareaId, 'subtareaId': subtareaId};

    final response = await http.get(
        Uri.parse(
            '${_urlBase}tareas/detalle-subaccion?accion=$action&sub_id=$subtareaId'),
        headers: headers);

    return response;
  }

  //funcion para actualizar la lista de subtareas de acuerdo a la respuesta de la peticon a la api
  Future<void> toggleSubtarea(int subtareaId, String action) async {
    try {
      final response = await cambiarEstadoDeSubtarea(subtareaId, action);
      final resDecode = jsonDecode(response.body);

      if (resDecode['code'] == 200) {
        // La solicitud a la API fue exitosa, actualiza el estado local
        for (var tarea in _verTareaDetalle) {
          for (var subtarea in tarea.subtareas.subtareas) {
            if (subtarea.subtareaId == subtareaId) {
              subtarea.estado = (action == 'check') ? 'REALIZADO' : 'PENDIENTE';
              notifyListeners();
              break;
            }
          }
        }
      } else {
        // Manejo de errores si la API devuelve un código de estado no exitoso
        print('Error al actualizar el estado de la subtarea en la API');
      }
    } catch (error) {
      // Manejo de errores si ocurre una excepción durante la solicitud a la API
      print('Error en la solicitud a la API: $error');
    }
  }

  //para tablero de objetivos
  //FUNCION PARA LOS BOTONES SCROLEABLES HORIZONTALMENTE de objetivos
  int _selectedButtonObjIndex = 0; // Índice del botón seleccionado

  int get selectedButtonObjIndex => _selectedButtonObjIndex;

  void setSelectObjButton(int index) {
    _selectedButtonObjIndex = index;
    notifyListeners();
  }

  //metodo para listar por fechas

  bool loadingTableroObjetivo = false;
  void setLoadignTableroObjetivo(bool value) {
    loadingTableroObjetivo = value;
    notifyListeners();
  }

  List<Objetivos> _tableroObjetivos = [];
  List<Objetivos> get tableroObjetivosList => _tableroObjetivos;

  Future<void> getTableroObjetivosList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };
    setLoadignTableroObjetivo(true);

    final response = await http.get(
        Uri.parse('${_urlBase}tareas/tablero-objetivos'),
        headers: headers);

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    try {
      if (jsonResponse['code'] == 200) {
        final resp = modelTableroObjetivosFromJson(response.body);
        _tableroObjetivos.clear();
        _tableroObjetivos.addAll(resp.data);

        setLoadignTableroObjetivo(false);
        notifyListeners();
        print(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener los datos de la API');
      }
    } catch (e) {
      print('Error al obtener los datos de la API');
    }
  }

//lista de datos filtrados medieante botones para el lsitado en ekl tablero de objetivos egun el estado de cada objetivo

  List<Objetivos> _listaFiltradaTabObjetivo = [];

  List<Objetivos> get listaFiltradaTabObjetivo => _listaFiltradaTabObjetivo;

  void filtrarListaTableroObjetivo(
      List<Objetivos> listaCompleta, String query) {
    if (query == 'TODOS') {
      _listaFiltradaTabObjetivo = listaCompleta;
    } else {
      _listaFiltradaTabObjetivo = listaCompleta
          .where((elemento) =>
              elemento.estado.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  //listando actividada reciente en tareas

  List<ActRecienteTarea> _tareasActReciente = [];
  List<ActRecienteTarea> get getTareasActReciente => _tareasActReciente;

  Future<void> getActRecienteTareas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(
        Uri.parse('${_urlBase}tareas/actividad-reciente'),
        headers: headers);

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    try {
      if (jsonResponse['code'] == 200) {
        final resp = modelActividadRecienteTareasFromJson(response.body);
        _tareasActReciente.clear();
        _tareasActReciente.addAll(resp.data);
        //setLoadignBusqueda(false);
        notifyListeners();
        print(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener los datos de la API');
      }
    } catch (e) {
      print('Error al obtener los datos de la API');
    }
  }

  //listando tareas en progreso

  List<TareaProgreso> _tareasProgreso = [];
  List<TareaProgreso> get tareasProgreso => _tareasProgreso;

  Future<void> getTareasProgreso() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http
        .get(Uri.parse('${_urlBase}tareas/tareas-progreso'), headers: headers);

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    try {
      if (jsonResponse['code'] == 200) {
        final resp = modelTareaProgresoFromJson(response.body);
        _tareasProgreso.clear();
        _tareasProgreso.addAll(resp.data);
        //setLoadignBusqueda(false);
        notifyListeners();
        print(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener los datos de la API');
      }
    } catch (e) {
      print('Error al obtener los datos de la API');
    }
  }

  //eliminar tarea

  //ok para POST de eliminar tarea

  bool _OKpostEliminarTarea = false;
  bool get OkpostEliminarTarea => _OKpostEliminarTarea;

  setOKsendEliminarTarea(bool value) {
    _OKpostEliminarTarea = value;
    notifyListeners();
  }

  Future<bool> eliminarTarea(int idTareaf) async {
    String urlFinal = '${_urlBase}tareas/eliminar-tarea/$idTareaf';

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.delete(Uri.parse(urlFinal), headers: headers);

    final jsonResponse = jsonDecode(response.body);

    try {
      if (jsonResponse['code'] == 200) {
        print('Solicitud exitosa');
        getTareasProgreso();

        setOKsendEliminarTarea(true);
        getTableroObjetivosList();
        notifyListeners();
        return OkpostEliminarTarea;
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');

        setOKsendEliminarTarea(false);
        notifyListeners();
        return OkpostEliminarTarea;
      }
    } catch (e) {
      print('errooorrr $e');

      setOKsendEliminarTarea(false);
      notifyListeners();
      return OkpostEliminarTarea;
    }
  }

  //ok para POST de mover estado de tarea

  bool _OKpostMoverEstadoTarea = false;
  bool get OkpostMoverEstadoTarea => _OKpostMoverEstadoTarea;

  setOKsendMoverEstadoTarea(bool value) {
    _OKpostMoverEstadoTarea = value;
    notifyListeners();
  }

  Future<bool> moverEstadoTarea(int idTareaf, String estado) async {
    String urlFinal =
        '${_urlBase}tareas/mover-tarea?tarea_id=$idTareaf&estado=$estado';

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
        getTareasProgreso();

        setOKsendMoverEstadoTarea(true);
        getTableroObjetivosList();
        notifyListeners();
        return OkpostMoverEstadoTarea;
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');

        setOKsendMoverEstadoTarea(false);
        notifyListeners();
        return OkpostMoverEstadoTarea;
      }
    } catch (e) {
      print('errooorrr $e');

      setOKsendMoverEstadoTarea(false);
      notifyListeners();
      return OkpostMoverEstadoTarea;
    }
  }
}
