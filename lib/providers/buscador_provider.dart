import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/global/global_variables.dart';
import '../models/inicio/model_buscador.dart';
import 'package:http/http.dart' as http;

class BuscadorProvider extends ChangeNotifier {
  final String _urlBase = apiUrlGlobal;

  BuscadorProvider() {
    getbuscadorGeneral();
  }

  //lista de busqueda genral

  List<BuscadorGeneral> _buscadorGeneral = [];
  List<BuscadorGeneral> get buscadorGeneral => _buscadorGeneral;

  Future<void> getbuscadorGeneral() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization':
          'Bearer $token', // Incluye el token en el encabezado de autorización
    };

    final response = await http.get(Uri.parse('${_urlBase}buscador/buscador'),
        headers: headers);

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    try {
      if (jsonResponse['code'] == 200) {
        final resp = modelBusquedaGeneralFromJson(response.body);
        _buscadorGeneral.clear();
        _buscadorGeneral.add(resp.data);
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

  //filtros

  List<DataPropietario> _listaFiltradaClientes = [];
  List<DataPropietario> get listaFiltradaClientes => _listaFiltradaClientes;

  List<Paciente> _listaFiltradaPacientes = [];
  List<Paciente> get listaFiltradaPacientes => _listaFiltradaPacientes;

  List<Producto> _listaFiltradaProductos = [];
  List<Producto> get listaFiltradaProductos => _listaFiltradaProductos;

  void filtrarListasBuscador(
      List<DataPropietario> listaCompletaCliente,
      List<Paciente> listaCompletaPaciente,
      List<Producto> listaCompletaProducto,
      String query) {
        
      _listaFiltradaClientes = listaCompletaCliente
        .where((elemento) =>
            elemento.nombreCompleto.toLowerCase().contains(query.toLowerCase()))
        .toList();

      _listaFiltradaPacientes = listaCompletaPaciente
        .where((elemento) =>
            elemento.nombreMascota.toLowerCase().contains(query.toLowerCase()))
        .toList();

      _listaFiltradaProductos = listaCompletaProducto
    .where((elemento) =>
        elemento.nombreProducto != null &&
        elemento.nombreProducto?.toLowerCase().contains(query.toLowerCase()) == true
    )
    .toList();


    notifyListeners();
  }
}
