import 'dart:convert';

class AusenciaUpdateModel {
  int tipoAusenciaId;
  String nombreAusencia;
  String color;
  String preguntasRespuestas;

  AusenciaUpdateModel({
    required this.tipoAusenciaId,
    required this.nombreAusencia,
    required this.color,
    required this.preguntasRespuestas,
  });

  factory AusenciaUpdateModel.fromJson(String str) => AusenciaUpdateModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AusenciaUpdateModel.fromMap(Map<String, dynamic> json) => AusenciaUpdateModel(
        tipoAusenciaId: json["tipo_ausencia_id"],
        nombreAusencia: json["nombre_ausencia"],
        color: json["color"],
        preguntasRespuestas: json["preguntas_respuestas"],
      );

  Map<String, dynamic> toMap() => {
        "tipo_ausencia_id": tipoAusenciaId,
        "nombre_ausencia": nombreAusencia,
        "color": color,
        "preguntas_respuestas": preguntasRespuestas,
      };
}
