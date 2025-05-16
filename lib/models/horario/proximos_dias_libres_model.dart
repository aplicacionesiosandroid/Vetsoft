import 'dart:convert';

class ProximosDiasLibresModel {
  String titulo;
  String motivo;
  String fecha;

  ProximosDiasLibresModel({
    required this.titulo,
    required this.motivo,
    required this.fecha,
  });

  factory ProximosDiasLibresModel.fromJson(String str) => ProximosDiasLibresModel.fromMap(json.decode(str));

  factory ProximosDiasLibresModel.fromMap(Map<String, dynamic> json) => ProximosDiasLibresModel(
        titulo: json["titulo"],
        motivo: json["motivo"],
        fecha: json["fecha"],
      );
}
