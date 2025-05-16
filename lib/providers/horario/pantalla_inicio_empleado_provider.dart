import 'package:flutter/material.dart';
import 'package:vet_sotf_app/models/horario/dashboard_model.dart';
import 'package:vet_sotf_app/models/horario/jornada_avance_model.dart';
import 'package:vet_sotf_app/models/horario/proximos_dias_libres_model.dart';
import 'package:vet_sotf_app/providers/horario/services/dashboard_service.dart';

class PantallaInicioEmpleadoProvider with ChangeNotifier {
  DashboardModel? dashboardModel;
  late List<JornadaAvanceModel> horarioAvanceModel = [];
  late List<ProximosDiasLibresModel> proximosDiasLibresModel = [];
  bool isLoadingJornadas = false;

  bool isLoading = false;
  int numeroDeDias = 7;
  String texto = "7 días";
  Map<double, double> asistencias = {};
  Map<double, double> ausencias = {};

  PantallaInicioEmpleadoProvider() {
    getProximosDiasLibres();
    getDashboard();
    getGraficaJornadas(null);
  }

  Future<void> getDashboard() async {
    isLoading = true;
    notifyListeners();
    try {
      DashboardModel dashboardModel = await DashboardService.getGraficaInicio(numeroDeDias);
      asistencias = {};
      for (int i = 0; i < dashboardModel.asistencia.length; i++) {
        asistencias[i.toDouble()] = dashboardModel.asistencia[i].toDouble();
      }
      ausencias = {};
      for (int i = 0; i < dashboardModel.ausencias.length; i++) {
        ausencias[i.toDouble()] = dashboardModel.ausencias[i].toDouble();
      }
      this.dashboardModel = dashboardModel;
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getGraficaJornadas(String? fecha) async {
    isLoadingJornadas = true;
    notifyListeners();
    try {
      fecha ??= DateTime.now().toString().split(" ")[0];
      List<JornadaAvanceModel> horarioAvanceModel = await DashboardService.getGraficaJornadas(fecha);
      this.horarioAvanceModel = horarioAvanceModel;
    } catch (e) {
      print(e);
    }
    isLoadingJornadas = false;
    notifyListeners();
  }

  Future<void> getProximosDiasLibres() async {
    try {
      List<ProximosDiasLibresModel> proximosDiasLibresModel = await DashboardService.getProximosDiasLibres();
      this.proximosDiasLibresModel = proximosDiasLibresModel;
    } catch (e) {
      print(e);
    }
  }

  void setNumeroDeDias(int numeroDeDias) {
    this.numeroDeDias = numeroDeDias;
    getDashboard();
  }
}
