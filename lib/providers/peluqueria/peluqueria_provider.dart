import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:developer' as developer;

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:vet_sotf_app/common/utils/utils.dart';
import 'package:vet_sotf_app/models/peluqueria/peluqueria_update_form.dart';

import '../../../models/clinica/buscarPacientes_model.dart';
import '../../../models/clinica/consulta/especiesDropdown.dart';
import '../../../models/clinica/consulta/razasDropdown.dart';
import '../../config/global/global_variables.dart';
import '../../models/peluqueria/encargadosPeluqueros.dart';

class PeluqueriaProvider extends ChangeNotifier {
  final String _urlBase = apiUrlGlobal;

  PeluqueriaProvider() {
    getEspeciesDropdown();
    getRazasDropdown();
    getEncargadosPeluqueria();
  }

  void resetearDatos() {
    _totalACobrarFacturacion = '0';
    _horaSelected = '';
    _inicialEncargado = '';
    _horaEntregaSelected = '';
    _isCheckedIndicacionesMascDificil = false;
    _switchValueFacturacion = false;
    //checks de servicios esteticos
    _isCheckedCortePelo = false;
    _isCheckedCortePeloMascDificil = false;
    _isCheckedBanoCompleto = false;
    _isCheckedLimpOidos = false;
    _isCheckedPedicura = false;
    _isCheckedLimpDental = false;
    _isCheckedLimpGlandulas = false;
    _isCheckedElimPulgas = false;
    _isCheckedOtrosTrat = false;
  }

  //PARA SABER SI EL NUEVO O ANTIGUO PACIENTE

  int _selectedSquarePeluqueria = 0;
  int get selectedSquarePeluqueria => _selectedSquarePeluqueria;

