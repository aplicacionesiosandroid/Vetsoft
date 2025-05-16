// To parse this JSON data, do
//
//     final modelEtiquuetasTareas = modelEtiquuetasTareasFromJson(jsonString);

import 'dart:convert';

ModelEtiquetasTareas modelEtiquetasTareasFromJson(String str) => ModelEtiquetasTareas.fromJson(json.decode(str));

String modelEtiquetasTareasToJson(ModelEtiquetasTareas data) => json.encode(data.toJson());

class ModelEtiquetasTareas {
    bool error;
    int code;
    String message;
    List<EtiquetaTarea> data;

    ModelEtiquetasTareas({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelEtiquetasTareas.fromJson(Map<String, dynamic> json) => ModelEtiquetasTareas(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<EtiquetaTarea>.from(json["data"].map((x) => EtiquetaTarea.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class EtiquetaTarea {
    int etiquetaId;
    String nombre;
    String estado;

    EtiquetaTarea({
        required this.etiquetaId,
        required this.nombre,
        required this.estado,
    });

    factory EtiquetaTarea.fromJson(Map<String, dynamic> json) => EtiquetaTarea(
        etiquetaId: json["etiqueta_id"],
        nombre: json["nombre"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "etiqueta_id": etiquetaId,
        "nombre": nombre,
        "estado": estado,
    };
}
