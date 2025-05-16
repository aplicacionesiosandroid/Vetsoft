import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/common/utils/utils.dart';
import 'package:vet_sotf_app/models/inicio/model_caja.dart';
import 'package:vet_sotf_app/models/petshop/HomePetshop/categorias_model.dart';
import 'package:http/http.dart' as http;
import 'package:vet_sotf_app/models/petshop/HomePetshop/producto_model.dart';

import '../../../config/global/global_variables.dart';
import '../../../models/petshop/HomePetshop/carrito_model.dart';
import '../../../models/petshop/registroCompra/codigoDescuento_model.dart';
import '../../../models/petshop/registroCompra/descuento_sis_puntos_model.dart';

class HomePetShopProvider extends ChangeNotifier {
  HomePetShopProvider() {
    getGruposProductos();
  }

  final String _urlBase = apiUrlGlobal;

  //Para expandir la notificacion
  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;
  void toggleExpansion() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  String _currentCategory = 'Seleccione una categoría'; // Valor inicial

  String get currentCategory => _currentCategory;

  void setCurrentCategory(String category) {
    _currentCategory = category;
    notifyListeners(); // Notificar a los widgets que escuchan este provider
  }

  //Metodo para get de Categorias Productos

  List<GrupoProducto> _groupProducts = [];
  List<GrupoProducto> get groupProducts => _groupProducts;

  Future<void> getGruposProductos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(Uri.parse('${_urlBase}petshop/grupos'),
        headers: headers);

