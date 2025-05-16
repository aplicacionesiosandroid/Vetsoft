import 'dart:convert';

class NuevaAusenciaModel {
  int? tipoAusenciaId;
  String nombreAusencia;
  String color;
  List<PreguntasRespuesta> preguntasRespuestas;

  NuevaAusenciaModel({
    this.tipoAusenciaId,
    required this.nombreAusencia,
    required this.color,
    required this.preguntasRespuestas,
  });

  factory NuevaAusenciaModel.fromRawJson(String str) => NuevaAusenciaModel.fromJson(json.decode(str));

  factory NuevaAusenciaModel.fromJson(Map<String, dynamic> json) => NuevaAusenciaModel(
        tipoAusenciaId: json["tipo_ausencia_id"],
        nombreAusencia: json["nombre_ausencia"],
        color: json["color"],
        preguntasRespuestas: List<PreguntasRespuesta>.from(json["preguntas_respuestas"].map((x) => PreguntasRespuesta.fromJson(x))),
      );
}

class PreguntasRespuesta {
  String? pregunta1;
  String? respuesta1;
  String? pregunta2;
  String? respuesta2;
  String? pregunta3;
  String? respuesta3;
  String? pregunta4;
  String? respuesta4;
  String? pregunta5;
  String? respuesta5;
  String? pregunta6;
  String? respuesta6;
  String? pregunta7;
  String? respuesta7;

  PreguntasRespuesta({
    this.pregunta1,
    this.respuesta1,
    this.pregunta2,
    this.respuesta2,
    this.pregunta3,
    this.respuesta3,
    this.pregunta4,
    this.respuesta4,
    this.pregunta5,
    this.respuesta5,
    this.pregunta6,
    this.respuesta6,
    this.pregunta7,
    this.respuesta7,
  });

  factory PreguntasRespuesta.fromRawJson(String str) => PreguntasRespuesta.fromJson(json.decode(str));

  factory PreguntasRespuesta.fromJson(Map<String, dynamic> json) => PreguntasRespuesta(
        pregunta1: json["pregunta1"],
        respuesta1: json["respuesta1"],
        pregunta2: json["pregunta2"],
        respuesta2: json["respuesta2"],
        pregunta3: json["pregunta3"],
        respuesta3: json["respuesta3"],
        pregunta4: json["pregunta4"],
        respuesta4: json["respuesta4"],
        pregunta5: json["pregunta5"],
        respuesta5: json["respuesta5"],
        pregunta6: json["pregunta6"],
        respuesta6: json["respuesta6"],
        pregunta7: json["pregunta7"],
        respuesta7: json["respuesta7"],
      );
}
