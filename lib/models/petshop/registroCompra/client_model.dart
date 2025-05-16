import 'package:flutter/material.dart';

class RegistroClienteModel extends ChangeNotifier {
  bool registrarCliente = false;
  String nitCi = '';
  String nombre = '';
  String apellido = '';
  String numeroCelular = '';
  bool facturacion = false;

  get currentForm => null;

  // Métodos para actualizar los datos del modelo
  void toggleRegistrarCliente() {
    registrarCliente = !registrarCliente;
    notifyListeners();
  }

  void setNitCi(String value) {
    nitCi = value;
    notifyListeners();
  }

  void setNombre(String value) {
    nombre = value;
    notifyListeners();
  }

  void setApellido(String value) {
    apellido = value;
    notifyListeners();
  }

  void setNumeroCelular(String value) {
    numeroCelular = value;
    notifyListeners();
  }

  void toggleFacturacion() {
    facturacion = !facturacion;
    notifyListeners();
  }
}
