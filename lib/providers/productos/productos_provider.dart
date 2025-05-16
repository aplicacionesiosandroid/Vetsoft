import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/common/views/modals_widget.dart';
import 'package:vet_sotf_app/models/agregar_productos/productos/dropdowns_mode.dart';
import 'package:http/http.dart' as http;
import 'package:vet_sotf_app/models/agregar_productos/productos/proveedores_model.dart';
import 'package:vet_sotf_app/models/tareas/participantes_tareas_model.dart';

import '../../config/global/global_variables.dart';
import '../../models/agregar_productos/productos/prod_mas_vendidos_model.dart';
import '../../models/campain/model_historial_campains.dart';

class ProductosProvider extends ChangeNotifier {
  ProductosProvider() {
    getProveedores();
    getDropdownData();
    getHistorailCampain();
    getProductosMasVendidos();
  }

  final String _urlBase = apiUrlGlobal;

  //cambiar vista a control de stock
  bool _vistaControlStock = false;
  bool get vistaControlStock => _vistaControlStock;

  void setVistaControlStock() {
    _vistaControlStock = !_vistaControlStock;
    notifyListeners();
  }

  //Productos mas vendidos LISTADO
  //Listando PRODUCTOS DE UNA CATEGORIA
  final List<ProductoMasVendido> _productsMasVendidos = [];
  List<ProductoMasVendido> get productsMasVendidos => _productsMasVendidos;

  Future<void> getProductosMasVendidos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(
        Uri.parse('${_urlBase}petshop/productos-mas-vendidos'),
        headers: headers);

    final resDecode = jsonDecode(response.body);

    print("respuesta productos: " + response.body);

