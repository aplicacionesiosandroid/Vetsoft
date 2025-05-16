// To parse this JSON data, do
//
//     final modelProductosmasVendidos = modelProductosmasVendidosFromJson(jsonString);

import 'dart:convert';

ModelProductosmasVendidos modelProductosmasVendidosFromJson(String str) => ModelProductosmasVendidos.fromJson(json.decode(str));

String modelProductosmasVendidosToJson(ModelProductosmasVendidos data) => json.encode(data.toJson());

class ModelProductosmasVendidos {
    bool error;
    int code;
    String message;
    List<ProductoMasVendido> data;

    ModelProductosmasVendidos({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelProductosmasVendidos.fromJson(Map<String, dynamic> json) => ModelProductosmasVendidos(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        // data: List<ProductoMasVendido>.from(json["data"].map((x) => List<ProductoMasVendido>.from(x.map((x) => ProductoMasVendido.fromJson(x))))),
        data: List<ProductoMasVendido>.from(json['data'].map((x) => ProductoMasVendido.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ProductoMasVendido {
    int productoId;
    String nombreProducto;
    String nombreMarca;
    double costoProducto;
    int precioVentaProducto;
    String productoDetalle;
    DateTime? fechaVencimiento;
    int cantidadDisponible;
    String stockEstado;
    String nombreUnidad;
    String unidadAbreviatura;
    List<String> imagenes;

    ProductoMasVendido({
        required this.productoId,
        required this.nombreProducto,
        required this.nombreMarca,
        required this.costoProducto,
        required this.precioVentaProducto,
        required this.productoDetalle,
        required this.fechaVencimiento,
        required this.cantidadDisponible,
        required this.stockEstado,
        required this.nombreUnidad,
        required this.unidadAbreviatura,
        required this.imagenes,
    });

    factory ProductoMasVendido.fromJson(Map<String, dynamic> json) => ProductoMasVendido(
        productoId: json["producto_id"],
        nombreProducto: json["nombre_producto"],
        nombreMarca: json["nombre_marca"],
        costoProducto: json["costo_producto"]?.toDouble(),
        precioVentaProducto: json["precio_venta_producto"],
        productoDetalle: json["producto_detalle"],
        fechaVencimiento: json["fecha_vencimiento"] == null ? null : DateTime.parse(json["fecha_vencimiento"]),
        cantidadDisponible: json["cantidad_disponible"],
        stockEstado: json["stock_estado"],
        nombreUnidad: json["nombre_unidad"],
        unidadAbreviatura: json["unidad_abreviatura"],
        imagenes: List<String>.from(json["imagenes"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "producto_id": productoId,
        "nombre_producto": nombreProducto,
        "nombre_marca": nombreMarca,
        "costo_producto": costoProducto,
        "precio_venta_producto": precioVentaProducto,
        "producto_detalle": productoDetalle,
        "fecha_vencimiento": "${fechaVencimiento!.year.toString().padLeft(4, '0')}-${fechaVencimiento!.month.toString().padLeft(2, '0')}-${fechaVencimiento!.day.toString().padLeft(2, '0')}",
        "cantidad_disponible": cantidadDisponible,
        "stock_estado": stockEstado,
        "nombre_unidad": nombreUnidad,
        "unidad_abreviatura": unidadAbreviatura,
        "imagenes": List<dynamic>.from(imagenes.map((x) => x)),
    };
}
