import 'package:flutter/material.dart';
import 'package:vet_sotf_app/providers/horario/services/admin_evento_service.dart';

class EventoProvider with ChangeNotifier {
  bool isLoading = false;

  Future<void> postCrearEvento(String titulo, String fechaInicio, String fechaFin, String descripcion) async {
    isLoading = true;
    notifyListeners();
    try {
      await AdminEventoService.postCrearEvento(titulo, fechaInicio, fechaFin, descripcion);
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }
}
