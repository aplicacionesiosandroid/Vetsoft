import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'dart:convert';

import '../../models/agregar_productos/productos/todos_los_productos_model.dart';


class ProductosTodosProvider with ChangeNotifier {
  List<TodosProductosModel> _productos = [];

  List<TodosProductosModel> get productos => _productos;


  Future<List<TodosProductosModel>> fetchTodosProductos() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('myToken') ?? '';
      final Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };

      final String apiUrl = '${apiUrlGlobal}petshop/todos-productos';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['error'] == false) {
          final List<dynamic> data = responseBody['data'];

          if (data != null && data is List) {
            _productos = data.map((item) {
              return TodosProductosModel.fromJson(item);
            }).toList();
            notifyListeners();
            return _productos; // Devuelve la lista de productos correctamente
          } else {
            // La respuesta del servidor no es una lista válida
            throw Exception('Respuesta del servidor no válida');
          }
        } else {
          print(responseBody['data']);
          throw Exception(
              'Error en la respuesta del servidor: ${responseBody['message']}');
        }
      } else {
        throw Exception('Error al cargar los productos');
      }
    } catch (error) {
      // Manejar errores aquí
      print('Error al cargar los productos: $error');
      return []; // En caso de error, devuelve una lista vacía o maneja el error según tu lógica
    }
  }
}