    final resDecode = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {
        final resp = modelGrupoProductosFromJson(response.body);
        _groupProducts.clear();
        _groupProducts.addAll(resp.data);
        if (resDecode['data'] != '') {
          final grupoId = resDecode['data'][0]['grupo_id'];
          getProductosDeGrupo(grupoId);
        }
        print(jsonDecode(response.body));
        notifyListeners();
      } else {
        throw Exception('Error al obtener los datos de la API');
      }
    } catch (e) {
      print('Error al obtener los datos de la API catch');
    }
  }

  //Listando PRODUCTOS DE UNA CATEGORIA
  final List<Productos> _products = [];
  List<Productos> get products => _products;

  Future<void> getProductosDeGrupo(String idGrupoProduct) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };
    Utilidades.imprimir('${_urlBase}petshop/productos-grupo/$idGrupoProduct');
    final response = await http.get(
        Uri.parse('${_urlBase}petshop/productos-grupo/$idGrupoProduct'),
        headers: headers);
    final resDecode = jsonDecode(response.body);
    Utilidades.imprimir('respuesta de productos de grupo: $resDecode');
    try {
      if (resDecode['code'] == 200) {
        final resp = modelProductosFromJson(response.body);
        _products.clear();
        _products.addAll(resp.data);
        _productsFiltrado = _products;
        notifyListeners();
      } else {
        throw Exception('Error al obtener los datos de la API');
      }
    } catch (e) {
      throw Exception(
          'Error al obtener los datos de la  catch ' + e.toString());
    }
  }

  //lista de filtrados
  List<Productos> _productsFiltrado = [];
  List<Productos> get productsFiltre => _productsFiltrado;

  filtrarProductosCategoria(
      List<Productos> listaCompletaProducto, String query) {
    _productsFiltrado = listaCompletaProducto
        .where((elemento) =>
            elemento.nombreProducto != null &&
            elemento.nombreProducto
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ==
                true)
        .toList();

    notifyListeners();
  }

  filtrarPorQR(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(
        Uri.parse('${_urlBase}petshop/buscar-producto-qr?codigo=$query'),
        headers: headers);
    final resDecode = jsonDecode(response.body);
    print(resDecode);

    try {
      if (resDecode['code'] == 200) {
        final resp = jsonToProduct(response.body);
        _productsFiltrado.clear();
        _productsFiltrado.add(resp.data);
        notifyListeners();
      } else {
        Utilidades.imprimir(
            'Error al obtener los datos de la API buscador QR petshop');
      }
    } catch (e) {
      Utilidades.imprimir(
          'Error al obtener los datos de la API buscador QR petshop catch' +
              e.toString());
    }
  }

  //Logica para agregar cantidad de un producto

  int _cantidadProduct = 0;
  int get cantidadProduct => _cantidadProduct;

  void setCantidadProduct(int value) {
    _cantidadProduct = value;
    notifyListeners();
  }

  void setincrementProduct() {
    _cantidadProduct = _cantidadProduct + 1;
    notifyListeners();
  }

  void setDecrementProduct() {
    if (_cantidadProduct > 0) {
      _cantidadProduct = _cantidadProduct - 1;
    }
    notifyListeners();
  }

  //Carrito
  List<CartItemAdd?> _items = [];

  List<CartItemAdd?> get items => _items;

  void addToCart(int productId, int cantidad, String nombreProducto,
      int precioUnit, int stockDisponible, String imagenProducto) {
    // Buscar si el producto ya está en el carrito por su ID
    final existingItem = _items.firstWhere(
      (item) => item?.producto_id == productId,
      orElse: () => null,
    );

    if (existingItem != null) {
      if (existingItem.cantidad + cantidad <= stockDisponible) {
        existingItem.cantidad += cantidad;
        existingItem.monto = (existingItem.cantidad * precioUnit).toDouble();
      } else {}
    } else {
      // Si el producto no está en el carrito, agrégalo
      _items.add(CartItemAdd(
          producto_id: productId,
          cantidad: cantidad,
          producto_nombre: nombreProducto,
          precio_unitario: precioUnit,
          imagen: imagenProducto,
          monto: (cantidad * precioUnit.toDouble())));
    }
    setOKisAgree(true);

    notifyListeners();
  }

  //metodo para eliminar un producot del carrito
  void removeProduct(int productId) {
    _items.removeWhere((item) => item?.producto_id == productId);
    notifyListeners();
  }

  //para agregar cantidad a un producto en carrito

  /* void increaseQuantity(int productId) {
    final product = _items.firstWhere((item) => item?.producto_id == productId, orElse: () => null);
    if (product != null) {
      product.cantidad++; 
      product.monto = (product.cantidad * product.precio_unitario).toDouble(); // Actualizar el monto total
      notifyListeners();
    }
  } */

  void increaseQuantity(int productId, double maxQuantity) {
    final product = _items.firstWhere((item) => item?.producto_id == productId,
        orElse: () => null);
    if (product != null) {
      final newQuantity = product.cantidad + 1;
      if (newQuantity <= maxQuantity) {
        product.cantidad = newQuantity;
        product.monto = (newQuantity * product.precio_unitario)
            .toDouble(); // Actualizar el monto total

        notifyListeners();
      }
    }
  }

