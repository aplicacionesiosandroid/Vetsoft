import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/clinica/buscarPacientes_model.dart';
import '../../../models/clinica/consulta/especiesDropdown.dart';
import '../../../models/clinica/consulta/razasDropdown.dart';
import '../../config/global/global_variables.dart';
import '../../models/peluqueria/encargadosPeluqueros.dart';

class ProgramarCitaPeluProvider extends ChangeNotifier {
  final String _urlBase = apiUrlGlobal;

  ProgramarCitaPeluProvider() {
    getEspeciesDropdown();
    getRazasDropdown();
    getEncargadosPeluqueria();
    // getBusquedasPaciente();
  }

  //PARA SABER SI EL NUEVO O ANTIGUO PACIENTE

  int _selectedSquarePCitaPelu = 0;
  int get selectedSquarePCitaPelu => _selectedSquarePCitaPelu;

  void setSelectSquarePCitaPelu(int square) {
    _selectedSquarePCitaPelu = square;
    notifyListeners();
  }
  //Radio Buttons Meses Años
  String _selectedTypeAge = '';

  String get selectedTypeAge => _selectedTypeAge;

  void setselectedAge(String Age) {
    _selectedTypeAge = Age;
    notifyListeners();
  }
  //POST PARA ANTIGUO

  //para limpiar lista de busquedas

  void clearBusquedas() {
    _resultadoBusquedasPaciente.clear();
    _listaFiltrada.clear();
  }

  //obteniendo busqueda de pacientes
  List<ResultBusPacientes> _resultadoBusquedasPaciente = [];
  List<ResultBusPacientes> get getResultadoBusquedasPaciente =>
      _resultadoBusquedasPaciente;

  Future<void> getBusquedasPaciente() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    Map<String, String> body = {
      'nombre': '',
    };

    final response = await http.post(
        Uri.parse('${_urlBase}clinica/buscar-paciente-propietario'),
        headers: headers,
        body: body);

