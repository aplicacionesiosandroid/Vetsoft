import 'dart:convert';

class HorarioAvanceModel {
  String nombreCompleto;
  String rol;
  int porcentaje;
  String mensaje;
  String fichaEntrada;
  String fichaSalida;
  String horarioAsignado;

  HorarioAvanceModel({
    required this.nombreCompleto,
    required this.rol,
    required this.porcentaje,
    required this.mensaje,
    required this.fichaEntrada,
    required this.fichaSalida,
    required this.horarioAsignado,
  });

  factory HorarioAvanceModel.fromJson(String str) => HorarioAvanceModel.fromMap(json.decode(str));

  factory HorarioAvanceModel.fromMap(Map<String, dynamic> json) => HorarioAvanceModel(
        nombreCompleto: json["nombre_completo"],
        rol: json["rol"],
        porcentaje: json["porcentaje"],
        mensaje: json["mensaje"],
        fichaEntrada: json["ficha_entrada"],
        fichaSalida: json["ficha_salida"],
        horarioAsignado: json["horario_asignado"],
      );
}
