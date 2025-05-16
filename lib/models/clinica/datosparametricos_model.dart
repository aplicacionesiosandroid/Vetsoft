import 'dart:convert';

ModelDatosParametrizados modelDatosParametrizadosFromJson(String str) =>
    ModelDatosParametrizados.fromJson(json.decode(str));

String modelDatosParametrizadosToJson(ModelDatosParametrizados data) =>
    json.encode(data.toJson());

class ModelDatosParametrizados {
  bool error;
  int code;
  String message;
  List<DatosParametricos> data;

  ModelDatosParametrizados({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ModelDatosParametrizados.fromJson(Map<String, dynamic> json) =>
      ModelDatosParametrizados(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<DatosParametricos>.from(
            json["data"].map((x) => DatosParametricos.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DatosParametricos {
  int parametricaId;
  String parametrica;
  List<Pregunta> preguntas;
  bool selected;

  DatosParametricos({
    required this.parametricaId,
    required this.parametrica,
    required this.preguntas,
    this.selected = false,
  });

  factory DatosParametricos.fromJson(Map<String, dynamic> json) =>
      DatosParametricos(
        parametricaId: json["parametrica_id"],
        parametrica: json["parametrica"],
        preguntas: List<Pregunta>.from(
            json["preguntas"].map((x) => Pregunta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "parametrica_id": parametricaId,
        "parametrica": parametrica,
        "preguntas": List<dynamic>.from(preguntas.map((x) => x.toJson())),
      };
}

class Pregunta {
  int preguntaId;
  String pregunta;
  List<Opciones> opciones;

  Pregunta({
    required this.preguntaId,
    required this.pregunta,
    required this.opciones,
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) => Pregunta(
        preguntaId: json["pregunta_id"],
        pregunta: json["pregunta"],
        opciones: List<Opciones>.from(
            json["opciones"].map((x) => Opciones.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pregunta_id": preguntaId,
        "pregunta": pregunta,
        "opciones": List<dynamic>.from(opciones.map((x) => x.toJson())),
      };
}

class Opciones {
  int opcionId;
  Tipo? tipo;
  String? opcion;

  Opciones({
    required this.opcionId,
    required this.tipo,
    required this.opcion,
  });

  factory Opciones.fromJson(Map<String, dynamic> json) => Opciones(
        opcionId: json["opcion_id"],
        tipo: tipoValues.map[json["tipo"]],
        opcion: json["opcion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "opcion_id": opcionId,
        "tipo": tipoValues.reverse[tipo],
        "opcion": opcionValues.reverse[opcion],
      };
}

enum Opcion { EMPTY, NO, SI }

final opcionValues = EnumValues({
  "": Opcion.EMPTY,
});

enum Tipo { OPCION, TEXTO }

final tipoValues = EnumValues({"OPCION": Tipo.OPCION, "TEXTO": Tipo.TEXTO});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
