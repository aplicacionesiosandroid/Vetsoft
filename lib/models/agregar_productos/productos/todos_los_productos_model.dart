// To parse this JSON data, do
//
//     final todosProductosModel = todosProductosModelFromJson(jsonString);

import 'dart:convert';

List<TodosProductosModel> todosProductosModelFromJson(String str) => List<TodosProductosModel>.from(json.decode(str).map((x) => TodosProductosModel.fromJson(x)));

String todosProductosModelToJson(List<TodosProductosModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TodosProductosModel {
    int productoId;
    String? nombreProducto;
    String nombreMarca;
    int? precioVentaProducto;
    String productoDetalle;
    DateTime? fechaVencimiento;
    int cantidadDisponible;
    String stockEstado;
    String nombreUnidad;
    UnidadAbreviatura unidadAbreviatura;
    List<String> imagenes;

    TodosProductosModel({
        required this.productoId,
        required this.nombreProducto,
        required this.nombreMarca,
        required this.precioVentaProducto,
        required this.productoDetalle,
        required this.fechaVencimiento,
        required this.cantidadDisponible,
        required this.stockEstado,
        required this.nombreUnidad,
        required this.unidadAbreviatura,
        required this.imagenes,
    });

    factory TodosProductosModel.fromJson(Map<String, dynamic> json) => TodosProductosModel(
        productoId: json["producto_id"],
        nombreProducto: json["nombre_producto"],
        nombreMarca: json["nombre_marca"],
        precioVentaProducto: json["precio_venta_producto"],
        productoDetalle: json["producto_detalle"],
        fechaVencimiento: json["fecha_vencimiento"] == null ? null : DateTime.parse(json["fecha_vencimiento"]),
        cantidadDisponible: json["cantidad_disponible"],
        stockEstado: json["stock_estado"],
        nombreUnidad: json["nombre_unidad"],
        unidadAbreviatura: unidadAbreviaturaValues.map[json["unidad_abreviatura"]]!,
        imagenes: List<String>.from(json["imagenes"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "producto_id": productoId,
        "nombre_producto": nombreProducto,
        "nombre_marca": nombreMarca,
        "precio_venta_producto": precioVentaProducto,
        "producto_detalle": productoDetalleValues.reverse[productoDetalle],
        "fecha_vencimiento": "${fechaVencimiento!.year.toString().padLeft(4, '0')}-${fechaVencimiento!.month.toString().padLeft(2, '0')}-${fechaVencimiento!.day.toString().padLeft(2, '0')}",
        "cantidad_disponible": cantidadDisponible,
        "stock_estado": stockEstado,
        "nombre_unidad": nombreUnidad,
        "unidad_abreviatura": unidadAbreviaturaValues.reverse[unidadAbreviatura],
        "imagenes": List<dynamic>.from(imagenes.map((x) => x)),
    };
}

enum NombreMarca {
    CHAMEX,
    PATITO
}

final nombreMarcaValues = EnumValues({
    "CHAMEX": "CHAMEX",
    "PATITO": NombreMarca.PATITO
});

enum NombreUnidad {
    KILOS,
    PIEZA,
    TAMAO_CARTA
}

final nombreUnidadValues = EnumValues({
    "kilos": NombreUnidad.KILOS,
    "PIEZA": NombreUnidad.PIEZA,
    "TAMAÑO CARTA": NombreUnidad.TAMAO_CARTA
});

enum ProductoDetalle {
    ALIMENTO_MONELO_CACHORRO,
    ALIMENTO_ROYAL_CANIN,
    ESTO_ES_UN_TEST_DESCRIPCION,
    ESTO_ES_UN_TEST_DE_DESCRIP,
    PATITO_DE_GOMA
}

final productoDetalleValues = EnumValues({
    "ALIMENTO MONELO CACHORRO": ProductoDetalle.ALIMENTO_MONELO_CACHORRO,
    "ALIMENTO ROYAL CANIN": ProductoDetalle.ALIMENTO_ROYAL_CANIN,
    "esto es un test descripcion": ProductoDetalle.ESTO_ES_UN_TEST_DESCRIPCION,
    "esto es un test de descrip": ProductoDetalle.ESTO_ES_UN_TEST_DE_DESCRIP,
    "PATITO DE GOMA": ProductoDetalle.PATITO_DE_GOMA
});

enum StockEstado {
    EMPTY,
    STOCK_BAJO
}

final stockEstadoValues = EnumValues({
    "": StockEstado.EMPTY,
    "Stock bajo": StockEstado.STOCK_BAJO
});

enum UnidadAbreviatura {
    HOJA_CARTA,
    KG,
    PZA
}

final unidadAbreviaturaValues = EnumValues({
    "HOJA CARTA": UnidadAbreviatura.HOJA_CARTA,
    "kg": UnidadAbreviatura.KG,
    "PZA": UnidadAbreviatura.PZA
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}