    try {
      if (resDecode['code'] == 200) {
        final resp = modelProductosmasVendidosFromJson(response.body);
        _productsMasVendidos.clear();
        _productsMasVendidos.addAll(resp.data);
        notifyListeners();
      } else {
        throw Exception('Error al obtener los datos de la API');
      }
    } catch (e) {
      throw Exception('Error al obtener los datos de la  catch' + e.toString());
    }
  }

  //Promociones activas LISTADO

  final List<HistorialCampain> _historialCampain = [];
  List<HistorialCampain> get historialCampain => _historialCampain;

  Future<void> getHistorailCampain() async {
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

  //radio buttons de proveedor

  String _selectedProveedor = 'true';

  String get selectedProveedor => _selectedProveedor;

  void setSelectedProveedor(String gender) {
    _selectedProveedor = gender;
    notifyListeners();
  }

  //Listando proveedores
  List<Proveedor> _proveedor = [];
  List<Proveedor> get proveedor => _proveedor;

  Future<void> getProveedores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http
        .get(Uri.parse('${_urlBase}formulario/provedores'), headers: headers);

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    try {
      if (jsonResponse['code'] == 200) {
        final resp = modelProveedoresFromJson(response.body);
        _proveedor.clear();
        _proveedor.addAll(resp.data);
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

  int? _proveedorSeleccionadoActual;
  int? get proveedorSeleccionadoActual => _proveedorSeleccionadoActual;
  String? _proveedorSeleccionadoActualNombre;
  String? get proveedorSeleccionadoActualNombre =>
      _proveedorSeleccionadoActualNombre;

  void setNombreproveedor(String? value) {
    _proveedorSeleccionadoActualNombre = value;
    notifyListeners();
  }

  void setProveedorSeleccionado(int? proveedorId, String nombre) {
    _proveedorSeleccionadoActual = proveedorId;
    setNombreproveedor(nombre);
    notifyListeners();
  }

  bool esProveedorSeleccionado(int? proveedorId) {
    return _proveedorSeleccionadoActual == proveedorId;
  }

  //Almacenar fecha de compra

  String _fechaCompra = '';
  String get fechaCompra => _fechaCompra;

  void setFechaCompra(String value) {
    _fechaCompra = value;
    notifyListeners();
  }

  //lista de datos filtrados

  List<Proveedor> _listaFiltradaProveedor = [];

  List<Proveedor> get listaFiltradaProveedor => _listaFiltradaProveedor;

  void filtrarListaProveedores(List<Proveedor> listaCompleta, String query) {
    _listaFiltradaProveedor = listaCompleta
        .where(
            (elemento) => elemento.nombreProvedor.contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  //listar lo necesario para los dropdown dinamicos
  final List<Dropdowns> _dropDownsProductos = [];
  List<Dropdowns> get dropDownsProductos => _dropDownsProductos;

  Future<void> getDropdownData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(
        Uri.parse('${_urlBase}formulario/petshop-registro-productos'),
        headers: headers);

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    try {
      if (jsonResponse['code'] == 200) {
        final resp = modelDropDownsFromJson(response.body);
        _dropDownsProductos.clear();
        _dropDownsProductos.add(resp.data);
        grupos = _dropDownsProductos[0].grupo;
        marcas = _dropDownsProductos[0].marcas;
        unidadesMedida = _dropDownsProductos[0].unidadesMedida;
        almacenes = _dropDownsProductos[0].almacenes;
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

  //para sub grupos y grupos
  List<Grupo> grupos = [];
  List<SubGrupo> subgruposSeleccionados = [];
  int selectedGrupoIndex = -1; // Índice del grupo seleccionado
  String? selectedSubGrupo; // Subgrupo seleccionado

  //variables para al macenar id de dropwond categoria y sub categoria

  int? selectedGroupId;
  int? selectedSubGroupId;

  //hasta aqui pra grupos y subgrupos

  void updateSubgrupos([int? newIndex]) {
    // Actualiza el índice del grupo seleccionado si se proporciona un nuevo índice
    if (newIndex != null) {
      selectedGrupoIndex = newIndex;
    }
    subgruposSeleccionados = grupos[selectedGrupoIndex]
        .subGrupo
        .expand((subGrupos) => subGrupos)
        .toList();
    notifyListeners();
  }

  void updateSelectedSubGrupo(String? newSelectedSubGrupo) {
    selectedSubGrupo = newSelectedSubGrupo;
    notifyListeners();
  }

  void updateSelectedGroupAndSubGroup(
      int? newSelectedGroupId, int? newSelectedSubGroupId) {
    selectedGroupId = newSelectedGroupId;
    selectedSubGroupId = newSelectedSubGroupId;
    notifyListeners();
  }

  //AÑADIENDO SUBCATEGORIA
  Future<void> setNewSubcategory(
      int? idCategory, String nameSubcategory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    Map<String, String> body = {
      'grupo_id': idCategory.toString(),
      'subcategoria': nameSubcategory.toUpperCase(),
    };

    final response = await http.post(
        Uri.parse('${_urlBase}formulario/crear-subcategoria'),
        headers: headers,
        body: body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['error'] == false) {
        final newSubcategoryData = responseData['data'];
        int newId = newSubcategoryData['sub_grupo_id'];
        String newName = newSubcategoryData['nombre'].toUpperCase();
        var newSubcategory = SubGrupo(subGrupoId: newId, nombre: newName);
        subgruposSeleccionados.add(newSubcategory);
        grupos[selectedGrupoIndex].subGrupo[0].add(newSubcategory);
        selectedSubGroupId = newId;
        notifyListeners();
      } else {
        print('Error en la respuesta del servidor: ${responseData['message']}');
      }
    } else {
      print('Error en la solicitud HTTP: ${response.statusCode}');
    }
  }

  //listar marcas
  List<Marca> marcas = [];
  int? selectedMarcaId;

  //AÑADIENDO MARCA
  Future<void> setNewMarca(String nameSubcategory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    Map<String, String> body = {
      'marca': nameSubcategory.toUpperCase(),
    };

    final response = await http.post(
        Uri.parse('${_urlBase}formulario/crear-marca'),
        headers: headers,
        body: body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['error'] == false) {
        final repNewMarca = responseData['data'];
        int newId = repNewMarca['marca_id'];
        String newName = repNewMarca['nombre'].toUpperCase();
        var newMarca = Marca(marcaId: newId, nombre: newName);
        marcas.add(newMarca);
        selectedMarcaId = newId;
        notifyListeners();
      } else {
        print('Error en la respuesta del servidor: ${responseData['message']}');
      }
    } else {
      print('Error en la solicitud HTTP: ${response.statusCode}');
    }
  }

  //switch para agregar o no fecha de vencimiento
  bool _switchValueAgreeFVencimiento = false;
  bool get switchValueAgreeFVencimiento => _switchValueAgreeFVencimiento;

  set setSwitchValueAgreeFVencimiento(bool value) {
    _switchValueAgreeFVencimiento = value;
    notifyListeners();
  }

  //LISTA UNIDADES DE MEDIDA
  List<UnidadesMedida> unidadesMedida = [];
  int? selectedUnidadMedidaId;
  UnidadesMedida? unidadSeleccionada;

  void updateSelectedUnidadMedida(int? newSelectedUnidadMedidaId) {
    selectedUnidadMedidaId = newSelectedUnidadMedidaId;
    // Buscar la unidad de medida con el id seleccionado
    if (newSelectedUnidadMedidaId != null) {
      unidadSeleccionada = unidadesMedida
          .firstWhere((unidad) => unidad.unidadId == newSelectedUnidadMedidaId);
    }
    notifyListeners();
  }

  //Almacenar fecha de VENCIMIENTO

  String _fechaVencimiento = '';
  String get fechaVencimiento => _fechaVencimiento;

  void setFechaVencimiento(String value) {
    _fechaVencimiento = value;
    notifyListeners();
  }

  //ultimo form 3ro

  //switch para agregar codigo de producto
  bool _switchValueAgreeCodProducto = false;
  bool get switchValueAgreeCodProducto => _switchValueAgreeCodProducto;

  set setSwitchValueAgreeCodProducto(bool value) {
    _switchValueAgreeCodProducto = value;
    notifyListeners();
  }

  //switch para agregar codigo de barras
  bool _switchValueAgreeCodBarras = false;
  bool get switchValueAgreeCodBarras => _switchValueAgreeCodBarras;

  set setSwitchValueAgreeCodBarras(bool value) {
    _switchValueAgreeCodBarras = value;
    notifyListeners();
  }

  //alamcenes radio buttons
  List<Almacene> almacenes = [];
  int? selectedAlmacenId;

  void updateSelectedAlmacen(int? newSelectedAlmacenId) {
    selectedAlmacenId = newSelectedAlmacenId;
    notifyListeners();
  }

  //lista de imagenes

  List<XFile> imageFileList = [];

  Future addPhoto(ImageSource source) async {
    final XFile? selectImage = await ImagePicker().pickImage(source: source);
    // ignore: unrelated_type_equality_checks
    if (selectImage != null && selectImage != '') {
      imageFileList.add(selectImage!);
      notifyListeners();
    }
  }

  //metodo para registrar

  //loading mientras envian los datos
  bool _loadingDatosPostProducto = false;
  bool get loadingDatosPostProducto => _loadingDatosPostProducto;

  setLoadingDatosPostProducto(bool value) {
    _loadingDatosPostProducto = value;
    notifyListeners();
  }

  //cambio a true si el POST se realizo de manera correcta
  bool _oKpostDatosPostProducto = false;
  bool get okpostDatosPostProducto => _oKpostDatosPostProducto;

  setOKsendDatosPostProducto(bool value) {
    _oKpostDatosPostProducto = value;
    notifyListeners();
  }

  Future<bool> enviarDatosCrearProducto(
      //proveedor
      String idProveedorf,
      String nombreProveedorf,
      String celularProveedorf,
      String fechaCompraProveedorf,
      String numFacturaProveedorf,
      String notaEmisionProveedorf,
      String observacionProveedorf,

      //datos productos
      String grupoIdf,
      String subGrupoIdf,
      String marcaIdf,
      String registrarUnidadf,
      String nombreUnidadf,
      String abreviaturaUnidadf,
      String addCodigoProductof,
      String codigoProductof,
      String addCodigoBarraf,
      String codigoBarraf,
      String descripcionf,
      String stockTotalf,
      String stockMinimof,
      String almacenIdf,
      String preciounidadf,
      String precioVentaf,
      String puntosProductof,
      List<XFile> fotoProductof,
      String fechaVencimientof,
      String nombreProductof) async {
    String urlFinal = '${_urlBase}petshop/registro-producto';

    setLoadingDatosPostProducto(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    var request = http.MultipartRequest('POST', Uri.parse(urlFinal));
    request.headers.addAll(headers);

    //DATOS DEL PROPIETARIO
    request.fields['provedor[provedor_id]'] = idProveedorf;
    request.fields['provedor[nombre]'] = nombreProveedorf;
    request.fields['provedor[celular]'] = celularProveedorf;
    request.fields['provedor[fecha_compra]'] = fechaCompraProveedorf;
    request.fields['provedor[num_factura]'] = numFacturaProveedorf;
    request.fields['provedor[nota_remision]'] = notaEmisionProveedorf;
    request.fields['provedor[observacion]'] = observacionProveedorf;

    //DATOS DEL PACIENTE
    request.fields['datos_producto[grupo_id]'] = grupoIdf;
    request.fields['datos_producto[sub_grupo_id]'] = subGrupoIdf;
    request.fields['datos_producto[marca_id]'] = marcaIdf;
    request.fields['datos_producto[registrar_unidad]'] = registrarUnidadf;
    request.fields['datos_producto[unidad]'] = nombreUnidadf;
    request.fields['datos_producto[abreviatura]'] = abreviaturaUnidadf;
    request.fields['datos_producto[agregar_cod_produc]'] = addCodigoProductof;
    request.fields['datos_producto[codigo]'] = codigoProductof;
    request.fields['datos_producto[agregar_cod_barra]'] = addCodigoBarraf;
    request.fields['datos_producto[codigo_barras]'] = codigoBarraf;
    request.fields['datos_producto[descripcion]'] = descripcionf;
    request.fields['datos_producto[stock_total]'] = stockTotalf;
    request.fields['datos_producto[stock_minimo]'] = stockMinimof;
    request.fields['datos_producto[almacen_id]'] = almacenIdf;
    request.fields['datos_producto[precio_unidad]'] = preciounidadf;
    request.fields['datos_producto[precio_venta]'] = precioVentaf;
    request.fields['datos_producto[puntos_producto]'] = puntosProductof;
    // request.fields['datos_producto[imagen]'] = imageFileList as String;
    for (var image in imageFileList) {
      var multipartFile = await http.MultipartFile.fromPath(
          'datos_producto[imagen][]', image.path);
      request.files.add(multipartFile);
    }
    request.fields['datos_producto[fecha_vencimiento]'] = fechaVencimientof;
    request.fields['datos_producto[nombre_producto]'] = nombreProductof;

    //AQUI YA SE ESTA ENVIANDO TODO
    // // Imprimir todos los datos antes de enviarlos
    // print("Enviando datos de Proveedor:");
    // print("ID Proveedor: $idProveedorf");
    // print("Nombre Proveedor: $nombreProveedorf");
    // print("Celular Proveedor: $celularProveedorf");
    // print("Fecha Compra: $fechaCompraProveedorf");
    // print("Num. Factura: $numFacturaProveedorf");
    // print("Nota Emisión: $notaEmisionProveedorf");
    // print("Observación: $observacionProveedorf");

    // print("\nEnviando datos de Producto:");
    // print("Grupo ID: $grupoIdf");
    // print("Subgrupo ID: $subGrupoIdf");
    // print("Marca ID: $marcaIdf");
    // print("Registrar Unidad: $registrarUnidadf");
    // print("Nombre Unidad: $nombreUnidadf");
    // print("Abreviatura Unidad: $abreviaturaUnidadf");
    // print("Agregar Código Producto: $addCodigoProductof");
    // print("Código Producto: $codigoProductof");
    // print("Agregar Código Barra: $addCodigoBarraf");
    // print("Código Barra: $codigoBarraf");
    // print("Descripción: $descripcionf");
    // print("Stock Total: $stockTotalf");
    // print("Stock Mínimo: $stockMinimof");
    // print("Almacén ID: $almacenIdf");
    // print("Precio Unidad: $preciounidadf");
    // print("Precio Venta: $precioVentaf");
    // print("Puntos Producto: $puntosProductof");
    // print("Fecha Vencimiento: $fechaVencimientof");
    // print("Nombre Producto: $nombreProductof");

    // for (var image in fotoProductof) {
    //   print("Imagen: ${image.path}");
    // }

    final response = await request.send();
    var responseStream = await response.stream.bytesToString();
    var responseData = jsonDecode(responseStream);

    try {
      if (responseData['code'] == 200) {
        print('Solicitud exitosa');
        print('Respuesta: ${responseStream}');
        setLoadingDatosPostProducto(false);
        setOKsendDatosPostProducto(true);
        notifyListeners();
        return okpostDatosPostProducto;
      } else {
        print('Error en la solicitud: ${responseData['data']}');
        setLoadingDatosPostProducto(false);
        setOKsendDatosPostProducto(false);
        CustomToast.showToast(responseData['data']);
        notifyListeners();
        return okpostDatosPostProducto;
      }
    } catch (e) {
      print('errooorrr $e');
      CustomToast.showToast(e.toString());
      setLoadingDatosPostProducto(false);
      setOKsendDatosPostProducto(false);
      notifyListeners();
      return okpostDatosPostProducto;
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

  bool isSelectedMap(int participantId) {
    return selectedParticipantsMap.containsKey(participantId);
  }

  void resetearForm() {
    _selectedProveedor = 'true';
    _switchValueAgreeFVencimiento = false;
    _fechaVencimiento = '';
    selectedUnidadMedidaId = null;
    selectedAlmacenId = null;
    imageFileList = [];
    selectedParticipantsMap = {};
    selectedParticipantsList = [];
  }
}
