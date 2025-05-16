import 'package:flutter/material.dart';

enum FormType {
  register,
  payMethod,
  order,
}

class RegistroModel extends ChangeNotifier {
  FormType _currentForm = FormType.register;
  String _currentTitle = 'Datos del Cliente';

  FormType get currentForm => _currentForm;
  String get currentTitle => _currentTitle;

  // Método para cambiar al siguiente formulario y título
  void goToNextForm() {
    if (_currentForm == FormType.register) {
      _currentForm = FormType.payMethod;
      _currentTitle = 'Método de Pago';
    } else if (_currentForm == FormType.payMethod) {
      _currentForm = FormType.order;
      _currentTitle = 'Entregar Pedido';
    }
    // Notifica a los oyentes (como RegisterClient) que los valores han cambiado
    notifyListeners();
  }

  // Método para retroceder al formulario anterior y título
  void goToPreviousForm() {
    if (_currentForm == FormType.payMethod) {
      _currentForm = FormType.register;
      _currentTitle = 'Datos del Cliente';
    } else if (_currentForm == FormType.order) {
      _currentForm = FormType.payMethod;
      _currentTitle = 'Método de Pago';
    }
    // Notifica a los oyentes (como RegisterClient) que los valores han cambiado
    notifyListeners();
  }

  void iniciaForm() {
    _currentForm = FormType.register;
    notifyListeners();
  }

  void irAlPrimerForm() {
    _currentForm = FormType.register;
  }
}
