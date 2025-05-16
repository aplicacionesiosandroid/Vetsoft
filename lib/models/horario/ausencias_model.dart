import 'dart:convert';

class AusenciasModel {
  int ausenciaId;
  String fechaInicio;
  String fechaFin;
  String nombreAusencia;
  String estado;

  AusenciasModel({
    required this.ausenciaId,
    required this.fechaInicio,
    required this.fechaFin,
    required this.nombreAusencia,
    required this.estado,
  });

  factory AusenciasModel.fromJson(String str) => AusenciasModel.fromMap(json.decode(str));

  factory AusenciasModel.fromMap(Map<String, dynamic> json) => AusenciasModel(
        ausenciaId: json["ausencia_id"],
        fechaInicio: json["fecha_inicio"],
        fechaFin: json["fecha_fin"],
        nombreAusencia: json["nombre_ausencia"],
        estado: json["estado"],
      );
}
