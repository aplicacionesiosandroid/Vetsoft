// import 'dart:io';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vet_sotf_app/models/horario/empleado_tipo_ausencia_model.dart';
import 'package:vet_sotf_app/providers/horario/services/empleado_ausencia_service.dart';

class EmpleadoAusenciasNuevoProvider extends ChangeNotifier {
  late List<EmpleadoTipoAusenciaModel> listaTipoAusencias = [
    EmpleadoTipoAusenciaModel(tipoAusenciaId: 0, nombreAusencia: 'Seleccionar', documento: false),
  ];
  bool isLoading = true;
  int selectedTipoAusencia = 0;
  int selectedDaysHalfDays = 1;
  bool isDocumentSelected = false;
  bool isDocumentUploading = false;
  File? documento;

  EmpleadoAusenciasNuevoProvider() {
    getListaTipoAusencias();
  }

  Future<void> getListaTipoAusencias() async {
    isLoading = true;
    notifyListeners();
    try {
      List<EmpleadoTipoAusenciaModel> listaTipoAusencias = await EmpleadoAusenciaService.getTipoAusenciasEmpleado();

      this.listaTipoAusencias = [
        this.listaTipoAusencias[0],
        ...listaTipoAusencias,
      ];
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> postAgregarAusenciaEmpleado(String descripcion, String desde, String hasta) async {
    // isLoading = true;
    notifyListeners();
    String tipo = selectedDaysHalfDays == 1 ? 'dia' : 'medio_dia';
    // Format the date to yyyy-mm-dd
    desde = desde.split('/').reversed.join('-');
    hasta = hasta.split('/').reversed.join('-');
    try {
      await EmpleadoAusenciaService.postAgregarAusenciaEmpleado(selectedTipoAusencia, descripcion, tipo, desde, hasta, documento);
    } catch (e) {
      print(e);
    }
    // isLoading = false;
    notifyListeners();
  }

  void setSelectedTipoAusencia(int value) {
    selectedTipoAusencia = value;
    isDocumentUploading = (listaTipoAusencias.firstWhere((element) => element.tipoAusenciaId == value).documento == true) ? true : false;
    notifyListeners();
  }

  void setSelectedDaysHalfDays(int value) {
    selectedDaysHalfDays = value;
    notifyListeners();
  }

  void setDocumento(File? value) {
    documento = value;
    notifyListeners();
  }

  void reset() {
    selectedTipoAusencia = 0;
    selectedDaysHalfDays = 1;
    notifyListeners();
  }
}
