import 'package:flutter/material.dart';
import 'package:vet_sotf_app/models/horario/admin_tipo_ausencia_model.dart';
import 'package:vet_sotf_app/providers/horario/services/admin_ausencia_service.dart';

class AdminListaAusenciasProvider extends ChangeNotifier {
  late List<AdminTipoAusenciaModel> listaAusenciasAdmin = [];
  bool isLoading = true;

  AdminListaAusenciasProvider() {
    getListaAusenciasAdmin();
  }

  Future<void> getListaAusenciasAdmin() async {
    isLoading = true;
    notifyListeners();
    try {
      List<AdminTipoAusenciaModel> listaAusencias = await AdminAusenciaService.getTiposAusencias();
      listaAusenciasAdmin = listaAusencias;
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }
}
