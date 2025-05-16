import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';


import '../../models/agregar_productos/productos/ProductosFavoritosModel.dart';

class ProductosFavoritosProvider extends ChangeNotifier {
  List<ProductosFavoritosModel> _productos = [];

  List<ProductosFavoritosModel> get productos => _productos;

  Future<List<ProductosFavoritosModel>> fetchProductos() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('myToken') ?? '';
      final Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };

      final url = '${apiUrlGlobal}petshop/productos-mas-vendidos';

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey("data") && responseData["data"] is List) {
          final List<dynamic> parsedData = responseData["data"];
          final List<ProductosFavoritosModel> loadedProductos = parsedData
              .map((json) => ProductosFavoritosModel.fromJson(json))
              .toList();

          _productos = loadedProductos;
          notifyListeners();
          print(_productos);
          return _productos;
        } else {
          throw Exception('Respuesta de API inesperada');
        }
      } else {
        print(response.statusCode);
        throw Exception('Error al traer datos de productos');
      }
    } catch (error) {
      print('Error en fetchProductos: $error');
      throw error;
    }
  }
}