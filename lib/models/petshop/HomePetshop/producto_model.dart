import 'dart:convert';

class Product {
  final String name;
  final String image;
  final double price;
  final double salePrice;
  final bool isOnSale;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.salePrice,
    required this.isOnSale,
  });
}


ModelProductos modelProductosFromJson(String str) => ModelProductos.fromJson(json.decode(str));

String modelProductosToJson(ModelProductos data) => json.encode(data.toJson());

class ModelProductos {
    bool error;
    int code;
    String message;
    List<Productos> data;

    ModelProductos({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelProductos.fromJson(Map<String, dynamic> json) => ModelProductos(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<Productos>.from(json["data"].map((x) => Productos.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

ProductoJson jsonToProduct(String str) => ProductoJson.fromJson(json.decode(str));

class ProductoJson {
    bool error;
    int code;
    String message;
    Productos data;

    ProductoJson({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ProductoJson.fromJson(Map<String, dynamic> json) => ProductoJson(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: Productos.fromJson(json["data"]),
    );

}

class Productos {
    int productoId;
    String nombreProducto;
    String nombreMarca;
    int precioVentaProducto;
    String costoProducto;
    String productoDetalle;
    dynamic fechaVencimiento;
    int cantidadDisponible;
    String oferta;
    String stockEstado;
    String nombreUnidad;
    String unidadAbreviatura;
    List<String> imagenes;

    Productos({
        required this.productoId,
        required this.nombreProducto,
        required this.nombreMarca,
        required this.precioVentaProducto,
        required this.costoProducto,
        required this.productoDetalle,
        required this.fechaVencimiento,
        required this.cantidadDisponible,
        required this.oferta,
        required this.stockEstado,
        required this.nombreUnidad,
        required this.unidadAbreviatura,
        required this.imagenes,
    });

    factory Productos.fromJson(Map<String, dynamic> json) => Productos(
        productoId: json["producto_id"],
        nombreProducto: json["nombre_producto"] ?? 'Nombre',
        nombreMarca: json["nombre_marca"],
        precioVentaProducto: json["precio_venta_producto"] ?? 0,
        costoProducto: json["costo_producto"] ?? 'Costo',
        productoDetalle: json["producto_detalle"],
        fechaVencimiento: json["fecha_vencimiento"],
        cantidadDisponible: json["cantidad_disponible"],
        oferta: json["oferta"] ?? 'S/N',
        stockEstado: json["stock_estado"],
        nombreUnidad: json["nombre_unidad"],
        unidadAbreviatura: json["unidad_abreviatura"],
        imagenes: List<String>.from(json["imagenes"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "producto_id": productoId,
        "nombre_producto": nombreProducto,
        "nombre_marca": nombreMarca,
        "precio_venta_producto": precioVentaProducto,
        "costo_producto": costoProducto,
        "producto_detalle": productoDetalle,
        "fecha_vencimiento": fechaVencimiento,
        "cantidad_disponible": cantidadDisponible,
        "oferta": oferta,
        "stock_estado": stockEstado,
        "nombre_unidad": nombreUnidad,
        "unidad_abreviatura": unidadAbreviatura,
        "imagenes": List<dynamic>.from(imagenes.map((x) => x)),
    };
}


