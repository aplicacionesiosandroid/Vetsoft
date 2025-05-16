import 'package:flutter/material.dart';
import 'package:vet_sotf_app/models/horario/horario_avance_model.dart';
import 'package:vet_sotf_app/providers/horario/services/admin_horario_service.dart';
import 'package:vet_sotf_app/providers/horario/services/empleado_fichaje_service.dart';

class EmpleadoFichajeProvider with ChangeNotifier {
  late HorarioAvanceModel horarioAvanceModel;
  String codigo = '';
  bool isExpanded = false;
  bool isLoading = false;

  EmpleadoFichajeProvider() {
    getVerAvanceHorarios();
  }

  Future<void> getFicharEntrada() async {
    isLoading = true;
    notifyListeners();
    try {
      await EmpleadoFichajeService.getFicharEntrada(codigo);
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getFicharSalida() async {
    isLoading = true;
    notifyListeners();
    try {
      await EmpleadoFichajeService.getFicharSalida(codigo);
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getVerAvanceHorarios() async {
    isLoading = true;
    notifyListeners();
    try {
      DateTime now = DateTime.now();
      String fecha = '${now.year}-${now.month}-${now.day}';
      List<HorarioAvanceModel> horarioAvanceModels = await AdminHorarioService.getVerAvanceHorarios(fecha);
      horarioAvanceModel = horarioAvanceModels.first;
    } catch (e) {
      horarioAvanceModel = HorarioAvanceModel(
        nombreCompleto: '',
        rol: '',
        porcentaje: 0,
        mensaje: '',
        fichaEntrada: '',
        fichaSalida: '',
        horarioAsignado: '',
      );
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  setCodigo(String value) {
    codigo = value;
  }

  switchIsExpanded() {
    isExpanded = !isExpanded;
    notifyListeners();
  }
}
