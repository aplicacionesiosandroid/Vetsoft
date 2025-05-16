import 'package:flutter/material.dart';
import 'package:vet_sotf_app/models/horario/lista_ausencias_model.dart';
import 'package:vet_sotf_app/providers/horario/services/empleado_ausencia_service.dart';

class EmpleadoListaAusenciasProvider extends ChangeNotifier {
  late ListaAusenciasModel listaAusencias;
  bool isLoading = true;

  EmpleadoListaAusenciasProvider() {
    getListaAusenciasEmpleado();
  }

  Future<void> getListaAusenciasEmpleado() async {
    isLoading = true;
    notifyListeners();
    try {
      ListaAusenciasModel listaAusencias = await EmpleadoAusenciaService.getAusenciasVistaEmpleado();
      this.listaAusencias = listaAusencias;
    } catch (e) {
      listaAusencias = ListaAusenciasModel(
        proximasAusencias: [],
        ausenciasPasadas: [],
        ausenciasRevision: [],
        ausenciasRechazadas: [],
      );

      print(e);
    }
    isLoading = false;
    notifyListeners();
  }
}
