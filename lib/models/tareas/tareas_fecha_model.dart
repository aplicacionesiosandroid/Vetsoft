// To parse this JSON data, do
//
//     final modelTareasFecha = modelTareasFechaFromJson(jsonString);

import 'dart:convert';

ModelTareasFecha modelTareasFechaFromJson(String str) => ModelTareasFecha.fromJson(json.decode(str));

String modelTareasFechaToJson(ModelTareasFecha data) => json.encode(data.toJson());

class ModelTareasFecha {
    bool error;
    int code;
    String message;
    List<Tareafecha> data;

    ModelTareasFecha({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelTareasFecha.fromJson(Map<String, dynamic> json) => ModelTareasFecha(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<Tareafecha>.from(json["data"].map((x) => Tareafecha.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Tareafecha {
    int tareaId;
    String titulo;
    String estado;
    DateTime fechaInicio;
    DateTime fechaFin;

    Tareafecha({
        required this.tareaId,
        required this.titulo,
        required this.estado,
        required this.fechaInicio,
        required this.fechaFin,
    });

    factory Tareafecha.fromJson(Map<String, dynamic> json) => Tareafecha(
        tareaId: json["tarea_id"],
        titulo: json["titulo"],
        estado: json["estado"],
        fechaInicio: DateTime.parse(json["fecha_inicio"]),
        fechaFin: DateTime.parse(json["fecha_fin"]),
    );

    Map<String, dynamic> toJson() => {
        "tarea_id": tareaId,
        "titulo": titulo,
        "estado": estado,
        "fecha_inicio": "${fechaInicio.year.toString().padLeft(4, '0')}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
        "fecha_fin": "${fechaFin.year.toString().padLeft(4, '0')}-${fechaFin.month.toString().padLeft(2, '0')}-${fechaFin.day.toString().padLeft(2, '0')}",
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
