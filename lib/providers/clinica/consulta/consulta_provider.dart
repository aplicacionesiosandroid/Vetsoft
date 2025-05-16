import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:vet_sotf_app/common/utils/utils.dart';
import 'package:vet_sotf_app/models/clinica/consulta/veterinariosEncargados.dart';

import '../../../config/global/global_variables.dart';
import '../../../models/clinica/buscarPacientes_model.dart';
import '../../../models/clinica/consulta/especiesDropdown.dart';
import '../../../models/clinica/consulta/razasDropdown.dart';
import '../../../models/clinica/datosparametricos_model.dart';

class ConsultaProvider extends ChangeNotifier {
  final String _urlBase = apiUrlGlobal;
  final String _urlBaseImagen = imagenUrlGlobal;

  ConsultaProvider() {
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
  String _selectedTypeAge = "anios";

  String get selectedTypeAge => _selectedTypeAge;

  void setselectedAge(String Age) {
    _selectedTypeAge = Age;
    notifyListeners();
  }

  //Esto es para mostrar los datos para la ficha parametrizada

  //Listado de los datos parametricos a mostrar

  List<DatosParametricos> _datosParametricos = [];
  List<DatosParametricos> get getdatosParametricos => _datosParametricos;

  Future<void> getDatosParams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(
        Uri.parse('${_urlBase}clinica/ficha-parametrica-valores'),
        headers: headers);
    Utilidades.imprimir(
        "respuesta datos parametricos: " + response.body.toString());
    if (response.statusCode == 200) {
      final resp = modelDatosParametrizadosFromJson(response.body);
      _datosParametricos.clear();
      _datosParametricos.addAll(resp.data);

      notifyListeners();
    } else {
      throw Exception('Error al obtener los datos de la API');
    }

    // for (var datoParametrico in _datosParametricos) {
    //   print(
    //       'ID: ${datoParametrico.parametricaId}, parametrica: ${datoParametrico.parametrica}');

    //   for (var pregunta in datoParametrico.preguntas) {
    //     print(
    //         ' - Pregunta: ${pregunta.preguntaId}, Valor: ${pregunta.pregunta}');

    //     for (var opcion in pregunta.opciones) {
    //       print(
    //           '   - Opción: ${opcion.tipo}, ${opcion.opcionId}, ${opcion.opcion}');
    //     }
    //   }
    // }
  }

  //listar los checkbox
  void toggleSelected(DatosParametricos parametrica) {
    final index = _datosParametricos.indexOf(parametrica);
    if (index != -1) {
      _datosParametricos[index].selected = !_datosParametricos[index].selected;
      notifyListeners();
    }
  }

  bool esAlgunMotivoSeleccionado() {
    return _datosParametricos.any((parametrica) => parametrica.selected);
  }

  //para almacenar los valores de textformfields y radiobiuttons
  Map<int, String> textFormFieldValues = {};
  Map<int, String> radioButtonValues = {};

  void updateTextFormFieldValue(int preguntaId, String value) {
    print('updateTextFormFieldValue: $preguntaId, $value');
    textFormFieldValues[preguntaId] = value;
    notifyListeners();
  }

  void updateRadioButtonValue(int preguntaId, String value) {
    radioButtonValues[preguntaId] = value;
    notifyListeners();
  }

  //VARIABLE PARA ALMACENAR DATOS PARAMETRICOS A LA API

  Map<int, dynamic> _datosParaEnviarApi = {};
  Map<int, dynamic> get getDatosParaEnviarApi => _datosParaEnviarApi;

  //prueba mostrar datos posibels sa enviar
  void guardarDatosEnAPI(List<DatosParametricos> datosParametricosList) async {
    final Map<int, dynamic> datosParaEnviar = {};

    for (final datosParametricos in datosParametricosList) {
      for (final pregunta in datosParametricos.preguntas) {
        final preguntaId = pregunta.preguntaId;

        if (pregunta.opciones.first.tipo == Tipo.TEXTO) {
          final valor = textFormFieldValues[preguntaId];
          if (valor != null && valor.isNotEmpty) {
            final opcionId = pregunta.opciones.first.opcionId;
            final datoEnviado = '$opcionId,"$valor"';
            datosParaEnviar[opcionId] = datoEnviado;
          }
        } else if (pregunta.opciones.first.tipo == Tipo.OPCION) {
          final valor = radioButtonValues[preguntaId];
          if (valor != null) {
            // Buscar la opción seleccionada dentro de la lista de opciones disponibles
            final opcionSeleccionada = pregunta.opciones.firstWhere(
                (opcion) => opcion.opcion == valor,
                orElse: () =>
                    Opciones(opcionId: -1, tipo: Tipo.OPCION, opcion: ""));

            if (opcionSeleccionada.opcionId != -1) {
              final opcionId = opcionSeleccionada.opcionId;
              final datoEnviado = '$opcionId,"$valor"';
              datosParaEnviar[opcionId] = datoEnviado;
            }
          }
        }
      }
    }

    _datosParaEnviarApi = datosParaEnviar;
    notifyListeners();
  }

