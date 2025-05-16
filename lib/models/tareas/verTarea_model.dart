// To parse this JSON data, do
//
//     final modelVerTarea = modelVerTareaFromJson(jsonString);

import 'dart:convert';

ModelVerTarea modelVerTareaFromJson(String str) => ModelVerTarea.fromJson(json.decode(str));

String modelVerTareaToJson(ModelVerTarea data) => json.encode(data.toJson());

class ModelVerTarea {
    bool error;
    int code;
    String message;
    Tarea data;

    ModelVerTarea({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelVerTarea.fromJson(Map<String, dynamic> json) => ModelVerTarea(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: Tarea.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": data.toJson(),
    };
}

class Tarea {
    int tareaId;
    String titulo;
    String descripcion;
    String estado;
    dynamic tags;
    DateTime fechaInicio;
    DateTime fechaFin;
    List<Asignado> asignado;
    Subtareas subtareas;

    Tarea({
        required this.tareaId,
        required this.titulo,
        required this.descripcion,
        required this.estado,
        required this.tags,
        required this.fechaInicio,
        required this.fechaFin,
        required this.asignado,
        required this.subtareas,
    });

    factory Tarea.fromJson(Map<String, dynamic> json) => Tarea(
        tareaId: json["tarea_id"],
        titulo: json["titulo"],
        descripcion: json["descripcion"],
        estado: json["estado"],
        tags: json["tags"],
        fechaInicio: DateTime.parse(json["fecha_inicio"]),
        fechaFin: DateTime.parse(json["fecha_fin"]),
        asignado: List<Asignado>.from(json["asignado"].map((x) => Asignado.fromJson(x))),
        subtareas: Subtareas.fromJson(json["subtareas"]),
    );

    Map<String, dynamic> toJson() => {
        "tarea_id": tareaId,
        "titulo": titulo,
        "descripcion": descripcion,
        "estado": estado,
        "tags": tags,
        "fecha_inicio": "${fechaInicio.year.toString().padLeft(4, '0')}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
        "fecha_fin": "${fechaFin.year.toString().padLeft(4, '0')}-${fechaFin.month.toString().padLeft(2, '0')}-${fechaFin.day.toString().padLeft(2, '0')}",
        "asignado": List<dynamic>.from(asignado.map((x) => x.toJson())),
        "subtareas": subtareas.toJson(),
    };
}

class Asignado {
    int userId;
    String nombres;
    String apellidos;

    Asignado({
        required this.userId,
        required this.nombres,
        required this.apellidos,
    });

    factory Asignado.fromJson(Map<String, dynamic> json) => Asignado(
        userId: json["user_id"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "nombres": nombres,
        "apellidos": apellidos,
    };
}

class Subtareas {
    int cantidad;
    int cantidadSubtareasAcabadas;
    List<Subtarea> subtareas;

    Subtareas({
        required this.cantidad,
        required this.cantidadSubtareasAcabadas,
        required this.subtareas,
    });

    factory Subtareas.fromJson(Map<String, dynamic> json) => Subtareas(
        cantidad: json["cantidad"],
        cantidadSubtareasAcabadas: json["cantidad_subtareas_acabadas"],
        subtareas: List<Subtarea>.from(json["subtareas"].map((x) => Subtarea.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "cantidad": cantidad,
        "cantidad_subtareas_acabadas": cantidadSubtareasAcabadas,
        "subtareas": List<dynamic>.from(subtareas.map((x) => x.toJson())),
    };
}

class Subtarea {
    int subtareaId;
    String descripcion;
    DateTime fechaFin;
    String estado;

    Subtarea({
        required this.subtareaId,
        required this.descripcion,
        required this.fechaFin,
        required this.estado,
    });

    factory Subtarea.fromJson(Map<String, dynamic> json) => Subtarea(
        subtareaId: json["subtarea_id"],
        descripcion: json["descripcion"],
        fechaFin: DateTime.parse(json["fechaFin"]),
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "subtarea_id": subtareaId,
        "descripcion": descripcion,
        "fechaFin": "${fechaFin.year.toString().padLeft(4, '0')}-${fechaFin.month.toString().padLeft(2, '0')}-${fechaFin.day.toString().padLeft(2, '0')}",
        "estado": estado,
    };
}
