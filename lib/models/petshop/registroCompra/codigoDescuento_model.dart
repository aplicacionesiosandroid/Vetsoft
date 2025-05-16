
import 'dart:convert';

ModelcodigoPromocion modelcodigoPromocionFromJson(String str) => ModelcodigoPromocion.fromJson(json.decode(str));

String modelcodigoPromocionToJson(ModelcodigoPromocion data) => json.encode(data.toJson());

class ModelcodigoPromocion {
    bool error;
    int code;
    String message;
    List<ProductosDescuento> data;

    ModelcodigoPromocion({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelcodigoPromocion.fromJson(Map<String, dynamic> json) => ModelcodigoPromocion(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<ProductosDescuento>.from(json["data"].map((x) => ProductosDescuento.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ProductosDescuento {
    int promocionId;
    int porcentajeDescuento;
    List<String> productosId;

    ProductosDescuento({
        required this.promocionId,
        required this.porcentajeDescuento,
        required this.productosId,
    });

    factory ProductosDescuento.fromJson(Map<String, dynamic> json) => ProductosDescuento(
        promocionId: json["promocion_id"],
        porcentajeDescuento: json["porcentaje_descuento"],
        productosId: List<String>.from(json["productos_id"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "promocion_id": promocionId,
        "porcentaje_descuento": porcentajeDescuento,
        "productos_id": List<dynamic>.from(productosId.map((x) => x)),
    };
}
