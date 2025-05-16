import 'package:flutter/material.dart';
import 'package:vet_sotf_app/providers/horario/services/admin_ausencia_service.dart';

class AusenciasNuevoTipoProvider with ChangeNotifier {
  String selectedOption1 = 'Seleccionar...';
  String selectedOption2 = 'Seleccionar...';
  String selectedOption3 = 'Seleccionar...';
  String selectedOption4 = 'Seleccionar...';
  String selectedOption5 = 'Seleccionar...';
  Color? _selectedColor;
  bool isLoading = false;

  String get getSelectedOption1 => selectedOption1;
  String get getSelectedOption2 => selectedOption2;
  String get getSelectedOption3 => selectedOption3;
  String get getSelectedOption4 => selectedOption4;
  String get getSelectedOption5 => selectedOption5;
  Color? get getSelectedColor => _selectedColor;

  void setSelectedOption1(String newValue) {
    selectedOption1 = newValue;
    notifyListeners();
  }

  void setSelectedOption2(String newValue) {
    selectedOption2 = newValue;
    notifyListeners();
  }

  void setSelectedOption3(String newValue) {
    selectedOption3 = newValue;
    notifyListeners();
  }

  void setSelectedOption4(String newValue) {
    selectedOption4 = newValue;
    notifyListeners();
  }

  void setSelectedOption5(String newValue) {
    selectedOption5 = newValue;
    notifyListeners();
  }

  void setSelectedColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  Future<void> postCrearAusencia(String nombreAusencia, String solicitudMinima, String maximoSolicitudes, String colorHex) async {
    isLoading = true;
    notifyListeners();
    try {
      //color to string
      await AdminAusenciaService.postCrearTipoAusencia(nombreAusencia, colorHex,
          [selectedOption1, selectedOption2, selectedOption3, selectedOption4, selectedOption5, solicitudMinima, maximoSolicitudes]);
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }
}
