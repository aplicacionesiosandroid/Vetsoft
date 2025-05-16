import 'dart:convert';

class AusenciasSolicitadasModel {
  int ausenciaId;
  String nombre;
  String imagen;
  String motivo;
  DateTime fechaInicio;
  DateTime fechaFin;
  int porcentaje;
  String descripcion;

  AusenciasSolicitadasModel({
    required this.ausenciaId,
    required this.nombre,
    required this.imagen,
    required this.motivo,
    required this.fechaInicio,
    required this.fechaFin,
    required this.porcentaje,
    required this.descripcion,
  });

  factory AusenciasSolicitadasModel.fromJson(String str) => AusenciasSolicitadasModel.fromMap(json.decode(str));

  factory AusenciasSolicitadasModel.fromMap(Map<String, dynamic> json) => AusenciasSolicitadasModel(
        ausenciaId: json["ausencia_id"],
        nombre: json["nombre"],
        imagen: json["imagen"],
        motivo: json["motivo"],
        fechaInicio: DateTime.parse(json["fecha_inicio"]),
        fechaFin: DateTime.parse(json["fecha_fin"]),
        porcentaje: json["porcentaje"],
        descripcion: json["descripcion"],
      );
}
