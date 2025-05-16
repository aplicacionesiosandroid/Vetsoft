import 'package:flutter/material.dart';
import 'package:vet_sotf_app/models/horario/ausencias_solicitadas_model.dart';
import 'package:vet_sotf_app/providers/horario/services/admin_ausencia_service.dart';

class AdminSolicitudAusenciasProvider extends ChangeNotifier {
  late List<AusenciasSolicitadasModel> listaAusenciasSolicitadas = [];
  AusenciasSolicitadasModel? ausenciaSeleccionada;
  bool isLoading = true;

  AdminSolicitudAusenciasProvider() {
    getListaAusenciasSolicitadas();
  }

  Future<void> getListaAusenciasSolicitadas() async {
    isLoading = true;
    notifyListeners();
    try {
      List<AusenciasSolicitadasModel> listaAusencias = await AdminAusenciaService.getAusenciasPendientes();
      listaAusenciasSolicitadas = listaAusencias;
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getAprobarAusencia(int ausenciaId) async {
    isLoading = true;
    notifyListeners();
    try {
      await AdminAusenciaService.getAprobarAusencia(ausenciaId);
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  void setAusenciaSeleccionada(int ausenciaId) {
    ausenciaSeleccionada = listaAusenciasSolicitadas.firstWhere((element) => element.ausenciaId == ausenciaId);
    notifyListeners();
  }
}
