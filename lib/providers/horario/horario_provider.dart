import 'package:flutter/material.dart';
import 'package:vet_sotf_app/models/horario/empleado_model.dart';
import 'package:vet_sotf_app/models/horario/horario.dart';
import 'package:vet_sotf_app/providers/horario/services/admin_gestionar_horario_service.dart';
import 'package:vet_sotf_app/providers/horario/services/admin_horario_service.dart';

class HorarioProvider with ChangeNotifier {
  bool isLoading = false;
  late List<EmpleadoModel> listaEmpleados = [];
  late List<Map<String, dynamic>> users = [];

  Future<void> postCrearHorarioFijo(HorarioFijo horarioFijo) async {
    isLoading = true;
    notifyListeners();
    try {
      await AdminGestionarHorarioService.postCrearHorarioFijo(horarioFijo);
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> postCrearHorarioFlexible(HorarioFlexible horarioFlexible) async {
    isLoading = true;
    notifyListeners();
    try {
      await AdminGestionarHorarioService.postCrearHorarioFlexible(horarioFlexible);
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> postEmpleadoAsignarHorario(Jornada jornada) async {
    isLoading = true;
    notifyListeners();
    try {
      await AdminHorarioService.postAsignarJornada(jornada);
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateHorarioFijo(HorarioFijo horarioFijo, int horarioId) async {
    isLoading = true;
    notifyListeners();
    try {
      await AdminGestionarHorarioService.putActualizarHorarioFijo(horarioFijo, horarioId);
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateHorarioFlexible(HorarioFlexible horarioFlexible, int horarioId) async {
    isLoading = true;
    notifyListeners();
    try {
      await AdminGestionarHorarioService.putActualizarHorarioFlexible(horarioFlexible, horarioId);
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }
}
