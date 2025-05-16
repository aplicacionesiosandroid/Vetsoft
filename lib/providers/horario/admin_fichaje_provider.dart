import 'package:flutter/material.dart';
import 'package:vet_sotf_app/models/horario/horario_avance_model.dart';
import 'package:vet_sotf_app/providers/horario/services/admin_horario_service.dart';

class AdminFichajeProvider with ChangeNotifier {
  late List<HorarioAvanceModel> horarioAvanceModel = [];
  List<bool> isExpandedList = [];
  bool isLoading = false;
  String codigo = '';

  AdminFichajeProvider() {
    getVerAvanceHorarios();
  }

  Future<void> getVerAvanceHorarios() async {
    isLoading = true;
    notifyListeners();
    try {
      DateTime now = DateTime.now();
      String fecha = '${now.year}-${now.month}-${now.day}';
      List<HorarioAvanceModel> horarioAvanceModels = await AdminHorarioService.getVerAvanceHorarios(fecha);
      isExpandedList = List.generate(horarioAvanceModels.length, (index) => false);
      horarioAvanceModel = horarioAvanceModels;
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  setCodigo(String value) {
    codigo = value;
  }

  switchIsExpanded(int index) {
    isExpandedList[index] = !isExpandedList[index];
    notifyListeners();
  }
}
