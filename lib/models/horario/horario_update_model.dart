import 'dart:convert';

class HorarioUpdateModel {
  int horarioId;
  String tipoHorario;
  DateTime fechaInicio;
  DateTime fechaFin;
  int? lunesHoras;
  int? martesHoras;
  int? miercolesHoras;
  int? juevesHoras;
  int? viernesHoras;
  int? sabadoHoras;
  int? domingoHoras;
  String? lunesInicio;
  String? lunesFin;
  String? martesInicio;
  String? martesFin;
  String? miercolesInicio;
  String? miercolesFin;
  String? juevesInicio;
  String? juevesFin;
  String? viernesInicio;
  String? viernesFin;
  String? sabadoInicio;
  String? sabadoFin;
  String? domingoInicio;
  String? domingoFin;

  HorarioUpdateModel({
    required this.horarioId,
    required this.tipoHorario,
    required this.fechaInicio,
    required this.fechaFin,
    this.lunesHoras,
    this.martesHoras,
    this.miercolesHoras,
    this.juevesHoras,
    this.viernesHoras,
    this.sabadoHoras,
    this.domingoHoras,
    this.lunesInicio,
    this.lunesFin,
    this.martesInicio,
    this.martesFin,
    this.miercolesInicio,
    this.miercolesFin,
    this.juevesInicio,
    this.juevesFin,
    this.viernesInicio,
    this.viernesFin,
    this.sabadoInicio,
    this.sabadoFin,
    this.domingoInicio,
    this.domingoFin,
  });

  factory HorarioUpdateModel.fromJson(String str) => HorarioUpdateModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HorarioUpdateModel.fromMap(Map<String, dynamic> json) => HorarioUpdateModel(
        horarioId: json["horario_id"],
        tipoHorario: json["tipo_horario"],
        fechaInicio: DateTime.parse(json["fecha_inicio"]),
        fechaFin: DateTime.parse(json["fecha_fin"]),
        lunesHoras: json["lunes_horas"],
        martesHoras: json["martes_horas"],
        miercolesHoras: json["miercoles_horas"],
        juevesHoras: json["jueves_horas"],
        viernesHoras: json["viernes_horas"],
        sabadoHoras: json["sabado_horas"],
        domingoHoras: json["domingo_horas"],
        lunesInicio: json["lunes_inicio"],
        lunesFin: json["lunes_fin"],
        martesInicio: json["martes_inicio"],
        martesFin: json["martes_fin"],
        miercolesInicio: json["miercoles_inicio"],
        miercolesFin: json["miercoles_fin"],
        juevesInicio: json["jueves_inicio"],
        juevesFin: json["jueves_fin"],
        viernesInicio: json["viernes_inicio"],
        viernesFin: json["viernes_fin"],
        sabadoInicio: json["sabado_inicio"],
        sabadoFin: json["sabado_fin"],
        domingoInicio: json["domingo_inicio"],
        domingoFin: json["domingo_fin"],
      );

  Map<String, dynamic> toMap() => {
        "horario_id": horarioId,
        "tipo_horario": tipoHorario,
        "fecha_inicio":
            "${fechaInicio.year.toString().padLeft(4, '0')}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
        "fecha_fin":
            "${fechaFin.year.toString().padLeft(4, '0')}-${fechaFin.month.toString().padLeft(2, '0')}-${fechaFin.day.toString().padLeft(2, '0')}",
        "lunes_horas": lunesHoras,
        "martes_horas": martesHoras,
        "miercoles_horas": miercolesHoras,
        "jueves_horas": juevesHoras,
        "viernes_horas": viernesHoras,
        "sabado_horas": sabadoHoras,
        "domingo_horas": domingoHoras,
        "lunes_inicio": lunesInicio,
        "lunes_fin": lunesFin,
        "martes_inicio": martesInicio,
        "martes_fin": martesFin,
        "miercoles_inicio": miercolesInicio,
        "miercoles_fin": miercolesFin,
        "jueves_inicio": juevesInicio,
        "jueves_fin": juevesFin,
        "viernes_inicio": viernesInicio,
        "viernes_fin": viernesFin,
        "sabado_inicio": sabadoInicio,
        "sabado_fin": sabadoFin,
        "domingo_inicio": domingoInicio,
        "domingo_fin": domingoFin,
      };
}
