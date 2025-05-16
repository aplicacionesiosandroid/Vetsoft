import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vet_sotf_app/models/clinica/consulta/veterinariosEncargados.dart';

import '../../../config/global/global_variables.dart';
import '../../../models/clinica/buscarPacientes_model.dart';
import '../../../models/clinica/consulta/especiesDropdown.dart';
import '../../../models/clinica/consulta/razasDropdown.dart';

class VacunaProvider extends ChangeNotifier {
  final String _urlBase = apiUrlGlobal;
  final String _urlBaseImagen = imagenUrlGlobal;

  VacunaProvider() {
    getEspeciesDropdown();
    getRazasDropdown();
    getEncargadosConsulta();
  }

  int _fichaId = 0;
  int get fichaId => _fichaId;

  void setFichaId(int id) {
    _fichaId = id;
    notifyListeners();
  }

  //Radio Buttons Meses Años
  String _selectedTypeAge = '';

  String get selectedTypeAge => _selectedTypeAge;

  void setselectedAge(String Age) {
    _selectedTypeAge = Age;
    notifyListeners();
  }
  //PARA SABER SI EL NUEVO O ANTIGUO PACIENTE

  int _selectedSquareVacuna = 0;
  int get selectedSquareVacuna => _selectedSquareVacuna;

