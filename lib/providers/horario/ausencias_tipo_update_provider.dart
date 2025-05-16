// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vet_sotf_app/providers/horario/services/admin_ausencia_service.dart';

class AusenciasTipoUpdateProvider with ChangeNotifier {
  String selectedOption1 = 'Seleccionar...';
  String selectedOption2 = 'Seleccionar...';
  String selectedOption3 = 'Seleccionar...';
  String selectedOption4 = 'Seleccionar...';
  String selectedOption5 = 'Seleccionar...';
  Color selectedColor = Colors.white;
  String nombreAusencia = '';
  String solicitudMinima = '';
  String maximoSolicitudes = '';
  bool isLoading = false;
  int ausenciaId = 0;

  String get getSelectedOption1 => selectedOption1;
  String get getSelectedOption2 => selectedOption2;
  String get getSelectedOption3 => selectedOption3;
  String get getSelectedOption4 => selectedOption4;
  String get getSelectedOption5 => selectedOption5;
  Color? get getSelectedColor => selectedColor;

  AusenciasTipoUpdateProvider(int ausenciaId) {
    getAusenciaById(ausenciaId);
  }

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
    selectedColor = color;
    notifyListeners();
  }

  Future<void> getAusenciaById(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      final ausencia = await AdminAusenciaService.getTipoAusenciaById(id);
      selectedOption1 = (ausencia.preguntasRespuestas.split('respuesta1')[1].substring(3, 5).toLowerCase() == 'si')
          ? 'Si, descuenta tiempo.'
          : 'No, no descuenta tiempo.';
      selectedOption2 = (ausencia.preguntasRespuestas.split('respuesta2')[1].substring(3, 5).toLowerCase() == 'si')
          ? 'Si, requiere ser aprobado.'
          : 'No, se aprobará automáticamente.';
      selectedOption3 =
          (ausencia.preguntasRespuestas.split('respuesta3')[1].substring(3, 5).toLowerCase() == 'si') ? 'Si, lo permite.' : 'No, no lo permite.';
      selectedOption4 =
          (ausencia.preguntasRespuestas.split('respuesta4')[1].substring(3, 5).toLowerCase() == 'si') ? 'Si, es visible.' : 'No, no es visible.';
      selectedOption5 = (ausencia.preguntasRespuestas.split('respuesta5')[1].substring(3, 5).toLowerCase() == 'si')
          ? 'Si, durante la ausencia se cuenta que el empleado está trabajando.'
          : 'No, durante la ausencia no se cuenta que el empleado está trabajando.';
      solicitudMinima = ausencia.preguntasRespuestas
          .split('respuesta6')[1]
          .split('pregunta7')[0]
          .substring(3, ausencia.preguntasRespuestas.split('respuesta6')[1].split('pregunta7')[0].length - 5);
      maximoSolicitudes =
          ausencia.preguntasRespuestas.split('respuesta7')[1].substring(3, ausencia.preguntasRespuestas.split('respuesta7')[1].length - 3);
      nombreAusencia = ausencia.nombreAusencia;
      ausenciaId = ausencia.tipoAusenciaId;
      selectedColor = Color(int.parse(ausencia.color.replaceAll('#', '0xFF')));
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateAusencia(String nombreAusencia, String solicitudMinima, String maximoSolicitudes, String colorHex) async {
    isLoading = true;
    notifyListeners();
    try {
      await AdminAusenciaService.putTipoAusencia(ausenciaId, nombreAusencia, colorHex, [
        selectedOption1,
        selectedOption2,
        selectedOption3,
        selectedOption4,
        selectedOption5,
        solicitudMinima,
        maximoSolicitudes,
      ]);
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }
}
