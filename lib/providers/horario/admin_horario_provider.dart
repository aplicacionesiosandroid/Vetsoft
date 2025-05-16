import 'package:flutter/material.dart';
import 'package:vet_sotf_app/models/horario/empleado_model.dart';
import 'package:vet_sotf_app/models/horario/horario.dart';
import 'package:vet_sotf_app/models/horario/horario_model.dart';
import 'package:vet_sotf_app/models/horario/horario_update_model.dart';
import 'package:vet_sotf_app/providers/horario/services/admin_gestionar_horario_service.dart';
import 'package:vet_sotf_app/providers/horario/services/admin_horario_service.dart';

class AdminHorarioProvider with ChangeNotifier {
  late List<EmpleadoModel> listaEmpleados = [];
  late List<HorarioModel> listaHorarios = [];
  bool isLoading = false;
  int selectedHorario = 0;
  HorarioUpdateModel? horarioUpdateModel;

  AdminHorarioProvider() {
    getJornadaEmpleados();
    getVerHorarios();
  }
  AdminHorarioProvider.horarioId(int id) {
    getHorarioById(id);
  }

  Future<void> getJornadaEmpleados() async {
    isLoading = true;
    notifyListeners();
    try {
      List<EmpleadoModel> listaEmpleados = await AdminHorarioService.getJornadasEmpleados();
      this.listaEmpleados = listaEmpleados;
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getVerHorarios() async {
    isLoading = true;
    notifyListeners();
    try {
      List<HorarioModel> listaHorarios = await AdminHorarioService.getVerHorarios();
      this.listaHorarios = listaHorarios;
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getArchivoHorarios() async {
    isLoading = true;
    notifyListeners();
    try {
      await AdminGestionarHorarioService.getArchivarHorario(selectedHorario);
      await getVerHorarios();
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteEliminarHorarios() async {
    isLoading = true;
    notifyListeners();
    try {
      await AdminGestionarHorarioService.deleteEliminarHorario(selectedHorario);
      await getVerHorarios();
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  void setSelectHorario(int id) {
    selectedHorario = id;
    notifyListeners();
  }

  Future<void> getHorarioById(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      final horario = await AdminGestionarHorarioService.getHorarioById(id);
      horarioUpdateModel = horario;
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateHorarioFijo(HorarioFijo horarioFijo) async {
    isLoading = true;
    notifyListeners();
    try {
      await AdminGestionarHorarioService.putActualizarHorarioFijo(horarioFijo, horarioUpdateModel!.horarioId);
      await getVerHorarios();
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateHorarioFlexible(HorarioFlexible horarioFlexible) async {
    isLoading = true;
    notifyListeners();
    try {
      await AdminGestionarHorarioService.putActualizarHorarioFlexible(horarioFlexible, horarioUpdateModel!.horarioId);
      await getVerHorarios();
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }
}
