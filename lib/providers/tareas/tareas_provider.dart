import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/models/agenda/response_agenda.dart';
import 'package:vet_sotf_app/models/clinica/consulta/veterinariosEncargados.dart';
import 'package:vet_sotf_app/models/tareas/etiquetas_tareas_model.dart';
import 'package:vet_sotf_app/models/tareas/model_tareas_progreso.dart';
import 'package:vet_sotf_app/models/tareas/participantes_tareas_model.dart';
import 'package:vet_sotf_app/models/tareas/tareas_fecha_model.dart';

import '../../config/global/global_variables.dart';
import '../../models/tareas/model_act_rec_tareas.dart';
import '../../models/tareas/verTarea_model.dart';

class TareasProvider extends ChangeNotifier {
  final String _urlBase = apiUrlGlobal;

  TareasProvider() {
    getTareasPorcentajeHome();
    getActRecienteTareas();
    getTareasProgreso();
  }

  //PACIENTE NUEVO
  //POST PARA CIRUGIA

  //loading mientras envian los datos
  bool _loadingDatosCrearTarea = false;
  bool get loadingDatosCrearTarea => _loadingDatosCrearTarea;

  setLoadingDatosCrearTarea(bool value) {
    _loadingDatosCrearTarea = value;
    notifyListeners();
  }

  //cambio a true si el POST se realizo de manera correcta
  bool _oKpostDatosCrearTarea = false;
  bool get okpostDatosCrearTarea => _oKpostDatosCrearTarea;

  setOKsendDatosCrearTarea(bool value) {
    _oKpostDatosCrearTarea = value;
    notifyListeners();
  }

  //DATOS PARA CREAR TAREA

  //controller para titulo de tarea, es un controller

  //dropdown estado de la tarea
  String _dropEstadoTarea = '';
  String get dropEstadoTarea => _dropEstadoTarea;
  void setDropEstadoTarea(String value) {
    _dropEstadoTarea = value;
    notifyListeners();
  }

  //Listando ETIQUETAS
  List<EtiquetaTarea> _etiquetasTarea = [];
  List<EtiquetaTarea> get getEtiquetasTarea => _etiquetasTarea;

  Future<void> getEtiquetasTareas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http
        .get(Uri.parse('${_urlBase}formulario/etiquetas'), headers: headers);

