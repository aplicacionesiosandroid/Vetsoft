import 'dart:convert';

ModelGraphsDash modelGraphsDashFromJson(String str) => ModelGraphsDash.fromJson(json.decode(str));

String modelGraphsDashToJson(ModelGraphsDash data) => json.encode(data.toJson());

class ModelGraphsDash {
    bool error;
    int code;
    String message;
    DatoGrafico data;

    ModelGraphsDash({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelGraphsDash.fromJson(Map<String, dynamic> json) => ModelGraphsDash(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: DatoGrafico.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": data.toJson(),
    };
}

class DatoGrafico {
    List<int> ejeX;
    List<Producto> productos;

    DatoGrafico({
        required this.ejeX,
        required this.productos,
    });

    factory DatoGrafico.fromJson(Map<String, dynamic> json) => DatoGrafico(
        ejeX: List<int>.from(json["eje_x"].map((x) => x)),
        productos: List<Producto>.from(json["productos"].map((x) => Producto.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "eje_x": List<dynamic>.from(ejeX.map((x) => x)),
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
    };
}

class Producto {
    int itemId;
    String sku;
    int cantidad;

    Producto({
        required this.itemId,
        required this.sku,
        required this.cantidad,
    });

    factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        itemId: json["item_id"],
        sku: json["sku"],
        cantidad: json["cantidad"],
    );

    Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "sku": sku,
        "cantidad": cantidad,
    };
}
