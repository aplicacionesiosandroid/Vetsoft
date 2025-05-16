import 'package:flutter/material.dart';
import 'package:vet_sotf_app/models/horario/dashboard_model.dart';
import 'package:vet_sotf_app/models/horario/jornada_avance_model.dart';
import 'package:vet_sotf_app/models/horario/novedades_model.dart';
import 'package:vet_sotf_app/providers/horario/services/dashboard_service.dart';

class PantallaInicioAdminProvider with ChangeNotifier {
  DashboardModel? dashboardModel;
  late List<NovedadesModel> novedadesModel = [];
  late List<JornadaAvanceModel> horarioAvanceModel = [];
  bool isLoading = false;
  bool isLoadingJornadas = false;
  int numeroDeDias = 7;
  String texto = "7 días";
  Map<double, double> asistencias = {};
  Map<double, double> ausencias = {};

  PantallaInicioAdminProvider() {
    getDashboard();
    getNovedadesSemana();
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

  Future<void> getNovedadesSemana() async {
    isLoading = true;
    notifyListeners();
    try {
      List<NovedadesModel> novedadesModel = await DashboardService.getNovedadesSemana();
      this.novedadesModel = novedadesModel;
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

  void setNumeroDeDias(int numeroDeDias) {
    this.numeroDeDias = numeroDeDias;
    getDashboard();
  }
}