  void setSelectSquareVacuna(int square) {
    _selectedSquareVacuna = square;
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

  //PACIENTE NUEVO

  //POST PARA VACUNA

  //loading mientras envian los datos
  bool _loadingDatosVacuna = false;
  bool get loadingDatosVacuna => _loadingDatosVacuna;

  setLoadingDatosVacuna(bool value) {
    _loadingDatosVacuna = value;
    notifyListeners();
  }

  //cambio a true si el POST se realizo de manera correcta
  bool _OKpostDatosVacuna = false;
  bool get OkpostDatosVacuna => _OKpostDatosVacuna;

  setOKsendDatosVacuna(bool value) {
    _OKpostDatosVacuna = value;
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
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    Map<String, String> body = {
      'raza': nombreRaza,
    };

    final response = await http.post(
        Uri.parse('${_urlBase}formulario/crear-raza'),
        headers: headers,
        body: body);

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

  Future getFromUrl(String url) async {
    final response = await http.get(Uri.parse('$_urlBaseImagen$url'));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/${DateTime.now().millisecond}.jpg';
      final file = File(imagePath);
      await file.writeAsBytes(bytes);
      lastImage = file;
      notifyListeners();
    }
  }

  //DATOS DE VACUNA
  String _fechaExpiracion = '';

  String get fechaExpiracion => _fechaExpiracion;

  void setFechaExpiracion(String siOno) {
    _fechaExpiracion = siOno;
    notifyListeners();
  }

  String _fileArchivoVacuna = '';

  String get fileArchivoVacuna => _fileArchivoVacuna;

  void setArchivoVacuna(String value) {
    _fileArchivoVacuna = value;
    notifyListeners();
  }

  //DATOS FORM PROXIMA VISITA

  //Listando encargados
  List<EncargadosVete> _encargados = [];
  List<EncargadosVete> get getEncargados => _encargados;

  Future<void> getEncargadosConsulta() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http
        .get(Uri.parse('${_urlBase}formulario/veterinarios'), headers: headers);

    if (response.statusCode == 200) {
      final resp = modelVeterinariosFromJson(response.body);
      _encargados.addAll(resp.data);

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

  //Radiobutton EFECTIVO o TRANSACCION

  String _selectedEfectivoTransac = '';

  String get selectedEfectivoTransac => _selectedEfectivoTransac;

  void setSelectedEfectivoTransac(String value) {
    _selectedEfectivoTransac = value;
    notifyListeners();
  }
  //

  String _totalACobrarFacturacion = '';

  String get totalACobrarFacturacion => _totalACobrarFacturacion;

  set setTotalACobrarFacturacion(String value) {
    _totalACobrarFacturacion = value;
    notifyListeners();
  }

  //switch para saber si se guarda la facturacion

  bool _switchValueFacturacion = false;

  bool get switchValueFacturacion => _switchValueFacturacion;

  set setSwitchValueFacturacion(bool value) {
    _switchValueFacturacion = value;
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
    String? especieIdPacientef,
    String razaIdPacientef,
    String tamanoPacientef,
    String temperamentoPacientef,
    String alimentacionPacientef,
    File? fotoPacientef,

    //Cirugia

    String contraf,
    String laboratoriof,
    String serief,
    String procedenciaf,
    String expiracionf,
    String archivoVacunaf,

    //proxima visita

    String fechaProxVisitaf,
    String horaProxVisitaf,
    String idEncargadoProxVisitaf,
    //datos facturacion
    String tipoPagof,
    String ciNITf,
    String nombreFacf,
    String apellidoFacf,
    bool saveDatosFacturaf,
    String montoEfectivof,
  ) async {
    String urlFinal = '${_urlBase}clinica/ficha-vacuna';

    setLoadingDatosVacuna(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    var request = http.MultipartRequest('POST', Uri.parse(urlFinal));
    request.headers.addAll(headers);
    try {
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
      request.fields['paciente[especie_id]'] = especieIdPacientef ?? '';
      request.fields['paciente[raza_id]'] = razaIdPacientef;
      request.fields['paciente[tamaño]'] = tamanoPacientef;
      request.fields['paciente[temperamento]'] = temperamentoPacientef;
      request.fields['paciente[alimentacion]'] = alimentacionPacientef;

      if (fotoPacientef != null) {
        //GUARDAR FOTO DEL PACIENTE
        var tempDir = Directory.systemTemp;
        var tempFilePath =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await fotoPacientef.copy(tempFilePath);
        var imageUploadFotoPaciente = await http.MultipartFile.fromPath(
            'archivo[foto_paciente]', tempFilePath);
        request.files.add(imageUploadFotoPaciente);
      }

      //DATOS VACUNAe
      request.fields['vacuna[contra]'] = contraf;
      request.fields['vacuna[laboratorio]'] = laboratoriof;
      request.fields['vacuna[serie]'] = serief;
      request.fields['vacuna[procedencia]'] = procedenciaf;
      request.fields['vacuna[fechaExpiracion]'] = expiracionf;

      request.files.add(
          await http.MultipartFile.fromPath('archivo[vacuna]', archivoVacunaf));

      //DATOS DE PROXIMA VISITA
      request.fields['proxima_visita[fecha]'] = fechaProxVisitaf;
      request.fields['proxima_visita[hora]'] = '$horaProxVisitaf:00';
      request.fields['proxima_visita[encargado_id]'] = idEncargadoProxVisitaf;

      //DATOS FACTURACION
      request.fields['pago[metodo_pago]'] = tipoPagof;
      request.fields['pago[numero_documento]'] = ciNITf;
      request.fields['pago[nombres]'] = nombreFacf;
      request.fields['pago[apellidos]'] = apellidoFacf;
      request.fields['pago[guardar_datos]'] = saveDatosFacturaf.toString();
      request.fields['pago[monto]'] = montoEfectivof;
      request.fields['pago[tipo_servicio]'] = 'servicio_clinica';

      //AQUI YA SE ESTA ENVIANDO TODO

      //print(request.fields);

      final response = await request.send();
      var responseStream = await response.stream.bytesToString();
      var responseData = jsonDecode(responseStream);

      if (responseData['code'] == 200 && responseData['error'] == false) {
        print('Solicitud exitosa');
        print('Respuesta: ${responseStream}');
        print('Data decodificada vacuna: ${responseData['data']}');
        setLoadingDatosVacuna(false);
        setOKsendDatosVacuna(true);
        notifyListeners();
        return OkpostDatosVacuna;
      } else {
        print('Error en la solicitud en vacuna: ${responseData}');
        BotToast.showText(
            text: responseData['data'], duration: const Duration(seconds: 3));
        setLoadingDatosVacuna(false);
        setOKsendDatosVacuna(false);
        notifyListeners();
        return OkpostDatosVacuna;
      }
    } catch (e) {
      print('errooorrr en vacuna $e');
      BotToast.showText(
          text: e.toString(), duration: const Duration(seconds: 3));
      setLoadingDatosVacuna(false);
      setOKsendDatosVacuna(false);
      notifyListeners();
      return OkpostDatosVacuna;
    }
  }

  Future<bool> enviarDatosAntiguo(
    //paciente
    String idPacienteAntiguof,

    //Vacuna

    String contraf,
    String laboratoriof,
    String serief,
    String procedenciaf,
    String expiracionf,
    String archivoVacunaf,

    //proxima visita

    String fechaProxVisitaf,
    String horaProxVisitaf,
    String idEncargadoProxVisitaf,
    //datos facturacion
    String tipoPagof,
    String ciNITf,
    String nombreFacf,
    String apellidoFacf,
    bool saveDatosFacturaf,
    String montoEfectivof,
  ) async {
    String urlFinal = '${_urlBase}clinica/ficha-vacuna/$idPacienteAntiguof';

    setLoadingDatosVacuna(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    var request = http.MultipartRequest('POST', Uri.parse(urlFinal));
    request.headers.addAll(headers);
    try {
      //DATOS VACUNA

      request.fields['vacuna[contra]'] = contraf;
      request.fields['vacuna[laboratorio]'] = laboratoriof;
      request.fields['vacuna[serie]'] = serief;
      request.fields['vacuna[procedencia]'] = procedenciaf;
      request.fields['vacuna[fechaExpiracion]'] = expiracionf;

      request.files.add(
          await http.MultipartFile.fromPath('archivo[vacuna]', archivoVacunaf));

      //DATOS DE PROXIMA VISITA
      request.fields['proxima_visita[fecha]'] = fechaProxVisitaf;
      request.fields['proxima_visita[hora]'] = '$horaProxVisitaf:00';
      request.fields['proxima_visita[encargado_id]'] = idEncargadoProxVisitaf;
      //DATOS FACTURACION
      request.fields['pago[metodo_pago]'] = tipoPagof;
      request.fields['pago[numero_documento]'] = ciNITf;
      request.fields['pago[nombres]'] = nombreFacf;
      request.fields['pago[apellidos]'] = apellidoFacf;
      request.fields['pago[guardar_datos]'] = saveDatosFacturaf.toString();
      request.fields['pago[monto]'] = montoEfectivof;
      request.fields['pago[tipo_servicio]'] = 'servicio_clinica';
      //AQUI YA SE ESTA ENVIANDO TODO

      //print(request.fields);

      final response = await request.send();
      var responseStream = await response.stream.bytesToString();
      var responseData = jsonDecode(responseStream);

      if (responseData['code'] == 200 &&
          responseData['data']['ficha_clinica_id'] != '') {
        print('Solicitud exitosa');
        print('Respuesta: ${responseStream}');
        print('Data decodificada: ${responseData['data']}');
        setLoadingDatosVacuna(false);
        setOKsendDatosVacuna(true);
        notifyListeners();
        return OkpostDatosVacuna;
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        BotToast.showText(
            text: responseStream, duration: const Duration(seconds: 3));
        setLoadingDatosVacuna(false);
        setOKsendDatosVacuna(false);
        notifyListeners();
        return OkpostDatosVacuna;
      }
    } catch (e) {
      print('errooorrr $e');
      BotToast.showText(
          text: e.toString(), duration: const Duration(seconds: 3));
      setLoadingDatosVacuna(false);
      setOKsendDatosVacuna(false);
      notifyListeners();
      return OkpostDatosVacuna;
    }
  }

  //check boix prubea

  bool valueClinicacBoxUno = false;
  void setClinicacboxUno() {
    valueClinicacBoxUno = !valueClinicacBoxUno;
    notifyListeners();
  }

  Future<bool> actualizarDatos(
    //propietario
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
    File? fotoPacientef,

    //Cirugia

    String contraf,
    String laboratoriof,
    String serief,
    String procedenciaf,
    String expiracionf,
    String archivoVacunaf,

    //proxima visita

    String fechaProxVisitaf,
    String horaProxVisitaf,
    String idEncargadoProxVisitaf,
    String documento,
    int idPropietario,
  ) async {
    String urlFinal = '${_urlBase}update/ficha-vacuna/${_fichaId}';

    setLoadingDatosVacuna(true);

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
    request.fields['propietario[documento]'] = documento;

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

    if (fotoPacientef != null) {
      await fotoPacientef.copy(tempFilePath);

      print(tempFilePath);
      //verificarRuta(tempFilePath);

      var imageUploadFotoPaciente = await http.MultipartFile.fromPath(
          'archivo[foto_paciente]', tempFilePath);

      request.files.add(imageUploadFotoPaciente);
    }

    //DATOS VACUNAe

    request.fields['vacuna[contra]'] = contraf;
    request.fields['vacuna[laboratorio]'] = laboratoriof;
    request.fields['vacuna[serie]'] = serief;
    request.fields['vacuna[procedencia]'] = procedenciaf;
    request.fields['vacuna[fechaExpiracion]'] = expiracionf;
    try {
      request.files.add(
          await http.MultipartFile.fromPath('archivo[vacuna]', archivoVacunaf));
    } catch (e) {
      print('error en archivo vacuna $e');
    }

    //DATOS DE PROXIMA VISITA
    request.fields['proxima_visita[fecha]'] = fechaProxVisitaf;
    request.fields['proxima_visita[hora]'] =
        (horaProxVisitaf.length < 6) ? '$horaProxVisitaf:00' : horaProxVisitaf;
    request.fields['proxima_visita[encargado_id]'] = idEncargadoProxVisitaf
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');

    //AQUI YA SE ESTA ENVIANDO TODO

    //print(request.fields);
    log(request.fields.toString());

    final response = await request.send();

    var responseStream = await response.stream.bytesToString();
    var responseData = jsonDecode(responseStream);

    try {
      log(responseData.toString());
      if (responseData['code'] == 200 &&
          responseData['data']['ficha_clinica_id'] != '') {
        print('Solicitud exitosa');
        print('Respuesta: ${responseStream}');
        print('Data decodificada: ${responseData['data']}');

        setLoadingDatosVacuna(false);
        setOKsendDatosVacuna(true);
        notifyListeners();
        return OkpostDatosVacuna;
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        setLoadingDatosVacuna(false);
        setOKsendDatosVacuna(false);
        notifyListeners();
        return OkpostDatosVacuna;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosVacuna(false);
      setOKsendDatosVacuna(false);
      notifyListeners();
      return OkpostDatosVacuna;
    }
  }

  void resetearDatosForm() {
    _totalACobrarFacturacion = '';
    _selectedSexoPaciente = '';
    _selectedTypeAge = 'anios';
    selectedIdEspecie = null;
    selectedIdRaza = null;
    _dropTamanoMascota = '';
    _dropTemperamento = '';
    _dropAlimentacion = '';
    lastImage = null;
    image = null;
    _fechaVisitaSelected = '';
    _horaSelected = '';
    _idEncargadoSelected = '';
    _inicialEncargado = '';
    _selectedEfectivoTransac = 'EFECTIVO';
    _switchValueFacturacion = false;
    _fileArchivoVacuna = '';
    _fechaExpiracion = '';
    notifyListeners();
  }
}