//para quitar cantidad a un producto en carrito
  void decreaseQuantity(int productId) {
    final product = _items.firstWhere((item) => item?.producto_id == productId,
        orElse: () => null);
    if (product != null && product.cantidad > 1) {
      product.cantidad--;
      product.monto = (product.cantidad * product.precio_unitario)
          .toDouble(); // Actualizar el monto total
      notifyListeners();
    }
  }

  //cantidad disponible

  int _cantDisponible = 0;
  int get cantDisponible => _cantDisponible;

  void setCantDisponible(int value) {
    _cantDisponible = value;
    notifyListeners();
  }

  //monto descuento
  double _descuento = 0;
  double get descuento => _descuento;

  void setDescuento(double value) {
    _descuento = value;
    notifyListeners();
  }

  //TOTAL A PAGAR
  double _totalPagar = 0;
  double get totalPagar => _totalPagar;

  double getTotalPagar() {
    return _totalPagar = calcularSubTotal() - _descuento;
  }

  //mostrando subtotal

  double calcularSubTotal() {
    return _items.fold(0.0, (double total, CartItemAdd? item) {
      return total + item!.monto;
    });
  }

  //para animacion de agregado a carrito
  bool _isAgree = false;
  bool get isAgree => _isAgree;

  setOKisAgree(bool value) {
    _isAgree = value;
    notifyListeners();
  }

  //canjear puntos por compras

  List<Map<String, dynamic>> listaProductosEnviarParaDescuento = [];

  // Función para convertir los datos de _items a la estructura deseada
  void cargarProductosParaObtenerDescuentos(List<CartItemAdd?> items) {
    listaProductosEnviarParaDescuento.clear();
    for (var item in items) {
      final producto = {
        "producto_id": item!.producto_id,
        "cantidad": item.cantidad,
      };
      listaProductosEnviarParaDescuento.add(producto);
    }
    //return listaProductosEnviarParaDescuento;
    print(listaProductosEnviarParaDescuento);
  }

  //loader para carga de descuento por producto
  bool _loadingDescuentoPorProducto = false;
  bool get loadingDescuentoPorProducto => _loadingDescuentoPorProducto;

  setLoadingDescuentoPorProducto(bool value) {
    _loadingDescuentoPorProducto = value;
    notifyListeners();
  }

  //ok al envio de datos

  //loading mientras envian los datos
  bool _okPostDescuentoPorproducto = false;
  bool get okPostDescuentoPorproducto => _okPostDescuentoPorproducto;

  setOkPostDescuentoPorproducto(bool value) {
    _okPostDescuentoPorproducto = value;
    notifyListeners();
  }

  //LISTAS CANJEADAS PRODUCTOS SITEMA DE PUNTOS

  ModelCanjeoSisPuntos? _citasProductsDescuentoSispuntos = null;
  ModelCanjeoSisPuntos? get getcitasProductsDescuentoSispuntos =>
      _citasProductsDescuentoSispuntos;

  //meotod para hacer canje por puntos y por compra
  Future<bool> canjearPorPuntos(
      String ciClientef, List<Map<String, dynamic>> listaProductoCanjef) async {
    String urlFinal = '${_urlBase}promociones/sistema-puntos';

    setLoadingDescuentoPorProducto(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "documento": ciClientef,
      "productos": listaProductoCanjef,
    });

    final response =
        await http.post(Uri.parse(urlFinal), body: body, headers: headers);

    final jsonResponse = jsonDecode(response.body);

    try {
      if (jsonResponse['code'] == 200) {
        print('Solicitud exitosa');
        final resp = modelCanjeoSisPuntosFromJson(response.body);

        // _citasProductsDescuentoSispuntos.clear();
        _citasProductsDescuentoSispuntos = resp;
        aplicarDescuentos(_citasProductsDescuento);

        setLoadingDescuentoPorProducto(false);
        setOkPostDescuentoPorproducto(true);
        print(jsonResponse);
        notifyListeners();
        return okPostDescuentoPorproducto;
      } else {
        Utilidades.imprimir(
            'Error en la solicitud de canjear puntos: ${jsonResponse}');
        setLoadingDescuentoPorProducto(false);
        setOkPostDescuentoPorproducto(false);
        notifyListeners();
        return okPostDescuentoPorproducto;
      }
    } catch (e) {
      Utilidades.imprimir('errooorrr en la solicitud de canjear puntos: $e');
      setLoadingDescuentoPorProducto(false);
      setOkPostDescuentoPorproducto(false);
      notifyListeners();
      return okPostDescuentoPorproducto;
    }
  }

  //listar productos con descuento segun el codigo de canjeo

  //loader para carga de descuento de codigo
  bool _loadingCanjearCodigo = false;
  bool get loadingCanjearCodigo => _loadingCanjearCodigo;

  setLoadingRCanjearCodigo(bool value) {
    _loadingCanjearCodigo = value;
    notifyListeners();
  }

  //ok al envio de datos

  //loading mientras envian los datos
  bool _okPostCanjearCodigo = false;
  bool get okPostCanjearCodigo => _okPostCanjearCodigo;

  setOkPostCanjearCodigo(bool value) {
    _okPostCanjearCodigo = value;
    notifyListeners();
  }

  //Listando citas medicas

  List<ProductosDescuento> _citasProductsDescuento = [];
  List<ProductosDescuento> get getcitasProductsDescuento =>
      _citasProductsDescuento;

  //metodo para canjear codigo descuento

  Future<bool> canjearDescuento(
    String codeDescuento,
  ) async {
    String urlFinal =
        '${_urlBase}promociones/codigo-promocion?codigo=$codeDescuento';

    setLoadingRCanjearCodigo(true);

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
        final resp = modelcodigoPromocionFromJson(response.body);

        _citasProductsDescuento.clear();
        _citasProductsDescuento.addAll(resp.data);
        aplicarDescuentos(_citasProductsDescuento);

        setLoadingRCanjearCodigo(false);
        setOkPostCanjearCodigo(true);
        print(jsonResponse);
        notifyListeners();
        return okPostCanjearCodigo;
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');
        setLoadingRCanjearCodigo(false);
        setOkPostCanjearCodigo(false);
        notifyListeners();
        return okPostCanjearCodigo;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingRCanjearCodigo(false);
      setOkPostCanjearCodigo(false);
      notifyListeners();
      return okPostCanjearCodigo;
    }
  }

  //metodo para hacer el desceunto por codigo de promocion

  void aplicarDescuentos(List<ProductosDescuento> descuentos) {
    if (descuentos.isEmpty) {
      return; // No hay descuentos para aplicar
    }

    final porcentajeDescuento = descuentos[0].porcentajeDescuento;

    for (var descuento in descuentos) {
      final productosId = descuento.productosId;

      for (var productoId in productosId) {
        final productoEnCarrito = _items.firstWhere(
          (item) => item!.producto_id == productoId,
          orElse: () => null,
        );

        if (productoEnCarrito != null) {
          // Calcular el descuento por unidad del producto
          final descuentoPorUnidad =
              (productoEnCarrito.precio_unitario * (porcentajeDescuento / 100));

          // Aplicar el descuento al monto de cada unidad del producto
          productoEnCarrito.monto -=
              descuentoPorUnidad * productoEnCarrito.cantidad;
        }
      }
    }

    notifyListeners();
  }

  Future<bool> enviarDatos(
    String nroDocumento,
    String nombres,
    String apellidos,
    String correo,
    String numeroCelular,
    double totalPagar,
    String vigenciaCodigo,
    bool registrarCliente,
    bool descuentoPuntosProducto,
    String metodoPagoTipo,
    double metodoPagoDescuento,
    String metodoPagoFecha,
    List<Map<String, dynamic>> resumenCompra,
  ) async {
    Utilidades.imprimir(
        'Se presionó el botón de siguiente con datos del cliente: $nroDocumento, $nombres, $apellidos');

    final url = Uri.parse('${_urlBase}petshop/compra');

    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> datos = {
      "numero_documento": nroDocumento,
      "nombres": nombres,
      "apellidos": apellidos,
      "tipo_documento": "CI",
      "correo": correo,
      "numero_celular": numeroCelular,
      "total_pagar": totalPagar,
      "vigenciaCodigo": vigenciaCodigo,
      "registrar_cliente": registrarCliente,
      "descuento_puntos_producto": descuentoPuntosProducto,
      "metodo_pago": {
        "total_pagar": totalPagar,
        "descuento": metodoPagoDescuento,
        "fecha_pago": metodoPagoFecha,
        "tipo": metodoPagoTipo,
        "resumen_compra": resumenCompra
      }
    };

    Utilidades.imprimir("DATOS ENVIADOS >>> ${jsonEncode(datos)}");

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(datos),
      );
      BotToast.showText(
          text: response.body.toString(), duration: const Duration(seconds: 5));
      if (response.statusCode == 200 || response.statusCode == 201) {
        Utilidades.imprimir(
            "Compra registrada correctamente: ${response.body}");

        return true;
      } else {
        Utilidades.imprimir(
            "Error al registrar la compra (Código ${response.statusCode}): ${response.body}");
        return false;
      }
    } catch (e) {
      BotToast.showText(
          text: e.toString(), duration: const Duration(seconds: 5));
      print("Error en la petición: $e");
      return false;
    }
  }
}