    if (response.statusCode == 200) {
      final resp = modelEtiquetasTareasFromJson(response.body);
      _etiquetasTarea.clear();
      _etiquetasTarea.addAll(resp.data);

      notifyListeners();
    } else {
      throw Exception('Error al obtener los datos de la API');
    }
  }

  //SELECCIONADOS DE LAS ETIQUETAS

  Map<int, String> selectedEtiquetasMap = {};
  List<int> selectedEtiquetasList = [];

  void toggleSelectionEtiquetaMap(int etiquetaId, String nombre) {
    if (selectedEtiquetasMap.containsKey(etiquetaId)) {
      selectedEtiquetasMap.remove(etiquetaId);
      if (selectedEtiquetasList.contains(etiquetaId)) {
        selectedEtiquetasList.remove(etiquetaId);
      }
    } else {
      selectedEtiquetasMap[etiquetaId] = nombre;
      selectedEtiquetasList.add(etiquetaId);
    }
    notifyListeners();
  }

  bool isSelectedEtiquetaMap(int etiquetaId) {
    return selectedEtiquetasMap.containsKey(etiquetaId);
  }

  //BUSQUEDA DE ETIQUETAS

  //lista de datos filtrados

  List<EtiquetaTarea> _listaFiltradaEtiquetas = [];

  List<EtiquetaTarea> get listaFiltradaEtiquetas => _listaFiltradaEtiquetas;

  void filtrarListaEtiqueta(List<EtiquetaTarea> listaCompleta, String query) {
    _listaFiltradaEtiquetas = listaCompleta
        .where((elemento) =>
            elemento.nombre.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  //Listando PARTICIPANTES
  List<ParticipanteTarea> _participantesTarea = [];
  List<ParticipanteTarea> get getParticipantesTarea => _participantesTarea;

  Future<void> getParticipantesTareas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(
        Uri.parse('${_urlBase}formulario/participantes'),
        headers: headers);

    final responseData = jsonDecode(response.body);

    if (responseData['code'] == 200) {
      final resp = modelParticipantesTareasFromJson(response.body);
      _participantesTarea.clear();
      _participantesTarea.addAll(resp.data);

      notifyListeners();
    } else {
      throw Exception('Error al obtener los datos de la API');
    }
  }

  Future<void> setParticipantesTareas(List<EncargadosVete> listaVeterinarios ) async {
    _participantesTarea.clear();
    listaVeterinarios.forEach((element) {
      _participantesTarea.add(ParticipanteTarea(
                              encargadoId: element.encargadoVeteId,
                              nombres: element.nombres,
                              apellidos: element.apellidos,
                              itemName: element.nombres,
                              imgUser: element.imgUser));

    });
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

  void setearDatos(){
    selectedParticipantsMap = {};
    selectedParticipantsList = [];
  }

  Future<void> setToggleSelectionMap(ClinicaModel clinicaModelo ) async {
    clinicaModelo.responsables.forEach((element) {
        print('lista responsable ${element.responsableId} ${element.responsableFoto}');
        toggleSelectionMap(element.responsableId,element.responsableFoto);
      });
  }


  bool isSelectedMap(int participantId) {
    return selectedParticipantsMap.containsKey(participantId);
  }

  //BUSQUEDA DE PARTICIPANTES

  //lista de datos filtrados

  List<ParticipanteTarea> _listaFiltradaParticipante = [];

  List<ParticipanteTarea> get listaFiltradaParticipante =>
      _listaFiltradaParticipante;

  void filtrarListaParticipante(List<ParticipanteTarea> listaCompleta, String query) {
    _listaFiltradaParticipante = listaCompleta
        .where((elemento) =>
            elemento.nombres.toLowerCase().contains(query.toLowerCase()) ||
            elemento.apellidos.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  //checkbox si poner fecha inicio y fin
  bool _isCheckedFechaIniFin = false;
  bool get isCheckedFechaIniFin => _isCheckedFechaIniFin;
  void setCheckFechaIniFin(bool value) {
    _isCheckedFechaIniFin = value;
    if (!value) {
      _fechaInicioSelected = '';
      _fechaFinSelected = '';
    }
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

  //SUBTAREAS

  List<TextEditingController> controllersSubtareas = [];

  void agregarSubTareas() {
    controllersSubtareas.add(TextEditingController());
    for (var controller in controllersSubtareas) {
      print(controller.text);
    }
    notifyListeners();
  }

  void eliminarSubTarea(int index) {
    if (index >= 0 && index < controllersSubtareas.length) {
      controllersSubtareas[index].dispose();
      controllersSubtareas.removeAt(index);
      notifyListeners();
    }
  }

  //METODO PARA ENVIAR TODO A LA API

  Future<bool> enviarDatosCrearTarea(
      String titulotareaf,
      String estadoTareaf,
      List<int> etiquetasTareasf,
      List<int> participantesTareaf,
      String fechaInicioTareaf,
      String fechaFinalTareaf,
      String descripcionTareaf,
      List<TextEditingController> subTareasTareasf) async {
    String urlFinal = '${_urlBase}tareas/crear-tarea';

    List<String> subtareasString = [];
    for (var controller in subTareasTareasf) {
      subtareasString.add(controller.text);
    }

    setLoadingDatosCrearTarea(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final datos = <String, dynamic>{
      'titulo': titulotareaf,
      'estado': estadoTareaf,
      'etiquetas': etiquetasTareasf,
      'participantes': participantesTareaf,
      'fecha_inicio': fechaInicioSelected,
      'fecha_fin': fechaFinalTareaf,
      'descripcion': descripcionTareaf,
      'subtareas': subtareasString
    }; // Cuerpo de

    String body = jsonEncode(datos);
    print(body);

    final response =
        await http.post(Uri.parse(urlFinal), headers: headers, body: body);

    final jsonResponse = jsonDecode(response.body);

    try {
      if (jsonResponse['code'] == 200 &&
          jsonResponse['data']['tarea_id'] != '') {
        print('Solicitud exitosa');

        setLoadingDatosCrearTarea(false);
        setOKsendDatosCrearTarea(true);
        notifyListeners();
        return okpostDatosCrearTarea;
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');
        setLoadingDatosCrearTarea(false);
        setOKsendDatosCrearTarea(false);
        notifyListeners();
        return okpostDatosCrearTarea;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosCrearTarea(false);
      setOKsendDatosCrearTarea(false);
      notifyListeners();
      return okpostDatosCrearTarea;
    }
  }





  //loading mientras envian los datos
  bool _loadingDatosCrearTareaDash = false;
  bool get loadingDatosCrearTareaDash => _loadingDatosCrearTareaDash;

  setLoadingDatosCrearTareaDash(bool value) {
    _loadingDatosCrearTareaDash = value;
    notifyListeners();
  }

  //cambio a true si el POST se realizo de manera correcta
  bool _oKpostDatosCrearTareaDash = false;
  bool get okpostDatosCrearTareaDash => _oKpostDatosCrearTareaDash;

  setOKsendDatosCrearTareaDash(bool value) {
    _oKpostDatosCrearTareaDash = value;
    notifyListeners();
  }

   Future<bool> enviarDatosCrearTareaDashBoard(
      String titulotareaf,
      String descripcionTareaf,
      List<int> etiquetasTareasf,
      List<int> participantesTareaf,
  ) async {
    String urlFinal = '${_urlBase}tareas/crear-tarea';


    setLoadingDatosCrearTareaDash(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final datos = <String, dynamic>{
      'titulo': titulotareaf,
      'descripcion': descripcionTareaf,
      'etiquetas': etiquetasTareasf,
      'participantes': participantesTareaf,   
    };

    String body = jsonEncode(datos);
    print(body);

    final response =
        await http.post(Uri.parse(urlFinal), headers: headers, body: body);

    final jsonResponse = jsonDecode(response.body);

    try {
      if (jsonResponse['code'] == 200) {
        print('Solicitud exitosa');

        setLoadingDatosCrearTareaDash(false);
        setOKsendDatosCrearTareaDash(true);
        notifyListeners();
        return okpostDatosCrearTareaDash;
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');
        setLoadingDatosCrearTareaDash(false);
        setOKsendDatosCrearTareaDash(false);
        notifyListeners();
        return okpostDatosCrearTareaDash;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosCrearTareaDash(false);
      setOKsendDatosCrearTareaDash(false);
      notifyListeners();
      return okpostDatosCrearTareaDash;
    }
  }

  //CREAR ETIQUETA

  String _almacenColorEtiqueta = '';
  String get almacenColorEtiqueta => _almacenColorEtiqueta;

  void setalmacenColorEtiqueta(String value) {
    _almacenColorEtiqueta = value;
    notifyListeners();
  }

  //loading mientras envian los datos de crear etiqeuta
  bool _loadingDatosCrearEtiqueta = false;
  bool get loadingDatosCrearEtiqueta => _loadingDatosCrearEtiqueta;

  setLoadingDatosCrearEtiqueta(bool value) {
    _loadingDatosCrearEtiqueta = value;
    notifyListeners();
  }

  //cambio a true si el POST se realizo de manera correcta la creacion de etiqueta
  bool _OKpostDatosCrearEtiqueta = false;
  bool get OkpostDatosCrearEtiqueta => _OKpostDatosCrearEtiqueta;

  setOKsendDatosCrearEtiqueta(bool value) {
    _OKpostDatosCrearEtiqueta = value;
    notifyListeners();
  }

//metodo para enviar datos a api crear etiqueta

  Future<bool> enviarDatosCrearEtiqueta(
    String tituloEtiquetaf,
    String colorEtiqueta,
  ) async {
    String urlFinal = '${_urlBase}tareas/crear-etiqueta';

    setLoadingDatosCrearEtiqueta(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final datos = <String, dynamic>{
      'nombre': tituloEtiquetaf,
      'color': colorEtiqueta,
    }; // Cuerpo de

    String body = jsonEncode(datos);
    print(body);

    final response =
        await http.post(Uri.parse(urlFinal), headers: headers, body: body);

    final jsonResponse = jsonDecode(response.body);

    try {
      if (jsonResponse['code'] == 200 &&
          jsonResponse['data']['tarea_id'] != '') {
        print('Solicitud exitosa');

        setLoadingDatosCrearEtiqueta(false);
        setOKsendDatosCrearEtiqueta(true);
        notifyListeners();
        return OkpostDatosCrearEtiqueta;
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');
        setLoadingDatosCrearEtiqueta(false);
        setOKsendDatosCrearEtiqueta(false);
        notifyListeners();
        return OkpostDatosCrearEtiqueta;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosCrearEtiqueta(false);
      setOKsendDatosCrearEtiqueta(false);
      notifyListeners();
      return OkpostDatosCrearEtiqueta;
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

  //FUNCION PARA LOS BOTONES SCROLEABLES HORIZONTALMENTE
  int _selectedButtonIndex = 0; // Índice del botón seleccionado

  int get selectedButtonIndex => _selectedButtonIndex;

  void setSelectButton(int index) {
    _selectedButtonIndex = index;
    notifyListeners();
  }

  //metodo para listar por fechas

  bool loadingBusqueda = false;
  void setLoadignBusqueda(bool value) {
    loadingBusqueda = value;
    notifyListeners();
  }

  List<Tareafecha> _tareasPorFecha = [];
  List<Tareafecha> get getTareasPorFecha => _tareasPorFecha;

  Future<void> getTareasFecha(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };
    setLoadignBusqueda(true);
    if (date.isEmpty) {
      DateTime nowDate = DateTime.now();
      final fechaDeHoy = DateFormat("yyyy-MM-dd").format(nowDate);
      date = fechaDeHoy;
    }

    final response = await http.get(
        Uri.parse('${_urlBase}tareas/tareas-dia?fecha=$date'),
        headers: headers);

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    try {
      if (jsonResponse['code'] == 200) {
        final resp = modelTareasFechaFromJson(response.body);
        _tareasPorFecha.clear();
        _tareasPorFecha.addAll(resp.data);
        filtrarListaTareasFecha(_tareasPorFecha, 'TODAS');
        setLoadignBusqueda(false);
        notifyListeners();
        print(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener los datos de la API');
      }
    } catch (e) {
      print('Error al obtener los datos de la API');
    }
  }

//lista de datos filtrados medieante botones para el lsitado de tareas segun su estado

  List<Tareafecha> _listaFiltradaTareaFechas = [];

  List<Tareafecha> get listaFiltradaTareaFechas => _listaFiltradaTareaFechas;

  void filtrarListaTareasFecha(List<Tareafecha> listaCompleta, String query) {
    //_listaFiltradaTareaFechas.clear();
    if (query == 'TODAS') {
      _listaFiltradaTareaFechas = listaCompleta;
    } else {
      _listaFiltradaTareaFechas = listaCompleta
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

  //obtiene porcentaje de tarea
  TareaPorcentajeHome _tareaPorcentajeHome = TareaPorcentajeHome( porcentaje: 0, mensaje: 'No hay Mensaje');
  TareaPorcentajeHome get getTareaPorcentajeHome => _tareaPorcentajeHome;

  Future<void> getTareasPorcentajeHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(Uri.parse('${_urlBase}tareas/tareas-porcentaje'), headers: headers);

    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        final resp = ModelTareaPorcentajeHome.fromJson(jsonResponse);
        _tareaPorcentajeHome = resp.data;
        //setLoadignBusqueda(false);
        notifyListeners();
      } else {
        throw Exception('Error en la solicitud al servidor: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error al obtener los datos de la API: $e');
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
        getTareasFecha('');
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
    String urlFinal = '${_urlBase}tareas/mover-tarea?tarea_id=$idTareaf&estado=$estado';

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
        getTareasFecha('');
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
