class ProductosFavoritosModel {
  int productoId;
  String? nombreProducto;
  String nombreMarca;
  double costoProducto;
  int? precioVentaProducto;
  String productoDetalle;
  DateTime? fechaVencimiento;
  int cantidadDisponible;
  String stockEstado;
  String nombreUnidad;
  String unidadAbreviatura;
  List<String> imagenes;

  ProductosFavoritosModel({
    required this.productoId,
    this.nombreProducto,
    required this.nombreMarca,
    required this.costoProducto,
    this.precioVentaProducto,
    required this.productoDetalle,
    this.fechaVencimiento,
    required this.cantidadDisponible,
    required this.stockEstado,
    required this.nombreUnidad,
    required this.unidadAbreviatura,
    required this.imagenes,
  });

  factory ProductosFavoritosModel.fromJson(Map<String, dynamic> json) => ProductosFavoritosModel(
    productoId: json["producto_id"] ?? 0,
    nombreProducto: json["nombre_producto"],
    nombreMarca: json["nombre_marca"] ?? "",
    costoProducto: (json["costo_producto"] ?? 0.0).toDouble(),
    precioVentaProducto: json["precio_venta_producto"] ?? 0,
    productoDetalle: json["producto_detalle"] ?? "",
    fechaVencimiento: json["fecha_vencimiento"] != null ? DateTime.parse(json["fecha_vencimiento"]) : null,
    cantidadDisponible: json["cantidad_disponible"] ?? 0,
    stockEstado: json["stock_estado"] ?? "",
    nombreUnidad: json["nombre_unidad"] ?? "",
    unidadAbreviatura: json["unidad_abreviatura"] ?? "",
    imagenes: List<String>.from(json["imagenes"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "producto_id": productoId,
    "nombre_producto": nombreProducto,
    "nombre_marca": nombreMarca,
    "costo_producto": costoProducto,
    "precio_venta_producto": precioVentaProducto,
    "producto_detalle": productoDetalle,
    "fecha_vencimiento": fechaVencimiento?.toIso8601String(),
    "cantidad_disponible": cantidadDisponible,
    "stock_estado": stockEstado,
    "nombre_unidad": nombreUnidad,
    "unidad_abreviatura": unidadAbreviatura,
    "imagenes": List<dynamic>.from(imagenes.map((x) => x)),
  };
}
