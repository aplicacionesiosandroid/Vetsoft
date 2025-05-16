// To parse this JSON data, do
//
//     final modelProveedores = modelProveedoresFromJson(jsonString);

import 'dart:convert';

ModelProveedores modelProveedoresFromJson(String str) => ModelProveedores.fromJson(json.decode(str));

String modelProveedoresToJson(ModelProveedores data) => json.encode(data.toJson());

class ModelProveedores {
    bool error;
    int code;
    String message;
    List<Proveedor> data;

    ModelProveedores({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelProveedores.fromJson(Map<String, dynamic> json) => ModelProveedores(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<Proveedor>.from(json["data"].map((x) => Proveedor.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Proveedor {
    int provedorId;
    String nombreProvedor;

    Proveedor({
        required this.provedorId,
        required this.nombreProvedor,
    });

    factory Proveedor.fromJson(Map<String, dynamic> json) => Proveedor(
        provedorId: json["provedor_id"],
        nombreProvedor: json["nombre_provedor"],
    );

    Map<String, dynamic> toJson() => {
        "provedor_id": provedorId,
        "nombre_provedor": nombreProvedor,
    };
}
