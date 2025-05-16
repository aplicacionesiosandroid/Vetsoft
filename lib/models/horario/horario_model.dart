import 'dart:convert';

class HorarioModel {
  int horarioId;
  String nombreHorario;
  String tipoHorario;

  HorarioModel({
    required this.horarioId,
    required this.nombreHorario,
    required this.tipoHorario,
  });

  factory HorarioModel.fromJson(String str) => HorarioModel.fromMap(json.decode(str));

  factory HorarioModel.fromMap(Map<String, dynamic> json) => HorarioModel(
        horarioId: json["horario_id"],
        nombreHorario: json["nombre_horario"],
        tipoHorario: json["tipo_horario"],
      );
}