    if (response.statusCode == 200) {
      final resp = buscarPacientesFromJson(response.body);

      _resultadoBusquedasPaciente.clear();
      _resultadoBusquedasPaciente.addAll(resp.data);

      notifyListeners();
    } else {
      throw Exception('Error al obtener los datos de la API');
    }
  }

  //lista de datos filtrados

  List<ResultBusPacientes> _listaFiltrada = [];

  List<ResultBusPacientes> get listaFiltrada => _listaFiltrada;

  void filtrarLista(List<ResultBusPacientes> listaCompleta, String query) {
    _listaFiltrada = listaCompleta
        .where((elemento) =>
            elemento.nombrePaciente
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            elemento.nombrePropietario
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void filtrarLista2( String query) {
    _listaFiltrada = _resultadoBusquedasPaciente
        .where((elemento) =>
    elemento.nombrePaciente
        .toLowerCase()
        .contains(query.toLowerCase()) ||
        elemento.nombrePropietario
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  //para saber cual fue seleccionado en la Busqueda, y marque de color el borde

  int _selectedIndexPaciente = -1;

  int get selectedIndexPaciente => _selectedIndexPaciente;

  void setSelectedIndexPaciente(int index) {
    _selectedIndexPaciente = index;
    notifyListeners();
  }

  //id del paciente antiguo seleccionado

  String _selectedIdPacienteAntiguo = '';

  String get selectedIdPacienteAntiguo => _selectedIdPacienteAntiguo;

  void setSelectedIdPacienteAntiguo(String index) {
    _selectedIdPacienteAntiguo = index;
    notifyListeners();
  }

  //POST PARA NUEVO
  //POST PARA DESPARACITACION

  //loading mientras envian los datos
  bool _loadingDatosPCitaPelu = false;
  bool get loadingDatosPCitaPelu => _loadingDatosPCitaPelu;

  setLoadingDatosPCitaPelu(bool value) {
    _loadingDatosPCitaPelu = value;
    notifyListeners();
  }

  //cambio a true si el POST se realizo de manera correcta
  bool _OKpostDatosPCitaPelu = false;
  bool get OkpostDatosPCitaPelu => _OKpostDatosPCitaPelu;

  setOKsendDatosPCitaPelu(bool value) {
    _OKpostDatosPCitaPelu = value;
    notifyListeners();
  }

  //DATOS FORM DUENO (TODO SE RECIBE DE TEXTEDITING)

  //DATOS FORM PACIENTE

  //obteniendo listado de especies
  List<Especie> _especies = [];
  List<Especie> get getEspecies => _especies;

  Future<void> getEspeciesDropdown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(Uri.parse('${_urlBase}formulario/especies'),
        headers: headers);

    if (response.statusCode == 200) {
      final resp = especiesFromJson(response.body);
      _especies.addAll(resp.data);

      notifyListeners();
    } else {
      throw Exception('Error al obtener los datos de la API');
    }
  }

  //obteniendo listado de razas
  List<Raza> _razas = [];
  List<Raza> get getRazas => _razas;

  Future<void> getRazasDropdown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(Uri.parse('${_urlBase}formulario/razas'),
        headers: headers);

    if (response.statusCode == 200) {
      final resp = razasFromJson(response.body);
      _razas.addAll(resp.data);

      notifyListeners();
    } else {
      throw Exception('Error al obtener los datos de la API');
    }
  }
//Añadir una raza
  Future<void> setNewRaza(String nombreRaza) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    Map<String, String> body = {
      'raza': nombreRaza,
    };

    final response = await http.post(
        Uri.parse('${_urlBase}formulario/crear-raza'), headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['error'] == false) {
        final newRazaData = responseData['data'];
        int newRazaId = newRazaData['id'];
        String newRazaNombre = newRazaData['nombre'];
        Raza newRaza = Raza(id: newRazaId, nombre: newRazaNombre.toUpperCase());
        _razas.add(newRaza);

        setSelectedIdRaza(newRazaId.toString());
        notifyListeners();
      } else {
        print('Error en la respuesta del servidor: ${responseData['message']}');
      }
    } else {
      print('Error en la solicitud HTTP: ${response.statusCode}');
    }
  }
  // Dropdowns dinamicos
  String? selectedIdEspecie;

  void setSelectedIdEspecie(String? id) {
    selectedIdEspecie = id;
    notifyListeners();
  }

  String? selectedIdRaza;

  void setSelectedIdRaza(String? id) {
    selectedIdRaza = id;
    notifyListeners();
  }

  //dropdown estaticos
  String _dropTamanoMascota = '';
  String get dropTamanoMascota => _dropTamanoMascota;
  void setDropTamanoMascota(String value) {
    _dropTamanoMascota = value;
    notifyListeners();
  }

  String _dropTemperamento = '';
  String get dropTemperamento => _dropTemperamento;
  void setDropTemperamento(String value) {
    _dropTemperamento = value;
    notifyListeners();
  }

  String _dropAlimentacion = '';
  String get dropAlimentacion => _dropAlimentacion;
  void setDropAlimentacion(String value) {
    _dropAlimentacion = value;
    notifyListeners();
  }

  //Radio Buttons
  String _selectedSexoPaciente = '';

  String get selectedSexoPaciente => _selectedSexoPaciente;

  void setSelectedGender(String gender) {
    _selectedSexoPaciente = gender;
    notifyListeners();
  }

  //Cargando la imagen del paciente
  XFile? image;
  File? lastImage;

  Future addPhoto() async {
    image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      lastImage = File(image!.path);
      notifyListeners();
    }
  }

  //DATOS FORM PROXIMA VISITA

  //Listando encargados
  List<EncarPeluqueros> _encargadosPelu = [];
  List<EncarPeluqueros> get getEncargadosPelu => _encargadosPelu;

  Future<void> getEncargadosPeluqueria() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http
        .get(Uri.parse('${_urlBase}formulario/peluqueros'), headers: headers);

    if (response.statusCode == 200) {
      final resp = modelPeluquerosFromJson(response.body);
      _encargadosPelu.addAll(resp.data);

      notifyListeners();
    } else {
      throw Exception('Error al obtener los datos de la API');
    }
  }
  //Almacenar fecha de proxima visita

  String _fechaVisitaSelected = '';
  String get fechaVisitaSelected => _fechaVisitaSelected;

  void setFechaVisitaSelected(String value) {
    _fechaVisitaSelected = value;
    notifyListeners();
  }

  //Almacenar hora de proxima visita

  String _horaSelected = '';
  String get horaSelected => _horaSelected;

  void setHoraSelected(String value) {
    _horaSelected = value;
    notifyListeners();
  }

  //Almacenar ID e INICIAL del encargado

  String _idEncargadoSelected = '';
  String get idEncargadoSelected => _idEncargadoSelected;

  void setIdEncargadoSelected(String value) {
    _idEncargadoSelected = value;
    notifyListeners();
  }

  String _inicialEncargado = '';
  String get inicialEncargado => _inicialEncargado;

  void setInicialEncargado(String value) {
    _inicialEncargado = value;
    notifyListeners();
  }

  //METODO PARA ENVIAR TODO A LA API

  Future<bool> enviarDatos(
      //propietario
      String ciPropietariof,
      String nombrePropietariof,
      String apellidoPropietariof,
      String celularPropietariof,
      String direccionPropietariof,

      //paciente
      String nombrePacientef,
      String sexoPacientef,
      String edadPacientef,
      String especieIdPacientef,
      String razaIdPacientef,
      String tamanoPacientef,
      String temperamentoPacientef,
      String alimentacionPacientef,
      File fotoPacientef,

      //proxima visita

      String fechaProxVisitaf,
      String horaProxVisitaf,
      String idEncargadoProxVisitaf) async {
    String urlFinal = '${_urlBase}peluqueria/programar-cita-nuevo';

    setLoadingDatosPCitaPelu(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    var request = http.MultipartRequest('POST', Uri.parse(urlFinal));
    request.headers.addAll(headers);

    //DATOS DEL PROPIETARIO
    request.fields['propietario[nombres]'] = nombrePropietariof;
    request.fields['propietario[apellidos]'] = apellidoPropietariof;
    request.fields['propietario[celular]'] = celularPropietariof;
    request.fields['propietario[direccion]'] = direccionPropietariof;
    request.fields['propietario[documento]'] = ciPropietariof;

    //DATOS DEL PACIENTE
    request.fields['paciente[nombre]'] = nombrePacientef;
    request.fields['paciente[sexo]'] = sexoPacientef;
    request.fields['paciente[edad]'] = edadPacientef;
    request.fields['paciente[especie_id]'] = especieIdPacientef;
    request.fields['paciente[raza_id]'] = razaIdPacientef;
    request.fields['paciente[tamaño]'] = tamanoPacientef;
    request.fields['paciente[temperamento]'] = temperamentoPacientef;
    request.fields['paciente[alimentacion]'] = alimentacionPacientef;

    var tempDir = Directory.systemTemp;
    var tempFilePath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    await fotoPacientef.copy(tempFilePath);

    var imageUploadFotoPaciente = await http.MultipartFile.fromPath(
        'archivo[foto_paciente]', tempFilePath);

    request.files.add(imageUploadFotoPaciente);


    //DATOS DE PROXIMA VISITA
    request.fields['servicios_esteticos[fecha_proxima_visita]'] = fechaProxVisitaf;
    request.fields['servicios_esteticos[hora_proxima_visita]'] = '$horaProxVisitaf:00';
    request.fields['servicios_esteticos[encargado_id]'] = idEncargadoProxVisitaf;


    //AQUI YA SE ESTA ENVIANDO TODO

    final response = await request.send();
    var responseStream = await response.stream.bytesToString();
    var responseData = jsonDecode(responseStream);

    try {
      if (responseData['code'] == 200 &&
          responseData['data']['ficha_peluqueria_id'] != '') {
        print('Solicitud exitosa');
        print('Respuesta: ${responseStream}');
        print('Data decodificada: ${responseData['data']}');

        setLoadingDatosPCitaPelu(false);
        setOKsendDatosPCitaPelu(true);
        notifyListeners();
        return OkpostDatosPCitaPelu;
      } else {
        print('Error en la solicitud: ${responseData['data']}');
        setLoadingDatosPCitaPelu(false);
        setOKsendDatosPCitaPelu(false);
        notifyListeners();
        return OkpostDatosPCitaPelu;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosPCitaPelu(false);
      setOKsendDatosPCitaPelu(false);
      notifyListeners();
      return OkpostDatosPCitaPelu;
    }
  }

  //METODO PARA ENVIAR TODO A LA API

  Future<bool> enviarDatosAntiguo(

      //paciente
      String idPacientef,

      //proxima visita

      String fechaProxVisitaf,
      String horaProxVisitaf,
      String idEncargadoProxVisitaf) async {
    String urlFinal = '${_urlBase}peluqueria/programar-cita-antiguo/$idPacientef';

    setLoadingDatosPCitaPelu(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    var request = http.MultipartRequest('POST', Uri.parse(urlFinal));
    request.headers.addAll(headers);

    //DATOS DE PROXIMA VISITA
    request.fields['servicios_esteticos[fecha_proxima_visita]'] = fechaProxVisitaf;
    request.fields['servicios_esteticos[hora_proxima_visita]'] = '$horaProxVisitaf:00';
    request.fields['servicios_esteticos[hora_entrega]'] = '$horaProxVisitaf:00';
    request.fields['servicios_esteticos[encargado_id]'] = idEncargadoProxVisitaf;


    //AQUI YA SE ESTA ENVIANDO TODO

    final response = await request.send();
    var responseStream = await response.stream.bytesToString();
    var responseData = jsonDecode(responseStream);

    try {
      if (responseData['code'] == 200 &&
          responseData['data']['ficha_peluqueria_id'] != '') {
        print('Solicitud exitosa');
        print('Respuesta: ${responseStream}');
        print('Data decodificada: ${responseData['data']}');

        setLoadingDatosPCitaPelu(false);
        setOKsendDatosPCitaPelu(true);
        notifyListeners();
        return OkpostDatosPCitaPelu;
      } else {
        print('Error en la solicitud: ${responseData['data']}');
        setLoadingDatosPCitaPelu(false);
        setOKsendDatosPCitaPelu(false);
        notifyListeners();
        return OkpostDatosPCitaPelu;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosPCitaPelu(false);
      setOKsendDatosPCitaPelu(false);
      notifyListeners();
      return OkpostDatosPCitaPelu;
    }
  }
}
