import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

import 'package:vet_sotf_app/models/clinica/consulta/veterinariosEncargados.dart';

import '../../../config/global/global_variables.dart';
import '../../../models/clinica/buscarPacientes_model.dart';
import '../../../models/clinica/consulta/especiesDropdown.dart';
import '../../../models/clinica/consulta/razasDropdown.dart';

class HospitalizacionProvider extends ChangeNotifier {
  final String _urlBase = apiUrlGlobal;

  HospitalizacionProvider() {
    getEspeciesDropdown();
    getRazasDropdown();
    getEncargadosConsulta();
    //getBusquedasPaciente();
  }

  int? _fichaId;
  int? get fichaId => _fichaId;

  void setFichaId(int? id) {
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

  int _selectedSquareHospitalizacion = 0;
  int get selectedSquareHospitalizacion => _selectedSquareHospitalizacion;

  void setSelectSquareHospitalizacion(int square) {
    _selectedSquareHospitalizacion = square;
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

  //POST PARA NUEVO
  //POST PARA DESPARACITACION

  //loading mientras envian los datos
  bool _loadingDatosHospitalizacion = false;
  bool get loadingDatosHospitalizacion => _loadingDatosHospitalizacion;

  setLoadingDatosHospitalizacion(bool value) {
    _loadingDatosHospitalizacion = value;
    notifyListeners();
  }

  //cambio a true si el POST se realizo de manera correcta
  bool _OKpostDatosHospitalizacion = false;
  bool get OkpostDatosHospitalizacion => _OKpostDatosHospitalizacion;

  setOKsendDatosHospitalizacion(bool value) {
    _OKpostDatosHospitalizacion = value;
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
    final response = await http.get(Uri.parse(url));
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

  //Almacenar fecha inicio
  String _fechaInicioSelected = '';
  String get fechaInicioSelected => _fechaInicioSelected;
  void setFechaInicioSlected(String value) {
    _fechaInicioSelected = value;
    notifyListeners();
  }

  //Almacenar hora incio
  String _horaInicioSelected = '';
  String get horaInicioSelected => _horaInicioSelected;
  void setHoraInicioSelected(String value) {
    _horaInicioSelected = value;
    notifyListeners();
  }

  //Almacenar fecha fin
  String _fechaFinSelected = '';
  String get fechaFinSelected => _fechaFinSelected;
  void setFechaFinSlected(String value) {
    _fechaFinSelected = value;
    notifyListeners();
  }

  //Almacenar hora fin
  String _horaFinSelected = '';
  String get horaFinSelected => _horaFinSelected;
  void setHoraFinSelected(String value) {
    _horaFinSelected = value;
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

  //METODO PARA ENVIAR TODO A LA API

  Future<bool> enviarDatos(
      //idPropietario
      String? idPropietariof,
      bool update,
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
      String? especieIdPacientef,
      String? razaIdPacientef,
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

      //diagnostico
      String listaProblemasDiagnosticof,
      String diagnosticoDiagnosticof,
      String diagDiferencialDiagnosticof,

      //peticiones de pruebas y muestras
      String muestrasRequeridasPM,
      String pruebasRequeridasPM,
      List<String> fileHemogramaf,
      List<String> fileQuimSanguineaf,
      List<String> fileAntibiogramaf,
      List<String> fileRadiografiasf,
      List<String> fileEcografiasf,
      List<String> fileCoprologiaf,
      List<String> fileRaspadoCutaneo,
      List<String> fileCitologico,

      //tratamientos
      List<TextEditingController> tratamientosListaf,
      bool enviarReceta,
      String recomendacionTratamientof,

      //Hospitalizacion
      String alimentacionf,
      String fechaIniciof,
      String horaIniciof,
      String fechaFinf,
      String horaFinf,
      String tiempoIntervalo,
      String tipoIntervalo,
      String idEncargadoProxVisitaf,
      String firmaDigital,

      //datos facturacion
      String tipoPagof,
      String ciNITf,
      String nombreFacf,
      String apellidoFacf,
      bool saveDatosFacturaf,
      String montoEfectivof) async {
    print("id ficha clinica $idPropietariof");
    print("actualizar $update");
    String urlFinal = '';
    if (idPropietariof == "null") {
      urlFinal = '${_urlBase}clinica/ficha-hospitalizacion';
    } else {
      urlFinal = '${_urlBase}clinica/ficha-hospitalizacion/$idPropietariof';
    }
    if (update == true) {
      urlFinal = '${_urlBase}update/ficha-hospitalizacion/$idPropietariof';
    }
    print("url final $urlFinal");
    setLoadingDatosHospitalizacion(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };
    try {
      var request = http.MultipartRequest('POST', Uri.parse(urlFinal));
      request.headers.addAll(headers);

      if (idPropietariof == "null" || update == true) {
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
        request.fields['paciente[raza_id]'] = razaIdPacientef ?? '';
        request.fields['paciente[tamaño]'] = tamanoPacientef;
        request.fields['paciente[temperamento]'] = temperamentoPacientef;
        request.fields['paciente[alimentacion]'] = alimentacionPacientef;

        if (fotoPacientef != null) {
          //GUARDAR FOTO DEL PACIENTE
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

      //DATOS DE DIAGNOSTICO
      request.fields['diagnostico[listaProblemas]'] =
          listaProblemasDiagnosticof;
      request.fields['diagnostico[diagnostico]'] = diagnosticoDiagnosticof;
      request.fields['diagnostico[diagnosticoDiferencial]'] =
          diagDiferencialDiagnosticof;

      //DATOS PETICIONES DE MUESTRA Y PRUEBAS
      request.fields['peticiones_muestras[muestrasRequeridas]'] =
          muestrasRequeridasPM;
      request.fields['peticiones_muestras[pruebasRequeridas]'] =
          pruebasRequeridasPM;

      for (final fileName in fileHemogramaf) {
        final file = File(fileName);
        request.files.add(
          await http.MultipartFile.fromPath('archivo[hemograma][]', file.path),
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
      for (final fileName in fileCoprologiaf) {
        final file = File(fileName);
        request.files.add(
          await http.MultipartFile.fromPath('archivo[coprologia][]', file.path),
        );
      }
      // for (final fileName in fileRaspadoCutaneo) {
      //   final file = File(fileName);
      //   request.files.add(
      //     await http.MultipartFile.fromPath('archivo[raspadoCutaneo][]', file.path),
      //   );
      // }
      // for (final fileName in fileCitologico) {
      //   final file = File(fileName);
      //   request.files.add(
      //     await http.MultipartFile.fromPath('archivo[citologico][]', file.path),
      //   );
      // }

      //DATOS DE TRATAMIENTO
      for (int i = 0; i < tratamientosListaf.length; i++) {
        request.fields['tratamientos[tratamiento][$i]'] =
            tratamientosListaf[i].text;
      }
      request.fields['enviar_receta'] = enviarReceta.toString();
      request.fields['tratamientos[recomendaciones]'] =
          recomendacionTratamientof;

      //HOSPITALIZACION
      request.fields['hospitalizacion[alimentacion]'] = alimentacionf;
      request.fields['hospitalizacion[inicio]'] =
          '$fechaIniciof $horaIniciof:00';
      request.fields['hospitalizacion[fin]'] = '$fechaFinf $horaFinf:00';
      request.fields['hospitalizacion[encargado_id]'] = idEncargadoProxVisitaf;
      request.fields['hospitalizacion[intervalo]'] = tiempoIntervalo;
      request.fields['hospitalizacion[tipo_intervalo]'] = tipoIntervalo;
      request.files.add(await http.MultipartFile.fromPath(
          'archivo[firma_electronica]', firmaDigital));

      //DATOS FACTURACION
      request.fields['pago[metodo_pago]'] = tipoPagof;
      request.fields['pago[numero_documento]'] = ciNITf;
      request.fields['pago[nombres]'] = nombreFacf;
      request.fields['pago[apellidos]'] = apellidoFacf;
      request.fields['pago[guardar_datos]'] = saveDatosFacturaf.toString();
      request.fields['pago[monto]'] = montoEfectivof;
      request.fields['pago[tipo_servicio]'] = 'servicio_clinica';

      // // Imprimir los campos
      // print("Campos:");
      // request.fields.forEach((key, value) {
      //   print('$key: $value');
      // });
      //
      // // Imprimir los archivos
      // print("Archivos:");
      // for (var file in request.files) {
      //   print('${file.field}: ${file.filename}');
      // }

      //AQUI YA SE ESTA ENVIANDO TODO

      final response = await request.send();
      var responseStream = await response.stream.bytesToString();
      print('Respuesta: ${responseStream}');
      var responseData = jsonDecode(responseStream);

      if (responseData['code'] == 200 &&
          responseData['data']['ficha_clinica_id'] != '') {
        print('Solicitud exitosa');
        print('Respuesta: ${responseStream}');
        print('Data decodificada: ${responseData['data']}');

        setLoadingDatosHospitalizacion(false);
        setOKsendDatosHospitalizacion(true);
        notifyListeners();
        return OkpostDatosHospitalizacion;
      } else {
        print('Error en la solicitud: ${responseData['data']}');
        setLoadingDatosHospitalizacion(false);
        setOKsendDatosHospitalizacion(false);
        BotToast.showText(
            text: responseData['data'], duration: const Duration(seconds: 3));

        notifyListeners();
        return OkpostDatosHospitalizacion;
      }
    } catch (e) {
      print('error Hospitalizacion $e');
      setLoadingDatosHospitalizacion(false);
      BotToast.showText(
          text: e.toString(), duration: const Duration(seconds: 3));
      setOKsendDatosHospitalizacion(false);
      notifyListeners();
      return OkpostDatosHospitalizacion;
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
    String urlFinal = '${_urlBase}clinica/ficha-programar-cita/$idPacientef';

    setLoadingDatosHospitalizacion(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    var request = http.MultipartRequest('POST', Uri.parse(urlFinal));
    request.headers.addAll(headers);

    //DATOS DE PROXIMA VISITA
    request.fields['proxima_visita[fecha]'] = fechaProxVisitaf;
    request.fields['proxima_visita[hora]'] = '$horaProxVisitaf:00';
    request.fields['proxima_visita[encargado_id]'] = idEncargadoProxVisitaf;

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

        setLoadingDatosHospitalizacion(false);
        setOKsendDatosHospitalizacion(true);
        notifyListeners();
        return OkpostDatosHospitalizacion;
      } else {
        print('Error en la solicitud: ${responseData['data']}');
        setLoadingDatosHospitalizacion(false);
        setOKsendDatosHospitalizacion(false);
        notifyListeners();
        return OkpostDatosHospitalizacion;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosHospitalizacion(false);
      setOKsendDatosHospitalizacion(false);
      notifyListeners();
      return OkpostDatosHospitalizacion;
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

    //proxima visita

    String fechaProxVisitaf,
    String horaProxVisitaf,
    String idEncargadoProxVisitaf,
    String documento,
    int idPropietario,
  ) async {
    String urlFinal = '${_urlBase}update/ficha-programar-cita/${_fichaId}';

    setLoadingDatosHospitalizacion(true);

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

    //DATOS DE PROXIMA VISITA
    request.fields['proxima_visita[fecha]'] = fechaProxVisitaf;
    request.fields['proxima_visita[hora]'] =
        (horaProxVisitaf.length < 6) ? '$horaProxVisitaf:00' : horaProxVisitaf;
    request.fields['proxima_visita[encargado_id]'] = idEncargadoProxVisitaf
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');

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

        setLoadingDatosHospitalizacion(false);
        setOKsendDatosHospitalizacion(true);
        notifyListeners();
        return OkpostDatosHospitalizacion;
      } else {
        print('Error en la solicitud: ${responseData['data']}');
        setLoadingDatosHospitalizacion(false);
        setOKsendDatosHospitalizacion(false);
        notifyListeners();
        return OkpostDatosHospitalizacion;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosHospitalizacion(false);
      setOKsendDatosHospitalizacion(false);
      notifyListeners();
      return OkpostDatosHospitalizacion;
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

  //Cargando archivos para RadioGrafia
  List<String> _fileRadiografia = [];

  List<String> get fileRadiografia => _fileRadiografia;

  void addFileRadiografia(String fileName) {
    _fileRadiografia.add(fileName);
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

  //Cargando archivos para Raspado Cutaneo
  List<String> _fileRaspadoCutaneo = [];

  List<String> get fileRaspadoCutaneo => _fileRaspadoCutaneo;

  void addFileRaspadoCutaneo(String fileName) {
    _fileRaspadoCutaneo.add(fileName);
    notifyListeners();
  }

  void clearFileRaspadoCutaneo() {
    _fileRaspadoCutaneo.clear();
    notifyListeners();
  }

  //Cargando archivos para CITOLOGICO
  List<String> _fileCitologico = [];

  List<String> get fileCitologico => _fileCitologico;

  void addFileCitologico(String fileName) {
    _fileCitologico.add(fileName);
    notifyListeners();
  }

  void clearFileCitologico() {
    _fileCitologico.clear();
    notifyListeners();
  }

  //DATOS PARA FORM TRATAMIENTOS

  List<TextEditingController> controllersTratamiento = [];

  void setControllersTratamiento(String descripcion) {
    controllersTratamiento.add(
        (TextEditingController().text = descripcion) as TextEditingController);
    notifyListeners();
  }

  void agregarTratamiento() {
    controllersTratamiento.add(TextEditingController());
    notifyListeners();
  }

  bool _enviarReceta = false;
  bool get enviarReceta => _enviarReceta;
  set enviarReceta(bool value) {
    _enviarReceta = value;
    notifyListeners();
  }

  //_totalACobrarFacturacion
  String _totalACobrarFacturacion = '';

  String get totalACobrarFacturacion => _totalACobrarFacturacion;

  set setTotalACobrarFacturacion(String value) {
    _totalACobrarFacturacion = value;
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
      HospitalizacionProvider signatureProvider) async {
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

  //Radio Button EXpuesto a alguna enfermedad (SIN USO )
  String _selectedExpuestoAEnfermedad = '';

  String get selectedExpuestoAEnfermedad => _selectedExpuestoAEnfermedad;

  void setSelectedExpuestoAEnfermedad(String siOno) {
    _selectedExpuestoAEnfermedad = siOno;
    notifyListeners();
  }

  //switch para saber si se guarda la facturacion
  bool _switchValueFacturacion = false;

  bool get switchValueFacturacion => _switchValueFacturacion;

  set setSwitchValueFacturacion(bool value) {
    _switchValueFacturacion = value;
    notifyListeners();
  }

  //Radio Buttons Meses Años
  String _selectedTypeInterval = 'minutos';

  String get selectedTypeInterval => _selectedTypeInterval;

  void setselectedInterval(String Age) {
    _selectedTypeInterval = Age;
    notifyListeners();
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
    lastImage = null;
    image = null;
    _signatureImage = '';
    _idEncargadoSelected = '';
    _inicialEncargado = '';
    _selectedEfectivoTransac = 'EFECTIVO';
    _switchValueFacturacion = false;
    _fechaInicioSelected = '';
    _horaInicioSelected = '';
    _fechaFinSelected = '';
    _horaFinSelected = '';
    controllersTratamiento = [];
    notifyListeners();
  }
}
