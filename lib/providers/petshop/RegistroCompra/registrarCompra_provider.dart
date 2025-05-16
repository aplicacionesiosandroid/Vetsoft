import 'package:flutter/material.dart';


import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vet_sotf_app/providers/petshop/HomePetshop/home_petshop_provider.dart';

import '../../../config/global/global_variables.dart';

class RegistroCompraProvider extends ChangeNotifier {

  final providerCarrito = HomePetShopProvider();


  //loading mientras envian los datos
  bool _loadingRegistrarCompra = false;
  bool get loadingRegistrarCompra => _loadingRegistrarCompra;

  setLoadingRegistrarCompra(bool value) {
    _loadingRegistrarCompra = value;
    notifyListeners();
  }

  //ok al envio de datos

  //loading mientras envian los datos
  bool _okPostRegistroCompra = false;
  bool get okPostRegistroCompra => _okPostRegistroCompra;

  setOkPostRegistroCompra(bool value) {
    _okPostRegistroCompra = value;
    notifyListeners();
  }



  //METODO PARA HACER EL REGISTRO DEL CLIENTE Y COMPRA
  final String _urlBase = apiUrlGlobal;

  Future<bool> enviarDatosCrearTarea() async {
    String urlFinal = '${_urlBase}tareas/crear-tarea';

    setLoadingRegistrarCompra(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final datos = <String, dynamic>{}; // Cuerpo de

    String body = jsonEncode(datos);
    print(body);

    final response =
        await http.post(Uri.parse(urlFinal), headers: headers, body: body);

    final jsonResponse = jsonDecode(response.body);

    try {
      if (jsonResponse['error'] == false) {
        print('Solicitud exitosa');

        setLoadingRegistrarCompra(false);
        setOkPostRegistroCompra(true);
        notifyListeners();
        return okPostRegistroCompra;
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');
        setLoadingRegistrarCompra(false);
        setOkPostRegistroCompra(false);
        notifyListeners();
        return okPostRegistroCompra;
      }
    } catch (e) {
      print('errooorrr $e');
      setLoadingRegistrarCompra(false);
      setOkPostRegistroCompra(false);
      notifyListeners();
      return okPostRegistroCompra;
    }
  }
}
