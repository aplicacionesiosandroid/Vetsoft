import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../config/global/global_variables.dart';
import '../../models/campain/contactos_model.dart';
import '../../models/campain/model_historial_campains.dart';
import '../../models/petshop/HomePetshop/producto_model.dart';

class CampainProvider extends ChangeNotifier {
  final String _urlBase = apiUrlGlobal;

  CampainProvider() {
    getContacts();
    getTodosProductos();
    getHistorailCampains();
  }

  final List<HistorialCampain> _historialCampain = [];
  List<HistorialCampain> get historialCampain => _historialCampain;

  Future<void> getHistorailCampains() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(
        Uri.parse('${_urlBase}promociones/historial-promociones'),
        headers: headers);

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    try {
      if (jsonResponse['code'] == 200) {
        final resp = modelHistorialCampainsFromJson(response.body);
        _historialCampain.clear();
        _historialCampain.add(resp.data);

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

  //CODIGO PROMOCIONAL

  //selecionar codigo o qr
  String _selectedEstiloCodPromo = '';
  String get selectedEstiloCodPromo => _selectedEstiloCodPromo;

  void setSelectedEstiloCodPromo(String value) {
    _selectedEstiloCodPromo = value;
    notifyListeners();
  }

  //seleccionador de productos cod promo
  String _selectedProducts = '';
  String get selectedProducts => _selectedProducts;
  void setSelectedProducts(String value) {
    _selectedProducts = value;
    if (value == '1') {
      setMostrarListaProducts(false);
      selectedProductList.clear();
      listaDeProductsFilter.clear();
      agregarTodosLosIDsProducts();
      print(selectedProductList.length);
    } else {
      selectedProductList.clear();
      setMostrarListaProducts(true);
    }
    notifyListeners();
  }

  //seleccionador de contactos
  String _selectedAlAzarContactos = '';
  String get selectedAlAzarContactos => _selectedAlAzarContactos;
  void setSelectedAlAzarContactos(String value) {
    _selectedAlAzarContactos = value;
    if (value == 'alazar') {
      setMostrarLista(false);
      selectedContactList.clear();
      listaDeContactosFilter.clear();
      agregarTodosLosIDsContacts();
      print(selectedContactList.length);
    } else {
      selectedContactList.clear();
      setMostrarLista(true);
    }
    notifyListeners();
  }

  //mostrar list o esconder lista de productos
  bool _mostrarListaProducts = false;
  bool get mostrarListaProducts => _mostrarListaProducts;
  void setMostrarListaProducts(bool value) {
    _mostrarListaProducts = value;
    notifyListeners();
  }

  //lista de productos

  List<Productos> _products = [];
  List<Productos> get getproducts => _products;

  Future<void> getTodosProductos() async {
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

  //busqueda de productos
  //BUSQUEDA DE CONTACTOS

  //lista de datos filtrados

  List<Productos> _listaDeProductsFilter = [];

  List<Productos> get listaDeProductsFilter => _listaDeProductsFilter;

  void filtrarListaproducts(List<Productos> listaCompleta, String query) {
    _listaDeProductsFilter = listaCompleta
        .where((elemento) =>
            elemento.nombreProducto.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  //para guardar los cproductos seleccionados

  List<int> selectedProductList = [];

  void toggleSelectionProducts(productosId) {
    if (selectedProductList.contains(productosId)) {
      selectedProductList.remove(productosId);
    } else {
      selectedProductList.add(productosId);
    }
    notifyListeners();
  }

  bool isSelectedProduct(int productId) {
    return selectedProductList.contains(productId);
  }
  //seleccionnadno todos los contactos

  void agregarTodosLosIDsProducts() {
    for (Productos producto in _products) {
      selectedProductList.add(producto.productoId);
    }
    notifyListeners();
  }

  //Almacenar fecha de de inicio codigo promocional

  String _fechaInicioSelectedCodPromo = '';
  String get fechaInicioSelectedCodPromo => _fechaInicioSelectedCodPromo;

  void setFechaInicioSelectedCodPromo(String value) {
    _fechaInicioSelectedCodPromo = value;
    notifyListeners();
  }

  //Almacenar fecha de fin codigo promocional

  String _fechaFinSelectedCodPromo = '';
  String get fechaFinSelectedCodPromo => _fechaFinSelectedCodPromo;

  void setFechaFinSelectedCodPromo(String value) {
    _fechaFinSelectedCodPromo = value;
    notifyListeners();
  }

  //cambio a true si el POST se realizo de manera correcta
  bool _OKpostDatosCrearPromoCodigo = false;
  bool get OkpostDatosCrearPromoCodigo => _OKpostDatosCrearPromoCodigo;

  setOKsendDatosCrearPromoCodigo(bool value) {
    _OKpostDatosCrearPromoCodigo = value;
    notifyListeners();
  }

  //loading mientras envian los datos
  bool _loadingDatosPromoCodigos = false;
  bool get loadingDatosPromoCodigos => _loadingDatosPromoCodigos;

  setLoadingDatosPromoCodigos(bool value) {
    _loadingDatosPromoCodigos = value;
    notifyListeners();
  }

  //metodo para crear promocion codigo
  Future<bool> enviarDatosCodPromocional(
    String estiloCodigof,
    String porcentajeDescuentof,
    List<int> productosf,
    String cantidadCodigosf,
    List<int> contactosf,
    String tipoEnviof,
    String fechaIniciof,
    String fechaFinalf,
  ) async {
    String urlFinal = '${_urlBase}promociones/promocion';

    setLoadingDatosPromoCodigos(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final datos = <String, dynamic>{
      "estilo_codigo": estiloCodigof,
      "porcentaje_descuento": porcentajeDescuentof,
      "productos": productosf,
      "cantidad_codigos": cantidadCodigosf,
      "contactos": contactosf,
      "tipo_envio": tipoEnviof,
      "fecha_inicio": fechaIniciof,
      "fecha_fin": fechaFinalf,
    };

    String body = jsonEncode(datos);

    final response =
        await http.post(Uri.parse(urlFinal), headers: headers, body: body);

    final jsonResponse = jsonDecode(response.body);

    try {
      if (jsonResponse['code'] == 200) {
        print('Solicitud exitosa');

        setLoadingDatosPromoCodigos(false);
        setOKsendDatosCrearPromoCodigo(true);
        notifyListeners();
        return OkpostDatosCrearPromoCodigo;
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');
        setLoadingDatosPromoCodigos(false);
        setOKsendDatosCrearPromoCodigo(false);
        notifyListeners();
        return OkpostDatosCrearPromoCodigo;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosPromoCodigos(false);
      setOKsendDatosCrearPromoCodigo(false);
      notifyListeners();
      return OkpostDatosCrearPromoCodigo;
    }
  }

  //SISTEMA DE PUNTOS

  String _selectedHabSisPuntos = '';
  String get selectedHabSisPuntos => _selectedHabSisPuntos;
  void setSelectedHabSisPuntos(String value) {
    _selectedHabSisPuntos = value;
    notifyListeners();
  }

  String _selectedproductsSisPuntos = '';
  String get selectedproductsSisPuntos => _selectedproductsSisPuntos;

  void setSelectedproductsSisPuntos(String value) {
    _selectedproductsSisPuntos = value;
    if (value == '1') {
      setMostrarListaProducts(false);
      selectedProductList.clear();
      listaDeProductsFilter.clear();
      agregarTodosLosIDsProducts();
      print(selectedProductList.length);
    } else {
      selectedProductList.clear();
      setMostrarListaProducts(true);
    }
    notifyListeners();
  }

  String _selectedContactsSisPuntos = '';

  String get selectedContactsSisPuntos => _selectedContactsSisPuntos;

  void setSelectedContactsSisPuntos(String value) {
    _selectedContactsSisPuntos = value;
    if (value == '1') {
      setMostrarLista(false);
      selectedContactList.clear();
      listaDeContactosFilter.clear();
      agregarTodosLosIDsContacts();
    } else {
      selectedContactList.clear();
      setMostrarLista(true);
    }
    notifyListeners();
  }

  //Almacenar fecha de de inicio sis puntos

  String _fechaInicioSelectedSisPuntos = '';
  String get fechaInicioSelectedSisPuntos => _fechaInicioSelectedSisPuntos;

  void setFechaInicioSelectedSisPuntos(String value) {
    _fechaInicioSelectedSisPuntos = value;
    notifyListeners();
  }

  //Almacenar fecha de fin sis puntos

  String _fechaFinSelectedSisPuntos = '';
  String get fechaFinSelectedSisPuntos => _fechaFinSelectedSisPuntos;

  void setFechaFinSelectedSisPuntos(String value) {
    _fechaFinSelectedSisPuntos = value;
    notifyListeners();
  }

  //cambio a true si el POST se realizo de manera correcta
  bool _OKpostDatosCrearSisPuntos = false;
  bool get OkpostDatosCrearSisPuntos => _OKpostDatosCrearSisPuntos;

  setOKsendDatosCrearSisPuntos(bool value) {
    _OKpostDatosCrearSisPuntos = value;
    notifyListeners();
  }

  //loading mientras envian los datos
  bool _loadingDatosSisPuntos = false;
  bool get loadingDatosSisPuntos => _loadingDatosSisPuntos;

  setLoadingDatosSisPuntos(bool value) {
    _loadingDatosSisPuntos = value;
    notifyListeners();
  }

  //almacenando el filePath

  String _selectedFilePathSisPuntos = '';
  String get selectedFilePathSisPuntos => _selectedFilePathSisPuntos;

  void setSelectedFilePathSisPuntos(String value) {
    _selectedFilePathSisPuntos = value;
    notifyListeners();
  }

  //almacenando el filename

  String _selectedNombreImagenSisPuntos = '';
  String get selectedNombreImagenSisPuntos => _selectedNombreImagenSisPuntos;

  void setSelectedNombreImagenSisPuntos(String value) {
    _selectedNombreImagenSisPuntos = value;
    notifyListeners();
  }

  //seleccionar imagen

  Future<void> openGalleryImgSisPuntos() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Esto limitará la selección a imágenes
    );

    if (result != null) {
      // El usuario ha seleccionado un archivo
      final filePath = result.files.single.path;
      final fileName = result.files.single.name;

      setSelectedFilePathSisPuntos(filePath!);
      setSelectedNombreImagenSisPuntos(fileName);
      notifyListeners();
    } else {
      // El usuario canceló la selección
      print('Selección cancelada');
    }
  }

  Future<bool> enviarDatosCrearSisPuntos(
    String tipof,
    String porcentajeDescf,
    String cantPuntosf,
    List<int> productsf,
    List<int> contactsf,
    String mensajeSisPuntosf,
    String fechaIniciof,
    String fechaFinf,
    String imagef,
  ) async {
    String urlFinal = '${_urlBase}promociones/promocion-puntos';

    String productsfString = productsf.join(',');
    String contactsfString = contactsf.join(',');
    final file = File(imagef);

    setLoadingDatosSisPuntos(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    var request = http.MultipartRequest('POST', Uri.parse(urlFinal));
    request.headers.addAll(headers);

    request.fields['tipo'] = tipof;
    request.fields['porcentaje_descuento'] = porcentajeDescf;
    request.fields['cantidad_puntos'] = cantPuntosf;
    request.fields['productos'] = productsfString;
    request.fields['contactos'] = contactsfString;
    request.fields['fecha_inicio'] = fechaIniciof;
    request.fields['fecha_fin'] = fechaFinf;

    final multipartFile = await http.MultipartFile.fromPath('imagen', imagef);
    request.files.add(multipartFile);

    //AQUI YA SE ESTA ENVIANDO TODO

    final response = await request.send();
    var responseStream = await response.stream.bytesToString();
    var responseData = jsonDecode(responseStream);

    try {
      if (responseData['code'] == 200) {
        print('Solicitud exitosa');
        print('Respuesta: ${responseStream}');

        setLoadingDatosSisPuntos(false);
        setOKsendDatosCrearSisPuntos(true);
        notifyListeners();
        return OkpostDatosCrearSisPuntos;
      } else {
        print('Error en la solicitud: ${responseData['code']}');
        setLoadingDatosSisPuntos(false);
        setOKsendDatosCrearSisPuntos(false);
        notifyListeners();
        return OkpostDatosCrearSisPuntos;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosSisPuntos(false);
      setOKsendDatosCrearSisPuntos(false);
      notifyListeners();
      return OkpostDatosCrearSisPuntos;
    }
  }

  //PROMO POR WHATSAPP

  //mostrar list o esconder
  bool _mostrarLista = false;
  bool get mostrarLista => _mostrarLista;
  void setMostrarLista(bool value) {
    _mostrarLista = value;
    notifyListeners();
  }

  //Radio Buttons

  String _selectedContactos = '';

  String get selectedContactos => _selectedContactos;

  void setSelectedContactos(String value) {
    _selectedContactos = value;
    if (value == '1') {
      setMostrarLista(false);
      selectedContactList.clear();
      listaDeContactosFilter.clear();
      agregarTodosLosIDsContacts();
    } else {
      selectedContactList.clear();
      setMostrarLista(true);
    }
    notifyListeners();
  }

  //listado de contactos
  //Listando PARTICIPANTES
  List<Contacts> _contactos = [];
  List<Contacts> get getcontactos => _contactos;

  Future<void> getContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http
        .get(Uri.parse('${_urlBase}promociones/contactos'), headers: headers);

    final responseData = jsonDecode(response.body);

    if (responseData['code'] == 200) {
      final resp = modelContactsCampainFromJson(response.body);
      _contactos.clear();
      _contactos.addAll(resp.data);

      notifyListeners();
    } else {
      throw Exception('Error al obtener los datos de la API');
    }
  }

  //BUSQUEDA DE CONTACTOS

  //lista de datos filtrados

  List<Contacts> _listaDeContactosFilter = [];

  List<Contacts> get listaDeContactosFilter => _listaDeContactosFilter;

  void filtrarListaContacts(List<Contacts> listaCompleta, String query) {
    _listaDeContactosFilter = listaCompleta
        .where((elemento) =>
            elemento.nombres.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  //para guardar los contactos seleccionados

  List<int> selectedContactList = [];

  void toggleSelectionContact(int participantId) {
    if (selectedContactList.contains(participantId)) {
      selectedContactList.remove(participantId);
    } else {
      selectedContactList.add(participantId);
    }
    notifyListeners();
  }

  bool isSelectedContact(int participantId) {
    return selectedContactList.contains(participantId);
  }
  //seleccionnadno todos los contactos

  void agregarTodosLosIDsContacts() {
    for (Contacts contacto in _contactos) {
      selectedContactList.add(contacto.contactoId);
    }
    notifyListeners();
  }

  //almacenando el filePath

  String _selectedFilePath = '';
  String get selectedFilePath => _selectedFilePath;

  void setSelectedFilePath(String value) {
    _selectedFilePath = value;
    notifyListeners();
  }

  //almacenando el filename

  String _selectedNombreImagen = '';
  String get selectedNombreImagen => _selectedNombreImagen;

  void setSelectedNombreImagen(String value) {
    _selectedNombreImagen = value;
    notifyListeners();
  }

  //seleccionar imagen

  Future<void> openGalleryImgWsp() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Esto limitará la selección a imágenes
    );

    if (result != null) {
      // El usuario ha seleccionado un archivo
      final filePath = result.files.single.path;
      final fileName = result.files.single.name;

      setSelectedFilePath(filePath!);
      setSelectedNombreImagen(fileName);
      notifyListeners();
    } else {
      // El usuario canceló la selección
      print('Selección cancelada');
    }
  }

  //cambio a true si el POST se realizo de manera correcta
  bool _OKpostDatosCrearpromoWsp = false;
  bool get OkpostDatosCrearpromoWsp => _OKpostDatosCrearpromoWsp;

  setOKsendDatosCrearpromoWsp(bool value) {
    _OKpostDatosCrearpromoWsp = value;
    notifyListeners();
  }

  //loading mientras envian los datos
  bool _loadingDatosPromoWsp = false;
  bool get loadingDatosPromoWsp => _loadingDatosPromoWsp;

  setLoadingDatosPromoWsp(bool value) {
    _loadingDatosPromoWsp = value;
    notifyListeners();
  }

  Future<bool> enviarDatosCrearPromoWsp(
    List<int> contactsf,
    String mensajeWspf,
    String imagef,
  ) async {
    String urlFinal = '${_urlBase}promociones/promocion-ws';

    String contactsfString = contactsf.join(',');
    final file = File(imagef);

    setLoadingDatosPromoWsp(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    var request = http.MultipartRequest('POST', Uri.parse(urlFinal));
    request.headers.addAll(headers);

    request.fields['contactos'] = contactsfString;
    request.fields['mensaje'] = mensajeWspf;
    final multipartFile = await http.MultipartFile.fromPath('imagen', imagef);
    request.files.add(multipartFile);

    //AQUI YA SE ESTA ENVIANDO TODO

    final response = await request.send();
    var responseStream = await response.stream.bytesToString();
    var responseData = jsonDecode(responseStream);

    try {
      if (responseData['code'] == 200) {
        print('Solicitud exitosa');
        print('Respuesta: ${responseStream}');

        setLoadingDatosPromoWsp(false);
        setOKsendDatosCrearpromoWsp(true);
        notifyListeners();
        return OkpostDatosCrearpromoWsp;
      } else {
        print('Error en la solicitud: ${responseData['code']}');
        setLoadingDatosPromoWsp(false);
        setOKsendDatosCrearpromoWsp(false);
        notifyListeners();
        return OkpostDatosCrearpromoWsp;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingDatosPromoWsp(false);
      setOKsendDatosCrearpromoWsp(false);
      notifyListeners();
      return OkpostDatosCrearpromoWsp;
    }
  }
}
