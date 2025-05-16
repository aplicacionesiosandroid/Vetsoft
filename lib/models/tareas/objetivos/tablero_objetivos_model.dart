// To parse this JSON data, do
//
//     final modelTableroObjetivos = modelTableroObjetivosFromJson(jsonString);

import 'dart:convert';

ModelTableroObjetivos modelTableroObjetivosFromJson(String str) =>
    ModelTableroObjetivos.fromJson(json.decode(str));

String modelTableroObjetivosToJson(ModelTableroObjetivos data) =>
    json.encode(data.toJson());

class ModelTableroObjetivos {
  bool error;
  int code;
  String message;
  List<Objetivos> data;

  ModelTableroObjetivos({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ModelTableroObjetivos.fromJson(Map<String, dynamic> json) =>
      ModelTableroObjetivos(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<Objetivos>.from(json["data"].map((x) => Objetivos.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Objetivos {
  int objetivoId;
  String titulo;
  String estado;
  String descripcion;
  DateTime fechaInicio;
  DateTime fechaFin;
  Medicion medicion;
  List<Participante> participantes;

  Objetivos({
    required this.objetivoId,
    required this.titulo,
    required this.estado,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFin,
    required this.medicion,
    required this.participantes,
  });

  factory Objetivos.fromJson(Map<String, dynamic> json) => Objetivos(
        objetivoId: json["objetivo_id"],
        titulo: json["titulo"],
        estado: json["estado"],
        descripcion: json["descripcion"],
        fechaInicio: DateTime.parse(json["fecha_inicio"]),
        fechaFin: DateTime.parse(json["fecha_fin"]),
        medicion: Medicion.fromJson(json["medicion"]),
        participantes: List<Participante>.from(
            json["participantes"].map((x) => Participante.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "objetivo_id": objetivoId,
        "titulo": titulo,
        "estado": estado,
        "descripcion": descripcion,
        "fecha_inicio":
            "${fechaInicio.year.toString().padLeft(4, '0')}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
        "fecha_fin":
            "${fechaFin.year.toString().padLeft(4, '0')}-${fechaFin.month.toString().padLeft(2, '0')}-${fechaFin.day.toString().padLeft(2, '0')}",
        "medicion": medicion.toJson(),
        "participantes":
            List<dynamic>.from(participantes.map((x) => x.toJson())),
      };
}

class Medicion {
    TipoMedicion tipoMedicion;
    int? cantidadTareas;
    int? cantidadTareasAcabadas;
    int? objetivo;
    int? actual;

    Medicion({
        required this.tipoMedicion,
        this.cantidadTareas,
        this.cantidadTareasAcabadas,
        this.objetivo,
        this.actual,
    });

    factory Medicion.fromJson(Map<String, dynamic> json) => Medicion(
        tipoMedicion: tipoMedicionValues.map[json["tipo_medicion"]]!,
        cantidadTareas: json["cantidad_tareas"],
        cantidadTareasAcabadas: json["cantidad_tareas_acabadas"],
        objetivo: json["objetivo"],
        actual: json["actual"],
    );

    Map<String, dynamic> toJson() => {
        "tipo_medicion": tipoMedicionValues.reverse[tipoMedicion],
        "cantidad_tareas": cantidadTareas,
        "cantidad_tareas_acabadas": cantidadTareasAcabadas,
        "objetivo": objetivo,
        "actual": actual,
    };
}

enum TipoMedicion {
    NINGUNA,
    NUMERICO,
    TAREAS
}

final tipoMedicionValues = EnumValues({
    "ninguna": TipoMedicion.NINGUNA,
    "numerico": TipoMedicion.NUMERICO,
    "TAREAS": TipoMedicion.TAREAS
});

class Participante {
  int userId;
  String nombres;
  String apellidos;
  String imagenUser;

  Participante({
    required this.userId,
    required this.nombres,
    required this.apellidos,
    required this.imagenUser,
  });

  factory Participante.fromJson(Map<String, dynamic> json) => Participante(
        userId: json["user_id"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        imagenUser: json["imagen_user"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "nombres": nombres,
        "apellidos": apellidos,
        "imagen_user": imagenUser,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