  void setSelectSquarePeluqueria(int square) {
    _selectedSquarePeluqueria = square;
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
  //POST PARA CIRUGIA

  //loading mientras envian los datos
  bool _loadingDatosPeluqueria = false;
  bool get loadingDatosPeluqueria => _loadingDatosPeluqueria;

  setLoadingDatosPeluqueria(bool value) {
    _loadingDatosPeluqueria = value;
    notifyListeners();
  }

  //cambio a true si el POST se realizo de manera correcta
  bool _OKpostDatosPeluqueria = false;
  bool get OkpostDatosPeluqueria => _OKpostDatosPeluqueria;

  setOKsendDatosPeluqueria(bool value) {
    _OKpostDatosPeluqueria = value;
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
  String _selectedSexoPaciente = 'M';

  String get selectedSexoPaciente => _selectedSexoPaciente;

  void setSelectedGender(String gender) {
    _selectedSexoPaciente = gender;
    notifyListeners();
  }

  //Radio Buttons Meses Años
  String _selectedTypeAge = 'anios';

  String get selectedTypeAge => _selectedTypeAge;

  void setselectedAge(String Age) {
    _selectedTypeAge = Age;
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

  //DATOS FORM SERVICIOS ESTETICOS

  //corte de pelo
  bool _isCheckedCortePelo = false;
  bool get isCheckedCortePelo => _isCheckedCortePelo;
  void setCheckCortePelo(bool value) {
    _isCheckedCortePelo = value;
    _isCheckedCortePeloMascDificil = false;
    notifyListeners();
  }

  //corte de pelo => la mascota es dificil?
  bool _isCheckedCortePeloMascDificil = false;
  bool get isCheckedCortePeloMascDificil => _isCheckedCortePeloMascDificil;
  void setCheckCortePeloMascDificil(bool value) {
    _isCheckedCortePeloMascDificil = value;
    notifyListeners();
  }

  //baño completo
  bool _isCheckedBanoCompleto = false;
  bool get isCheckedBanoCompleto => _isCheckedBanoCompleto;
  void setCheckBanoCompleto(bool value) {
    _isCheckedBanoCompleto = value;
    notifyListeners();
  }

//limpieza de oidos
  bool _isCheckedLimpOidos = false;
  bool get isCheckedLimpOidos => _isCheckedLimpOidos;
  void setCheckLimpOidos(bool value) {
    _isCheckedLimpOidos = value;
    notifyListeners();
  }

//Pedicura
  bool _isCheckedPedicura = false;
  bool get isCheckedPedicura => _isCheckedPedicura;
  void setCheckPedicura(bool value) {
    _isCheckedPedicura = value;
    notifyListeners();
  }

//Limpieza dental
  bool _isCheckedLimpDental = false;
  bool get isCheckedLimpDental => _isCheckedLimpDental;
  void setCheckLimpDental(bool value) {
    _isCheckedLimpDental = value;
    notifyListeners();
  }

//limpieza de glandulas
  bool _isCheckedLimpGlandulas = false;
  bool get isCheckedLimpGlandulas => _isCheckedLimpGlandulas;
  void setCheckLimpGlandulas(bool value) {
    _isCheckedLimpGlandulas = value;
    notifyListeners();
  }

//eliminacion de pulgas
  bool _isCheckedElimPulgas = false;
  bool get isCheckedElimPulgas => _isCheckedElimPulgas;
  void setCheckElimPulgas(bool value) {
    _isCheckedElimPulgas = value;
    notifyListeners();
  }

//Otros tratamientos
  bool _isCheckedOtrosTrat = false;
  bool get isCheckedOtrosTrat => _isCheckedOtrosTrat;
  void setCheckOtrosTrat(bool value) {
    _isCheckedOtrosTrat = value;
    notifyListeners();
  }

  //DATOS FORM INDICACIONES

  //Almacenar hora de entrega

  String _horaEntregaSelected = '';
  String get horaEntregaSelected => _horaEntregaSelected;

  void setHoraEntregaSelected(String value) {
    _horaEntregaSelected = value;
    notifyListeners();
  }

//check la mascota es dificil
  bool _isCheckedIndicacionesMascDificil = false;
  bool get isCheckedIndicacionesMascDificil =>
      _isCheckedIndicacionesMascDificil;
  void setCheckIndicacionesMascDificil(bool value) {
    _isCheckedIndicacionesMascDificil = value;
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
      PeluqueriaProvider signatureProvider) async {
    if (controller.isNotEmpty) {
      final signature = await controller.toImage(width: 300, height: 300);

      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/${DateTime.now().millisecond}/signature.jpg';

      final file = File(imagePath);
      final byteData = await signature!.toByteData(format: ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      if (await file.exists()) {
        await file.delete();
      }
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      // Actualiza el estado de la firma en el provider
      setSignatureImageFirma(imagePath);
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

  //Radiobutton EFECTIVO o TRANSACCION
  String _selectedEfectivoTransac = '';
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

  //Total a cobrar fcaturacion
  String _totalACobrarFacturacion = '0';
  String get totalACobrarFacturacion => _totalACobrarFacturacion;
  set setTotalACobrarFacturacion(String value) {
    _totalACobrarFacturacion = value;
    notifyListeners();
  }

  //METODO PARA ENVIAR TODO A LA API
  Future<bool> enviarDatos(
    //propietario
    String ciPropietario,
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

    //servicios esteticos
    String peinadosYExtrasf,
    String isCheckedCortePelof,
    String isCheckedCortePeloMascDificilf,
    String isCheckedBanoCompletof,
    String isCheckedLimpOidosf,
    String isCheckedPedicuraf,
    String isCheckedLimpDentalf,
    String isCheckedLimpGlandulasf,
    String isCheckedElimPulgasf,
    String isCheckedOtrosTratf,
    String tratamientoServEsteticosf,

    //indicaciones
    String indicacionEspecialf,
    String horaEntregaSelectedf,
    String isCheckedIndicacionesMascDificilf,
    String mascDificilConsentimientof,
    String firmaDigital,

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
    Utilidades.imprimir('entro a la funcion');
    String urlFinal = '${_urlBase}peluqueria/cliente-nuevo';

    setLoadingDatosPeluqueria(true);

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
    request.fields['propietario[documento]'] = ciPropietario;

    //DATOS DEL PACIENTE
    request.fields['paciente[nombre]'] = nombrePacientef;
    request.fields['paciente[sexo]'] = sexoPacientef;
    request.fields['paciente[edad]'] = edadPacientef;
    request.fields['paciente[tipo_edad]'] = tipoEdad;
    request.fields['paciente[especie_id]'] = especieIdPacientef;
    request.fields['paciente[raza_id]'] = razaIdPacientef;
    request.fields['paciente[tamaño]'] = tamanoPacientef;
    request.fields['paciente[temperamento]'] = temperamentoPacientef;
    request.fields['paciente[alimentacion]'] = alimentacionPacientef;
    request.fields['paciente[propietario_id]'] = '1';
    if (fotoPacientef != null) {
      var tempDir = Directory.systemTemp;
      var tempFilePath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await fotoPacientef.copy(tempFilePath);
      var result = await FlutterImageCompress.compressAndGetFile(
        fotoPacientef.absolute.path,
        tempFilePath,
        quality: 85,
      );
      if (result != null) {
        var imageUploadFotoCirugiaPost = await http.MultipartFile.fromPath(
          'archivo[foto_paciente]',
          result.path,
        );
        request.files.add(imageUploadFotoCirugiaPost);
      }
    }
    //SERVICOS ESTETICOS
    request.fields['servicios_esteticos[pedidosEspeciales]'] = peinadosYExtrasf;
    request.fields['servicios_esteticos[cortePelo]'] = isCheckedCortePelof;
    request.fields['servicios_esteticos[mascotaDificil]'] =
        isCheckedCortePeloMascDificilf;
    request.fields['servicios_esteticos[bañoCompleto]'] =
        isCheckedBanoCompletof;
    request.fields['servicios_esteticos[limpiezaOidos]'] = isCheckedLimpOidosf;
    request.fields['servicios_esteticos[pedicura]'] = isCheckedPedicuraf;
    request.fields['servicios_esteticos[limpiezaDental]'] =
        isCheckedLimpDentalf;
    request.fields['servicios_esteticos[limpiezaGlandulas]'] =
        isCheckedLimpGlandulasf;
    request.fields['servicios_esteticos[eliminacionPulgas]'] =
        isCheckedElimPulgasf;
    request.fields['servicios_esteticos[tratamiento]'] =
        tratamientoServEsteticosf;

    //INDICACIONES
    request.fields['servicios_esteticos[indicaciones_especiales]'] =
        indicacionEspecialf;
    request.fields['servicios_esteticos[hora_entrega]'] =
        '$horaEntregaSelectedf:00';
    request.fields['servicios_esteticos[consentimiento]'] =
        mascDificilConsentimientof;

    //DATOS DE PROXIMA VISITA
    request.fields['servicios_esteticos[fecha_proxima_visita]'] =
        fechaProxVisitaf;
    request.fields['servicios_esteticos[hora_proxima_visita]'] =
        '$horaProxVisitaf:00';
    request.fields['servicios_esteticos[encargado_id]'] =
        idEncargadoProxVisitaf;

    //DATOS FACTURACION
    request.fields['pago[metodo_pago]'] = tipoPagof;
    request.fields['pago[numero_documento]'] = ciNITf;
    request.fields['pago[nombres]'] = nombreFacf;
    request.fields['pago[apellidos]'] = apellidoFacf;
    request.fields['pago[guardar_datos]'] = saveDatosFacturaf.toString();
    request.fields['pago[monto]'] = montoEfectivof;
    request.fields['pago[tipo_servicio]'] = 'servicio_peluqueria';

    // Imprimir todos los datos que se están enviando
    print('Datos que se envían en el request:');
    request.fields.forEach((key, value) {
      print('$key: $value');
    });

    //AQUI YA SE ESTA ENVIANDO TODO
    final response = await request.send();
    var responseStream = await response.stream.bytesToString();
    var responseData = jsonDecode(responseStream);

    try {
      if (responseData['code'] == 200 &&
          responseData['data']['ficha_peluqueria_id'] != '') {
        print('Solicitud exitosa');
        print('Respuesta: ${responseStream}');

        setLoadingDatosPeluqueria(false);
        setOKsendDatosPeluqueria(true);
        notifyListeners();
        return OkpostDatosPeluqueria;
      } else {
        print('Error en la solicitud: ${responseData}');
        BotToast.showText(
            text: responseData.toString(),
            duration: const Duration(seconds: 5));
        setLoadingDatosPeluqueria(false);
        setOKsendDatosPeluqueria(false);
        notifyListeners();
        return OkpostDatosPeluqueria;
      }
    } catch (e) {
      print('errooorrr $e');
      BotToast.showText(
          text: e.toString(), duration: const Duration(seconds: 5));
      setLoadingDatosPeluqueria(false);
      setOKsendDatosPeluqueria(false);
      notifyListeners();
      return OkpostDatosPeluqueria;
    }
  }

  Future<bool> enviarDatosAntiguo(
    //paciente
    String idPacienteAntiguof,

    //servicios esteticos
    String peinadosYExtrasf,
    String isCheckedCortePelof,
    String isCheckedCortePeloMascDificilf,
    String isCheckedBanoCompletof,
    String isCheckedLimpOidosf,
    String isCheckedPedicuraf,
    String isCheckedLimpDentalf,
    String isCheckedLimpGlandulasf,
    String isCheckedElimPulgasf,
    String isCheckedOtrosTratf,
    String tratamientoServEsteticosf,

    //indicaciones
    String indicacionEspecialf,
    String horaEntregaSelectedf,
    String isCheckedIndicacionesMascDificilf,
    String mascDificilConsentimientof,
    String firmaDigital,

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
    Utilidades.imprimir('entro a la funcion 22');

    String urlFinal =
        '${_urlBase}peluqueria/cliente-antiguo/$idPacienteAntiguof';

    setLoadingDatosPeluqueria(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    var request = http.MultipartRequest('POST', Uri.parse(urlFinal));
    request.headers.addAll(headers);

    //SERVICOS ESTETICOS
    request.fields['servicios_esteticos[pedidosEspeciales]'] = peinadosYExtrasf;
    request.fields['servicios_esteticos[cortePelo]'] = isCheckedCortePelof;
    request.fields['servicios_esteticos[mascotaDificil]'] =
        isCheckedCortePeloMascDificilf;
    request.fields['servicios_esteticos[bañoCompleto]'] =
        isCheckedBanoCompletof;
    request.fields['servicios_esteticos[limpiezaOidos]'] = isCheckedLimpOidosf;
    request.fields['servicios_esteticos[pedicura]'] = isCheckedPedicuraf;
    request.fields['servicios_esteticos[limpiezaDental]'] =
        isCheckedLimpDentalf;
    request.fields['servicios_esteticos[limpiezaGlandulas]'] =
        isCheckedLimpGlandulasf;
    request.fields['servicios_esteticos[eliminacionPulgas]'] =
        isCheckedElimPulgasf;
    request.fields['servicios_esteticos[tratamiento]'] =
        tratamientoServEsteticosf;

    //INDICACIONES
    request.fields['servicios_esteticos[indicaciones_especiales]'] =
        indicacionEspecialf;
    request.fields['servicios_esteticos[hora_entrega]'] =
        '$horaEntregaSelectedf:00';
    request.fields['servicios_esteticos[consentimiento]'] =
        mascDificilConsentimientof;

    //DATOS DE PROXIMA VISITA
    request.fields['servicios_esteticos[fecha_proxima_visita]'] =
        fechaProxVisitaf;
    request.fields['servicios_esteticos[hora_proxima_visita]'] =
        '$horaProxVisitaf:00';
    request.fields['servicios_esteticos[encargado_id]'] =
        idEncargadoProxVisitaf;

    //DATOS FACTURACION
    request.fields['pago[metodo_pago]'] = tipoPagof;
    request.fields['pago[numero_documento]'] = ciNITf;
    request.fields['pago[nombres]'] = nombreFacf;
    request.fields['pago[apellidos]'] = apellidoFacf;
    request.fields['pago[guardar_datos]'] = saveDatosFacturaf.toString();
    request.fields['pago[monto]'] = montoEfectivof;
    request.fields['pago[tipo_servicio]'] = 'servicio_peluqueria';

    // Imprimir todos los datos que se están enviando
    print('Datos que se envían en el request:');
    request.fields.forEach((key, value) {
      print('$key: $value');
    });

    //AQUI YA SE ESTA ENVIANDO TODO

    final response = await request.send();
    var responseStream = await response.stream.bytesToString();
    var responseData = jsonDecode(responseStream);

    try {
      if (responseData['code'] == 200 &&
          responseData['data']['ficha_peluqueria_id'] != '') {
        print('Solicitud exitosa');
        print('Respuesta: ${responseStream}');

        setLoadingDatosPeluqueria(false);
        setOKsendDatosPeluqueria(true);
        notifyListeners();
        return OkpostDatosPeluqueria;
      } else {
        BotToast.showText(
            text: responseData.toString(),
            duration: const Duration(seconds: 5));
        print('Error en la solicitud: ${responseData}');
        setLoadingDatosPeluqueria(false);
        setOKsendDatosPeluqueria(false);
        notifyListeners();

        return OkpostDatosPeluqueria;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosPeluqueria(false);
      setOKsendDatosPeluqueria(false);
      BotToast.showText(
          text: e.toString(), duration: const Duration(seconds: 5));
      notifyListeners();
      return OkpostDatosPeluqueria;
    }
  }

  PeluqueriaUpdateForm? _peluqueriaUpdateForm;

  PeluqueriaUpdateForm get getPeluqueriaUpdateForm => _peluqueriaUpdateForm!;

  int _idFicha = 0;

  // Metodo para obtener los datos de la ficha
  Future<bool> getDatosFicha(int idFicha) async {
    String urlFinal =
        '${_urlBase}update/show-formulario?ficha_id=$idFicha&tipo=peluqueria';

    setLoadingDatosPeluqueria(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    var response = await http.get(Uri.parse(urlFinal), headers: headers);

    try {
      if (response.statusCode == 200) {
        print('Solicitud exitosa');
        print('Respuesta: ${response.body}');
        final resultResponse = PeluqueriaUpdateForm.fromJson(response.body);
        _peluqueriaUpdateForm = resultResponse;
        _idFicha = idFicha;

        setLoadingDatosPeluqueria(false);
        notifyListeners();
        return true;
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        setLoadingDatosPeluqueria(false);
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosPeluqueria(false);
      notifyListeners();
      return false;
    }
  }

  //check boix prubea

  bool valueClinicacBoxUno = false;
  void setClinicacboxUno() {
    valueClinicacBoxUno = !valueClinicacBoxUno;
    notifyListeners();
  }

  // ACTUALIZAR DATOS

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
      File fotoPacientef,

      //servicios esteticos
      String peinadosYExtrasf,
      String isCheckedCortePelof,
      String isCheckedCortePeloMascDificilf,
      String isCheckedBanoCompletof,
      String isCheckedLimpOidosf,
      String isCheckedPedicuraf,
      String isCheckedLimpDentalf,
      String isCheckedLimpGlandulasf,
      String isCheckedElimPulgasf,
      String isCheckedOtrosTratf,
      String tratamientoServEsteticosf,

      //indicaciones
      String indicacionEspecialf,
      String horaEntregaSelectedf,
      String isCheckedIndicacionesMascDificilf,
      String mascDificilConsentimientof,
      String firmaDigital,

      //proxima visita

      String fechaProxVisitaf,
      String horaProxVisitaf,
      String idEncargadoProxVisitaf) async {
    String urlFinal = '${_urlBase}update/peluqueria/$_idFicha';

    setLoadingDatosPeluqueria(true);

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
    request.fields['propietario[documento]'] =
        _peluqueriaUpdateForm!.data.propietario.documento;

    //DATOS DEL PACIENTE
    request.fields['paciente[nombre]'] = nombrePacientef;
    request.fields['paciente[sexo]'] = sexoPacientef;
    request.fields['paciente[edad]'] = edadPacientef;
    request.fields['paciente[especie_id]'] = especieIdPacientef;
    request.fields['paciente[raza_id]'] = razaIdPacientef;
    request.fields['paciente[tamaño]'] = tamanoPacientef;
    request.fields['paciente[temperamento]'] = temperamentoPacientef;
    request.fields['paciente[alimentacion]'] = alimentacionPacientef;
    request.fields['paciente[propietario_id]'] =
        _peluqueriaUpdateForm!.data.paciente.pacienteId.toString();

    var tempDir = Directory.systemTemp;
    var tempFilePath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    await fotoPacientef.copy(tempFilePath);

    var imageUploadFotoPaciente = await http.MultipartFile.fromPath(
        'archivo[foto_paciente]', tempFilePath);

    request.files.add(imageUploadFotoPaciente);

    //SERVICOS ESTETICOS
    request.fields['servicios_esteticos[pedidosEspeciales]'] = peinadosYExtrasf;
    request.fields['servicios_esteticos[cortePelo]'] = isCheckedCortePelof;
    request.fields['servicios_esteticos[mascotaDificil]'] =
        isCheckedCortePeloMascDificilf;
    request.fields['servicios_esteticos[bañoCompleto]'] =
        isCheckedBanoCompletof;
    request.fields['servicios_esteticos[limpiezaOidos]'] = isCheckedLimpOidosf;
    request.fields['servicios_esteticos[pedicura]'] = isCheckedPedicuraf;
    request.fields['servicios_esteticos[limpiezaDental]'] =
        isCheckedLimpDentalf;
    request.fields['servicios_esteticos[limpiezaGlandulas]'] =
        isCheckedLimpGlandulasf;
    request.fields['servicios_esteticos[eliminacionPulgas]'] =
        isCheckedElimPulgasf;
    request.fields['servicios_esteticos[tratamiento]'] =
        tratamientoServEsteticosf;

    //INDICACIONES
    request.fields['servicios_esteticos[indicaciones_especiales]'] =
        indicacionEspecialf;

    request.fields['servicios_esteticos[hora_entrega]'] =
        (horaEntregaSelectedf.length < 6)
            ? '$horaEntregaSelectedf:00'
            : horaEntregaSelectedf;
    request.fields['servicios_esteticos[consentimiento]'] =
        mascDificilConsentimientof;

    //DATOS DE PROXIMA VISITA
    request.fields['servicios_esteticos[fecha_proxima_visita]'] =
        fechaProxVisitaf;
    request.fields['servicios_esteticos[hora_proxima_visita]'] =
        (horaProxVisitaf.length < 6) ? '$horaProxVisitaf:00' : horaProxVisitaf;
    request.fields['servicios_esteticos[encargado_id]'] = idEncargadoProxVisitaf
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');

    //AQUI YA SE ESTA ENVIANDO TODO

    // print (request.fields);
    developer.log(request.fields.toString());

    final response = await request.send();
    var responseStream = await response.stream.bytesToString();
    var responseData = jsonDecode(responseStream);

    developer.log(responseData.toString());
    try {
      if (responseData['code'] == 200 &&
          responseData['data']['ficha_peluqueria_id'] != '') {
        print('Solicitud exitosa');
        print('Respuesta: ${responseStream}');

        setLoadingDatosPeluqueria(false);
        setOKsendDatosPeluqueria(true);
        notifyListeners();
        return OkpostDatosPeluqueria;
      } else {
        print('Error en la solicitud peluqieria: ${responseData['code']}');
        BotToast.showText(
            text: responseData.toString(),
            duration: const Duration(seconds: 5));
        setLoadingDatosPeluqueria(false);
        setOKsendDatosPeluqueria(false);
        notifyListeners();
        return OkpostDatosPeluqueria;
      }
    } catch (e) {
      print('errooorrr $e');
      BotToast.showText(
          text: e.toString(), duration: const Duration(seconds: 5));
      setLoadingDatosPeluqueria(false);
      setOKsendDatosPeluqueria(false);
      notifyListeners();
      return OkpostDatosPeluqueria;
    }
  }

  void resetearDatosForm() {
    _selectedSexoPaciente = 'M';
    _selectedTypeAge = 'anios';
    selectedIdEspecie = null;
    selectedIdRaza = null;
    _dropTamanoMascota = '';
    _dropTemperamento = '';
    _dropAlimentacion = '';
  }
}
