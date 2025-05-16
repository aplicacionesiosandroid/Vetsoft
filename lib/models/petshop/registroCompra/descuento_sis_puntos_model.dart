// To parse this JSON data, do
//
//     final modelCanjeoSisPuntos = modelCanjeoSisPuntosFromJson(jsonString);

import 'dart:convert';

ModelCanjeoSisPuntos modelCanjeoSisPuntosFromJson(String str) => ModelCanjeoSisPuntos.fromJson(json.decode(str));

String modelCanjeoSisPuntosToJson(ModelCanjeoSisPuntos data) => json.encode(data.toJson());

class ModelCanjeoSisPuntos {
    bool error;
    int code;
    String message;
    Descuentos data;

    ModelCanjeoSisPuntos({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelCanjeoSisPuntos.fromJson(Map<String, dynamic> json) => ModelCanjeoSisPuntos(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: Descuentos.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": data.toJson(),
    };
}

class Descuentos {
    List<dynamic> porcentajeDescuentoCompra;
    List<PorcentajeDescuentoProducto> porcentajeDescuentoProducto;

    Descuentos({
        required this.porcentajeDescuentoCompra,
        required this.porcentajeDescuentoProducto,
    });

    factory Descuentos.fromJson(Map<String, dynamic> json) => Descuentos(
        porcentajeDescuentoCompra: List<dynamic>.from(json["porcentaje_descuento_compra"].map((x) => x)),
        porcentajeDescuentoProducto: List<PorcentajeDescuentoProducto>.from(json["porcentaje_descuento_producto"].map((x) => PorcentajeDescuentoProducto.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "porcentaje_descuento_compra": List<dynamic>.from(porcentajeDescuentoCompra.map((x) => x)),
        "porcentaje_descuento_producto": List<dynamic>.from(porcentajeDescuentoProducto.map((x) => x.toJson())),
    };
}

class PorcentajeDescuentoProducto {
    String productoId;
    int puntos;
    int porcentajeDescuento;

    PorcentajeDescuentoProducto({
        required this.productoId,
        required this.puntos,
        required this.porcentajeDescuento,
    });

    factory PorcentajeDescuentoProducto.fromJson(Map<String, dynamic> json) => PorcentajeDescuentoProducto(
        productoId: json["producto_id"],
        puntos: json["puntos"],
        porcentajeDescuento: json["porcentaje_descuento"],
    );

    Map<String, dynamic> toJson() => {
        "producto_id": productoId,
        "puntos": puntos,
        "porcentaje_descuento": porcentajeDescuento,
    };
}