  //PARA SABER SI EL NUEVO O ANTIGUO PACIENTE

  int _selectedSquareConsulta = 0;
  int get selectedSquareConsulta => _selectedSquareConsulta;

  void setSelectSquareConsulta(int square) {
    _selectedSquareConsulta = square;
    notifyListeners();
  }

  //POST PARA ANTIGUO

  //para limpiar lista de busquedas

  void clearBusquedas() {
    _selectedIndexPaciente = -1;
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
  //POST PARA CONSULTA

  //loading mientras envian los datos
  bool _loadingDatosConsulta = false;
  bool get loadingDatosConsulta => _loadingDatosConsulta;

  setLoadingDatosConsulta(bool value) {
    _loadingDatosConsulta = value;
    notifyListeners();
  }

  //cambio a true si el POST se realizo de manera correcta
  bool _OKpostDatosConsulta = false;
  bool get OkpostDatosConsulta => _OKpostDatosConsulta;

  setOKsendDatosConsulta(bool value) {
    _OKpostDatosConsulta = value;
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

  String? validateGenderSelection() {
    if (_selectedSexoPaciente.isEmpty) {
      return 'Seleccione una opción.';
    }
    return null;
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

  //DATOS FORM DATOS CLINICOS

  //dropdown estaticos
  String _dropMucosas = '';
  String get dropMucosas => _dropMucosas;
  void setDropMucosas(String value) {
    _dropMucosas = value;
    notifyListeners();
  }

  String _dropHidratacion = '';
  String get dropHidratacion => _dropHidratacion;
  void setDropHidratacion(String value) {
    _dropHidratacion = value;
    notifyListeners();
  }

  String _dropGanglios = '';
  String get dropGanglios => _dropGanglios;
  void setDropGanglios(String value) {
    _dropGanglios = value;
    notifyListeners();
  }

  //Radio button EXISTE ALGUN ANIMAL EN CASA
  String _selectedExisteAnimalEnCasa = '';

  String get selectedExisteAnimalEnCasa => _selectedExisteAnimalEnCasa;

  void setSelectedExisteAnimal(String siOno) {
    _selectedExisteAnimalEnCasa = siOno;
    notifyListeners();
  }

  //Radio Button EXpuesto a alguna enfermedad (SIN USO )
  String _selectedExpuestoAEnfermedad = '';

  String get selectedExpuestoAEnfermedad => _selectedExpuestoAEnfermedad;

  void setSelectedExpuestoAEnfermedad(String siOno) {
    _selectedExpuestoAEnfermedad = siOno;
    notifyListeners();
  }

  //radio button aplicado algun tratamiento
  String _selectedAplicadoTratamiento = '';

  String get selectedAplicadoTratamiento => _selectedAplicadoTratamiento;

  void setSelectedAplicadoTratamiento(String siOno) {
    _selectedAplicadoTratamiento = siOno;
    notifyListeners();
  }

  //Radio button vacunas al dia

  String _selectedVacunasAlDia = '';

  String get selectedVacunasAlDia => _selectedVacunasAlDia;

  void setSelectedVacunasAlDia(String siOno) {
    _selectedVacunasAlDia = siOno;
    notifyListeners();
  }

  //DATOS FORM PETICION DE MUESTRAS Y PRUEBAS

  //Cargando archivos para hemogramas
  List<String> _fileHemograma = [];

  List<String> get fileHemograma => _fileHemograma;

  void addFileHemograma(String fileName) {
    _fileHemograma.add(fileName);
    notifyListeners();
  }

  void clearFileHemograma() {
    _fileHemograma.clear();
    notifyListeners();
  }

  //Cargando archivos para quimica sanguinea
  List<String> _fileQuimSanguinea = [];

  List<String> get fileQuimSanguinea => _fileQuimSanguinea;

  void addFileQuimSanguinea(String fileName) {
    _fileQuimSanguinea.add(fileName);
    notifyListeners();
  }

  void clearFileQuimSanguinea() {
    _fileQuimSanguinea.clear();
    notifyListeners();
  }

//Cargando archivos para antibiograma
  List<String> _fileAntibiograma = [];

  List<String> get fileAntibiograma => _fileAntibiograma;

  void addFileAntibiograma(String fileName) {
    _fileAntibiograma.add(fileName);
    notifyListeners();
  }

  void clearFileAntibiograma() {
    _fileAntibiograma.clear();
    notifyListeners();
  }

//Cargando archivos para RadioGrafia
  List<String> _fileRadiografia = [];

  List<String> get fileRadiografia => _fileRadiografia;

  void addFileRadiografia(String fileName) {
    _fileRadiografia.add(fileName);
    notifyListeners();
  }

  void clearFileRadiografia() {
    _fileRadiografia.clear();
    notifyListeners();
  }

//Cargando archivos para ecografias
  List<String> _fileEcografia = [];

  List<String> get fileEcografia => _fileEcografia;

  void addFileEcografia(String fileName) {
    _fileEcografia.add(fileName);
    notifyListeners();
  }

  void clearFileEcografia() {
    _fileEcografia.clear();
    notifyListeners();
  }

//Cargando archivos para Coprologia
  List<String> _fileCoprologia = [];

  List<String> get fileCoprologia => _fileCoprologia;

  void addFileCoprologia(String fileName) {
    _fileCoprologia.add(fileName);
    notifyListeners();
  }

  void clearFileCoprologia() {
    _fileCoprologia.clear();
    notifyListeners();
  }

  //DATOS PARA FORM TRATAMIENTOS

  List<TextEditingController> controllersTratamiento = [];

  void agregarTratamiento() {
    controllersTratamiento.add(TextEditingController());
    for (var controller in controllersTratamiento) {
      print(controller.text);
    }
    notifyListeners();
  }

  void eliminarTratamiento(int index) {
    controllersTratamiento.removeAt(index);
    notifyListeners();
  }

  void clearTratamientos() {
    controllersTratamiento.clear();
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

  //Almacenar hora de proxma visita

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

  //Almacenando firma digital
  String _signatureImage = '';
  String get signatureImageFirma => _signatureImage;

  void setSignatureImageFirma(String image) {
    _signatureImage = image;
    notifyListeners();
  }

  void saveSignature(SignatureController controller, BuildContext context,
      ConsultaProvider signatureProvider) async {
    if (controller.isNotEmpty) {
      final signature = await controller.toImage(width: 300, height: 300);

      final directory = await Directory.systemTemp;
      final imagePath =
          '${directory.path}/${DateTime.now().millisecond}/signature.jpg';

      final file = File(imagePath);
      final byteData = await signature!.toByteData(format: ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      /* if (await file.exists()) {
        await file.delete();
      } */
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      // Actualiza el estado de la firma en el provider
      setSignatureImageFirma(imagePath);
    }
  }

  //VISTA FACTURACION

  //Radiobutton EFECTIVO o TRANSACCION

  String _selectedEfectivoTransac = 'EFECTIVO';

  String get selectedEfectivoTransac => _selectedEfectivoTransac;

  void setSelectedEfectivoTransac(String value) {
    _selectedEfectivoTransac = value;
    notifyListeners();
  }

  //switch para saber si se guarda la facturacion

  bool _switchValueFacturacion = false;

  bool get switchValueFacturacion => _switchValueFacturacion;

  set setSwitchValueFacturacion(bool value) {
    _switchValueFacturacion = value;
    notifyListeners();
  }

  //

  String _totalACobrarFacturacion = '';

  String get totalACobrarFacturacion => _totalACobrarFacturacion;

  set setTotalACobrarFacturacion(String value) {
    _totalACobrarFacturacion = value;
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
    String tipoEdad,
    String especieIdPacientef,
    String razaIdPacientef,
    String tamanoPacientef,
    String temperamentoPacientef,
    String alimentacionPacientef,
    File? fotoPacientef,

    //datos clinicos
    String mucosasClinicof,
    String pesoClinicof,
    String temperaturaClinicof,
    String frecCardClinicof,
    String frecRespClinicof,
    String hidratacionClinicof,
    String gangliosClinicof,
    String lesionesClinicof,
    String tiempoTenenciaClinicof,
    String otroAnimalClinicof,
    String origenMascotaClinicof,
    String enfermPadecidasClinicof,
    String enfermRecientesClinicof,
    String enfermTratamientoClinicof,
    String vacunasAlDiaClinicof,
    String reaccionAlergicaf,

    //peticiones de pruebas y muestras
    String muestrasRequeridasPM,
    String pruebasRequeridasPM,
    List<String> fileHemogramaf,
    List<String> fileRadiografiasf,
    List<String> fileEcografiasf,
    List<String> fileQuimSanguineaf,
    List<String> fileAntibiogramaf,
    List<String> fileCoprologiaf,

    //diagnostico

    String listaProblemasDiagnosticof,
    String diagnosticoDiagnosticof,
    String diagDiferencialDiagnosticof,

    //tratamientos

    List<TextEditingController> tratamientosListaf,
    String recomendacionTratamientof,

    //proxima visita

    String fechaProxVisitaf,
    String horaProxVisitaf,
    String idEncargadoProxVisitaf,
    String firmaDigital,

    //datos facturacion
    String tipoPagof,
    String ciNITf,
    String nombreFacf,
    String apellidoFacf,
    bool saveDatosFacturaf,
    String montoEfectivof,
  ) async {
    try {
      String urlFinal = '${_urlBase}clinica/ficha-normal';

      setLoadingDatosConsulta(true);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = prefs.getString('myToken') ?? '';
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
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

      if (fotoPacientef != null) {
        //GUARDAR FOTO DEL PACIENTE
        var tempDir = Directory.systemTemp;
        var tempFilePath =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
        await fotoPacientef.copy(tempFilePath);
        verificarRuta(tempFilePath);
        var imageUploadFotoPaciente = await http.MultipartFile.fromPath(
            'archivo[foto_paciente]', tempFilePath);
        request.files.add(imageUploadFotoPaciente);
      }

      //DATOS CLINICOS
      request.fields['datos_clinicos[mucosas]'] = mucosasClinicof;
      request.fields['datos_clinicos[peso]'] = pesoClinicof;
      request.fields['datos_clinicos[temperatura]'] = temperaturaClinicof;
      request.fields['datos_clinicos[frecuencia_cardiaca]'] = frecCardClinicof;
      request.fields['datos_clinicos[frecuencia_respiratoria]'] =
          frecRespClinicof;
      request.fields['datos_clinicos[hidratacion]'] = hidratacionClinicof;
      request.fields['datos_clinicos[ganglios_linfaticos]'] = gangliosClinicof;
      request.fields['datos_clinicos[lesiones]'] = lesionesClinicof;
      request.fields['datos_clinicos[tiempoTenencia]'] = tiempoTenenciaClinicof;
      request.fields['datos_clinicos[otroAnimal]'] = otroAnimalClinicof;
      request.fields['datos_clinicos[origenMascota]'] = origenMascotaClinicof;
      request.fields['datos_clinicos[enfermedadesPadecidas]'] =
          enfermPadecidasClinicof;
      request.fields['datos_clinicos[enfermedadesRecientes]'] =
          enfermRecientesClinicof;
      request.fields['datos_clinicos[enferemedadTratamiento]'] =
          enfermTratamientoClinicof;
      request.fields['datos_clinicos[vacunasAldia]'] = vacunasAlDiaClinicof;
      request.fields['datos_clinicos[reaccionAlergica]'] = reaccionAlergicaf;

      //DATOS PETICIONES DE MUESTRA Y PRUEBAS

      request.fields['peticiones_muestras[muestrasRequeridas]'] =
          muestrasRequeridasPM;
      request.fields['peticiones_muestras[pruebasRequeridas]'] =
          pruebasRequeridasPM;

      for (final fileName in fileHemograma) {
        final file = File(fileName);

        request.files.add(
          await http.MultipartFile.fromPath('archivo[hemograma][]', file.path),
        );
      }

      for (final fileName in fileRadiografiasf) {
        final file = File(fileName);

        request.files.add(
          await http.MultipartFile.fromPath(
              'archivo[radiografias][]', file.path),
        );
      }

      for (final fileName in fileEcografiasf) {
        final file = File(fileName);

        request.files.add(
          await http.MultipartFile.fromPath('archivo[ecografias][]', file.path),
        );
      }

      for (final fileName in fileQuimSanguineaf) {
        final file = File(fileName);

        request.files.add(
          await http.MultipartFile.fromPath(
              'archivo[quimica_sanguinea][]', file.path),
        );
      }

      for (final fileName in fileAntibiogramaf) {
        final file = File(fileName);

        request.files.add(
          await http.MultipartFile.fromPath(
              'archivo[antibiograma][]', file.path),
        );
      }

      for (final fileName in fileCoprologiaf) {
        final file = File(fileName);

        request.files.add(
          await http.MultipartFile.fromPath('archivo[coprologia][]', file.path),
        );
      }

      // Esto es para enviar LOS DATOS DEL FORMULARIO PARAMETRICO

      //DATOS DE DIAGNOSTICO

      request.fields['diagnostico[listaProblemas]'] =
          listaProblemasDiagnosticof;
      request.fields['diagnostico[diagnostico]'] = diagnosticoDiagnosticof;
      request.fields['diagnostico[diagnosticoDiferencial]'] =
          diagDiferencialDiagnosticof;

      //DATOS DE TRATAMIENTO

      for (int i = 0; i < tratamientosListaf.length; i++) {
        request.fields['tratamientos[tratamiento][$i]'] =
            tratamientosListaf[i].text;
      }

      /*  for (var controllerTrat in tratamientosListaf) {
      print(controllerTrat.text);
      request.fields['tratamientos[tratamiento][]'] = controllerTrat.text;
    } */
      request.fields['tratamientos[recomendaciones]'] =
          recomendacionTratamientof;

      //DATOS DE PROXIMA VISITA
      request.fields['proxima_visita[fecha]'] = fechaProxVisitaf;
      request.fields['proxima_visita[hora]'] = '$horaProxVisitaf:00';
      request.fields['proxima_visita[encargado_id]'] = idEncargadoProxVisitaf;

      //GUARDAR FIRMA ELECTRONICA
      if (firmaDigital != '') {
        request.files.add(await http.MultipartFile.fromPath(
            'archivo[firma_electronica]', firmaDigital));
      }

      //DATOS FACTURACION

      request.fields['pago[metodo_pago]'] = tipoPagof;
      request.fields['pago[numero_documento]'] = ciNITf;
      request.fields['pago[nombres]'] = nombreFacf;
      request.fields['pago[apellidos]'] = apellidoFacf;
      request.fields['pago[guardar_datos]'] = saveDatosFacturaf.toString();
      request.fields['pago[monto]'] = montoEfectivof;
      request.fields['pago[tipo_servicio]'] = 'servicio_clinica';

      //AQUI YA SE ESTA ENVIANDO TODO

      final response = await request.send();
      var responseStream = await response.stream.bytesToString();
      var responseData = jsonDecode(responseStream);
      print(request.fields);
      try {
        if (responseData['code'] == 200 &&
            responseData['data']['ficha_clinica_id'] != '') {
          print('Solicitud exitosa');
          print('Respuesta: ${responseStream}');
          print('Data decodificada consulta: ${responseData}');
          setLoadingDatosConsulta(false);
          setOKsendDatosConsulta(true);
          notifyListeners();
          return OkpostDatosConsulta;
        } else {
          print('Error en la solicitud: ${response.statusCode}');
          print('Data decodificada consulta: ${responseData['data']}');
          BotToast.showText(
              text: responseData['data'], duration: const Duration(seconds: 3));
          setLoadingDatosConsulta(false);
          setOKsendDatosConsulta(false);
          notifyListeners();
          return OkpostDatosConsulta;
        }
      } catch (e) {
        print('error Consulta $e');
        BotToast.showText(
            text: e.toString(), duration: const Duration(seconds: 3));
        setLoadingDatosConsulta(false);
        setOKsendDatosConsulta(false);
        notifyListeners();
        return OkpostDatosConsulta;
      }
    } catch (e, stacktrace) {
      print('error en enviarDatosAntiguo $e');
      print(stacktrace);
      setLoadingDatosConsulta(false);
      BotToast.showText(
          text: e.toString(), duration: const Duration(seconds: 3));
      return OkpostDatosConsulta;
    }
  }

  void verificarRuta(String ruta) {
    File file = File(ruta);

    if (file.existsSync()) {
      print('La ruta es válida y el archivo existe.');
    } else {
      print('La ruta no es válida o el archivo no existe.');
    }
  }

  Future<bool> enviarDatosAntiguo(
    //paciente
    String idPacienteAntiguof,

    //datos clinicos
    String mucosasClinicof,
    String pesoClinicof,
    String temperaturaClinicof,
    String frecCardClinicof,
    String frecRespClinicof,
    String hidratacionClinicof,
    String gangliosClinicof,
    String lesionesClinicof,
    String tiempoTenenciaClinicof,
    String otroAnimalClinicof,
    String origenMascotaClinicof,
    String enfermPadecidasClinicof,
    String enfermRecientesClinicof,
    String enfermTratamientoClinicof,
    String vacunasAlDiaClinicof,
    String reaccionAlergicaf,

    //peticiones de pruebas y muestras
    String muestrasRequeridasPM,
    String pruebasRequeridasPM,
    List<String> fileHemogramaf,
    List<String> fileRadiografiasf,
    List<String> fileEcografiasf,
    List<String> fileQuimSanguineaf,
    List<String> fileAntibiogramaf,
    List<String> fileCoprologiaf,

    //datos paramaetricos
    Map<int, dynamic> datosParaEnviarParamf,

    //diagnostico

    String listaProblemasDiagnosticof,
    String diagnosticoDiagnosticof,
    String diagDiferencialDiagnosticof,

    //tratamientos

    List<TextEditingController> tratamientosListaf,
    String recomendacionTratamientof,

    //proxima visita

    String fechaProxVisitaf,
    String horaProxVisitaf,
    String idEncargadoProxVisitaf,
    String firmaDigital,
    //datos facturacion
    String tipoPagof,
    String ciNITf,
    String nombreFacf,
    String apellidoFacf,
    bool saveDatosFacturaf,
    String montoEfectivof,
  ) async {
    try {
      String urlFinal = '${_urlBase}clinica/ficha-normal/$idPacienteAntiguof';
      print(urlFinal);
      setLoadingDatosConsulta(true);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = prefs.getString('myToken') ?? '';
      Map<String, String> headers = {
        'Authorization':
            'Bearer $token', // Incluye el token en el encabezado de autorización
      };

      var request = http.MultipartRequest('POST', Uri.parse(urlFinal));
      request.headers.addAll(headers);

      //DATOS CLINICOS
      request.fields['datos_clinicos[mucosas]'] = mucosasClinicof;
      request.fields['datos_clinicos[peso]'] = pesoClinicof;
      request.fields['datos_clinicos[temperatura]'] = temperaturaClinicof;
      request.fields['datos_clinicos[frecuencia_cardiaca]'] = frecCardClinicof;
      request.fields['datos_clinicos[frecuencia_respiratoria]'] =
          frecRespClinicof;
      request.fields['datos_clinicos[hidratacion]'] = hidratacionClinicof;
      request.fields['datos_clinicos[ganglios_linfaticos]'] = gangliosClinicof;
      request.fields['datos_clinicos[lesiones]'] = lesionesClinicof;
      request.fields['datos_clinicos[tiempoTenencia]'] = tiempoTenenciaClinicof;
      request.fields['datos_clinicos[otroAnimal]'] = otroAnimalClinicof;
      request.fields['datos_clinicos[origenMascota]'] = origenMascotaClinicof;
      request.fields['datos_clinicos[enfermedadesPadecidas]'] =
          enfermPadecidasClinicof;
      request.fields['datos_clinicos[enfermedadesRecientes]'] =
          enfermRecientesClinicof;
      request.fields['datos_clinicos[enferemedadTratamiento]'] =
          enfermTratamientoClinicof;
      request.fields['datos_clinicos[vacunasAldia]'] = vacunasAlDiaClinicof;
      request.fields['datos_clinicos[reaccionAlergica]'] = reaccionAlergicaf;

      //DATOS PETICIONES DE MUESTRA Y PRUEBAS

      request.fields['peticiones_muestras[muestrasRequeridas]'] =
          muestrasRequeridasPM;
      request.fields['peticiones_muestras[pruebasRequeridas]'] =
          pruebasRequeridasPM;

      for (final fileName in fileHemograma) {
        final file = File(fileName);
        request.files.add(
          await http.MultipartFile.fromPath('archivo[hemograma][]', file.path),
        );
      }

      for (final fileName in fileRadiografiasf) {
        final file = File(fileName);
        request.files.add(
          await http.MultipartFile.fromPath(
              'archivo[radiografias][]', file.path),
        );
      }

      for (final fileName in fileEcografiasf) {
        final file = File(fileName);
        request.files.add(
          await http.MultipartFile.fromPath('archivo[ecografias][]', file.path),
        );
      }

      for (final fileName in fileQuimSanguineaf) {
        final file = File(fileName);
        request.files.add(
          await http.MultipartFile.fromPath(
              'archivo[quimica_sanguinea][]', file.path),
        );
      }

      for (final fileName in fileAntibiogramaf) {
        final file = File(fileName);
        request.files.add(
          await http.MultipartFile.fromPath(
              'archivo[antibiograma][]', file.path),
        );
      }

      for (final fileName in fileCoprologiaf) {
        final file = File(fileName);
        request.files.add(
          await http.MultipartFile.fromPath('archivo[coprologia][]', file.path),
        );
      }

      for (int i = 0; i < datosParaEnviarParamf.length; i++) {
        final opcionId = datosParaEnviarParamf.keys.elementAt(i);
        final valor = datosParaEnviarParamf[opcionId];
        request.fields['parametrica[opcion_id][$i]'] = '$opcionId,$valor';
        //request.fields['parametrica[opcion_id][$i]'] =
        //tratamientosListaf[i].text;
      }

      /*  datosParaEnviarParamf.forEach((opcionId, valor) {
      request.fields['parametrica[opcion_id][]'] = valor;
    }); */

      //DATOS DE DIAGNOSTICO

      request.fields['diagnostico[listaProblemas]'] =
          listaProblemasDiagnosticof;
      request.fields['diagnostico[diagnostico]'] = diagnosticoDiagnosticof;
      request.fields['diagnostico[diagnosticoDiferencial]'] =
          diagDiferencialDiagnosticof;

      //DATOS DE TRATAMIENTO

      for (int i = 0; i < tratamientosListaf.length; i++) {
        request.fields['tratamientos[tratamiento][$i]'] =
            tratamientosListaf[i].text;
      }

      /*  for (var controllerTrat in tratamientosListaf) {
      print(controllerTrat.text);
      request.fields['tratamientos[tratamiento][]'] = controllerTrat.text;
    } */
      request.fields['tratamientos[recomendaciones]'] =
          recomendacionTratamientof;

      //DATOS DE PROXIMA VISITA
      request.fields['proxima_visita[fecha]'] = fechaProxVisitaf;
      request.fields['proxima_visita[hora]'] = '$horaProxVisitaf:00';
      request.fields['proxima_visita[encargado_id]'] = idEncargadoProxVisitaf;

      //GUARDAR FIRMA ELECTRONICA
      if (firmaDigital != null && firmaDigital != '') {
        request.files.add(await http.MultipartFile.fromPath(
            'archivo[firma_electronica]', firmaDigital));
      }

      //DATOS FACTURACION
      request.fields['pago[metodo_pago]'] = tipoPagof;
      request.fields['pago[numero_documento]'] = ciNITf;
      request.fields['pago[nombres]'] = nombreFacf;
      request.fields['pago[apellidos]'] = apellidoFacf;
      request.fields['pago[guardar_datos]'] = saveDatosFacturaf.toString();
      request.fields['pago[monto]'] = montoEfectivof;
      request.fields['pago[tipo_servicio]'] = 'servicio_clinica';

      //AQUI YA SE ESTA ENVIANDO TODO

      final response = await request.send();
      var responseStream = await response.stream.bytesToString();
      var responseData = jsonDecode(responseStream);

      try {
        if (responseData['code'] == 200 &&
            responseData['data']['ficha_clinica_id'] != '') {
          print('Solicitud exitosa');
          print('Respuesta: ${responseStream}');
          print('Data decodificada: ${responseData['data']}');

          setLoadingDatosConsulta(false);
          setOKsendDatosConsulta(true);
          notifyListeners();
          return OkpostDatosConsulta;
        } else {
          print('Data decodificada: ${responseData['data']}');
          setLoadingDatosConsulta(false);
          setOKsendDatosConsulta(false);
          notifyListeners();
          return OkpostDatosConsulta;
        }
      } catch (e) {
        print('errooorrr $e');
        BotToast.showText(
            text: e.toString(), duration: const Duration(seconds: 3));
        setLoadingDatosConsulta(false);
        setOKsendDatosConsulta(false);
        notifyListeners();
        return OkpostDatosConsulta;
      }
    } catch (e, stacktrace) {
      print('error en enviarDatosAntiguo $e');
      BotToast.showText(
          text: e.toString(), duration: const Duration(seconds: 3));
      print(stacktrace);
      setLoadingDatosConsulta(false);
      return OkpostDatosConsulta;
    }
  }

  Future<bool> actualizarDatos(
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
    File? fotoPacientef,

    //datos clinicos
    String mucosasClinicof,
    String pesoClinicof,
    String temperaturaClinicof,
    String frecCardClinicof,
    String frecRespClinicof,
    String hidratacionClinicof,
    String gangliosClinicof,
    String lesionesClinicof,
    String tiempoTenenciaClinicof,
    String otroAnimalClinicof,
    String origenMascotaClinicof,
    String enfermPadecidasClinicof,
    String enfermRecientesClinicof,
    String enfermTratamientoClinicof,
    String vacunasAlDiaClinicof,
    String reaccionAlergicaf,

    //peticiones de pruebas y muestras
    String muestrasRequeridasPM,
    String pruebasRequeridasPM,
    List<String> fileHemogramaf,
    List<String> fileRadiografiasf,
    List<String> fileEcografiasf,
    List<String> fileQuimSanguineaf,
    List<String> fileAntibiogramaf,
    List<String> fileCoprologiaf,

    //diagnostico

    String listaProblemasDiagnosticof,
    String diagnosticoDiagnosticof,
    String diagDiferencialDiagnosticof,

    //tratamientos

    List<TextEditingController> tratamientosListaf,
    String recomendacionTratamientof,

    //proxima visita

    String fechaProxVisitaf,
    String horaProxVisitaf,
    String idEncargadoProxVisitaf,
    String firmaDigital,
  ) async {
    String urlFinal = '${_urlBase}update/ficha-normal/$_fichaId';

    setLoadingDatosConsulta(true);

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
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';

    if (fotoPacientef != null) {
      await fotoPacientef.copy(tempFilePath);

      print(tempFilePath);
      verificarRuta(tempFilePath);

      //verificarRuta(tempFilePath);

      var imageUploadFotoPaciente = await http.MultipartFile.fromPath(
          'archivo[foto_paciente]', tempFilePath);

      request.files.add(imageUploadFotoPaciente);
    }

    //DATOS CLINICOS
    request.fields['datos_clinicos[mucosas]'] = mucosasClinicof;
    request.fields['datos_clinicos[peso]'] = pesoClinicof;
    request.fields['datos_clinicos[temperatura]'] = temperaturaClinicof;
    request.fields['datos_clinicos[frecuencia_cardiaca]'] = frecCardClinicof;
    request.fields['datos_clinicos[frecuencia_respiratoria]'] =
        frecRespClinicof;
    request.fields['datos_clinicos[hidratacion]'] = hidratacionClinicof;
    request.fields['datos_clinicos[ganglios_linfaticos]'] = gangliosClinicof;
    request.fields['datos_clinicos[lesiones]'] = lesionesClinicof;
    request.fields['datos_clinicos[tiempoTenencia]'] = tiempoTenenciaClinicof;
    request.fields['datos_clinicos[otroAnimal]'] = otroAnimalClinicof;
    request.fields['datos_clinicos[origenMascota]'] = origenMascotaClinicof;
    request.fields['datos_clinicos[enfermedadesPadecidas]'] =
        enfermPadecidasClinicof;
    request.fields['datos_clinicos[enfermedadesRecientes]'] =
        enfermRecientesClinicof;
    request.fields['datos_clinicos[enferemedadTratamiento]'] =
        enfermTratamientoClinicof;
    request.fields['datos_clinicos[vacunasAldia]'] = vacunasAlDiaClinicof;
    request.fields['datos_clinicos[reaccionAlergica]'] = reaccionAlergicaf;

    //DATOS PETICIONES DE MUESTRA Y PRUEBAS

    request.fields['peticiones_muestras[muestrasRequeridas]'] =
        muestrasRequeridasPM;
    request.fields['peticiones_muestras[pruebasRequeridas]'] =
        pruebasRequeridasPM;

    for (final fileName in fileHemograma) {
      final file = File(fileName);
      try {
        request.files.add(
          await http.MultipartFile.fromPath('archivo[hemograma][]', file.path),
        );
      } catch (e) {
        print('error en el archivo $e');
      }
    }

    for (final fileName in fileRadiografiasf) {
      final file = File(fileName);

      try {
        request.files.add(
          await http.MultipartFile.fromPath(
              'archivo[radiografias][]', file.path),
        );
      } catch (e) {
        print('error en el archivo $e');
      }
    }

    for (final fileName in fileEcografiasf) {
      final file = File(fileName);

      try {
        request.files.add(
          await http.MultipartFile.fromPath('archivo[ecografias][]', file.path),
        );
      } catch (e) {
        print('error en el archivo $e');
      }
    }

    for (final fileName in fileQuimSanguineaf) {
      final file = File(fileName);

      try {
        request.files.add(
          await http.MultipartFile.fromPath(
              'archivo[quimica_sanguinea][]', file.path),
        );
      } catch (e) {
        print('error en el archivo $e');
      }
    }

    for (final fileName in fileAntibiogramaf) {
      final file = File(fileName);

      try {
        request.files.add(
          await http.MultipartFile.fromPath(
              'archivo[antibiograma][]', file.path),
        );
      } catch (e) {
        print('error en el archivo $e');
      }
    }

    for (final fileName in fileCoprologiaf) {
      final file = File(fileName);

      try {
        request.files.add(
          await http.MultipartFile.fromPath('archivo[coprologia][]', file.path),
        );
      } catch (e) {
        print('error en el archivo $e');
      }
    }

    // Esto es para enviar LOS DATOS DEL FORMULARIO PARAMETRICO

    //DATOS DE DIAGNOSTICO

    request.fields['diagnostico[listaProblemas]'] = listaProblemasDiagnosticof;
    request.fields['diagnostico[diagnostico]'] = diagnosticoDiagnosticof;
    request.fields['diagnostico[diagnosticoDiferencial]'] =
        diagDiferencialDiagnosticof;

    //DATOS DE TRATAMIENTO

    for (int i = 0; i < tratamientosListaf.length; i++) {
      request.fields['tratamientos[tratamiento][$i]'] =
          tratamientosListaf[i].text;
    }

    /*  for (var controllerTrat in tratamientosListaf) {
      print(controllerTrat.text);
      request.fields['tratamientos[tratamiento][]'] = controllerTrat.text;
    } */
    request.fields['tratamientos[recomendaciones]'] = recomendacionTratamientof;

    //DATOS DE PROXIMA VISITA
    request.fields['proxima_visita[fecha]'] = fechaProxVisitaf;
    request.fields['proxima_visita[hora]'] =
        (horaProxVisitaf.length < 6) ? '$horaProxVisitaf:00' : horaProxVisitaf;
    request.fields['proxima_visita[encargado_id]'] = idEncargadoProxVisitaf
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');
    try {
      request.files.add(await http.MultipartFile.fromPath(
          'archivo[firma_electronica]', firmaDigital));
    } catch (e) {
      print('error en el archivo $e');
    }

    //AQUI YA SE ESTA ENVIANDO TODO

    final response = await request.send();
    var responseStream = await response.stream.bytesToString();
    var responseData = jsonDecode(responseStream);

    try {
      if (responseData['code'] == 200 &&
          responseData['data']['ficha_clinica_id'] != '') {
        print('Solicitud exitosa');
        print('Respuesta: ${responseStream}');
        print('Data decodificada: ${responseData['data']}');

        setLoadingDatosConsulta(false);
        setOKsendDatosConsulta(true);
        notifyListeners();
        return OkpostDatosConsulta;
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        print('Data decodificada: ${responseData['data']}');
        setLoadingDatosConsulta(false);
        setOKsendDatosConsulta(false);
        notifyListeners();
        return OkpostDatosConsulta;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosConsulta(false);
      setOKsendDatosConsulta(false);
      notifyListeners();
      return OkpostDatosConsulta;
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
    _dropMucosas = '';
    _dropHidratacion = '';
    _dropGanglios = '';
    _selectedExisteAnimalEnCasa = '';
    _selectedAplicadoTratamiento = '';
    _selectedVacunasAlDia = '';
    clearFileHemograma();
    clearFileQuimSanguinea();
    clearFileAntibiograma();
    clearFileRadiografia();
    clearFileEcografia();
    clearFileCoprologia();
    lastImage = null;
    image = null;
    clearTratamientos();
    _fechaVisitaSelected = '';
    _selectedEfectivoTransac = 'EFECTIVO';
    _switchValueFacturacion = false;
    _signatureImage = '';
    _horaSelected = '';
    _idEncargadoSelected = '';
    _inicialEncargado = '';
    //datos parametricos
    textFormFieldValues = {};
    radioButtonValues = {};
    notifyListeners();
  }
}
