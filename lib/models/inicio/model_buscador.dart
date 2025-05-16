// To parse this JSON data, do
//
//     final modelBusquedaGeneral = modelBusquedaGeneralFromJson(jsonString);

import 'dart:convert';

ModelBusquedaGeneral modelBusquedaGeneralFromJson(String str) => ModelBusquedaGeneral.fromJson(json.decode(str));

String modelBusquedaGeneralToJson(ModelBusquedaGeneral data) => json.encode(data.toJson());

class ModelBusquedaGeneral {
    bool error;
    int code;
    String message;
    BuscadorGeneral data;

    ModelBusquedaGeneral({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelBusquedaGeneral.fromJson(Map<String, dynamic> json) => ModelBusquedaGeneral(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: BuscadorGeneral.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": data.toJson(),
    };
}

class BuscadorGeneral {
    List<DataPropietario> propietarios;
    List<Paciente> pacientes;
    List<Producto> productos;

    BuscadorGeneral({
        required this.propietarios,
        required this.pacientes,
        required this.productos,
    });

    factory BuscadorGeneral.fromJson(Map<String, dynamic> json) => BuscadorGeneral(
        propietarios: List<DataPropietario>.from(json["propietarios"].map((x) => DataPropietario.fromJson(x))),
        pacientes: List<Paciente>.from(json["pacientes"].map((x) => Paciente.fromJson(x))),
        productos: List<Producto>.from(json["productos"].map((x) => Producto.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "propietarios": List<dynamic>.from(propietarios.map((x) => x.toJson())),
        "pacientes": List<dynamic>.from(pacientes.map((x) => x.toJson())),
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
    };
}

class Paciente {
    int mascotaId;
    String imagenMascota;
    String nombreMascota;
    List<PacientePropietario> propietario;

    Paciente({
        required this.mascotaId,
        required this.imagenMascota,
        required this.nombreMascota,
        required this.propietario,
    });

    factory Paciente.fromJson(Map<String, dynamic> json) => Paciente(
        mascotaId: json["mascota_id"],
        imagenMascota: json["imagen_mascota"],
        nombreMascota: json["nombre_mascota"],
        propietario: List<PacientePropietario>.from(json["propietario"].map((x) => PacientePropietario.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "mascota_id": mascotaId,
        "imagen_mascota": imagenMascota,
        "nombre_mascota": nombreMascota,
        "propietario": List<dynamic>.from(propietario.map((x) => x.toJson())),
    };
}

class PacientePropietario {
    String nombreCompleto;

    PacientePropietario({
        required this.nombreCompleto,
    });

    factory PacientePropietario.fromJson(Map<String, dynamic> json) => PacientePropietario(
        nombreCompleto: json["nombre_completo"],
    );

    Map<String, dynamic> toJson() => {
        "nombre_completo": nombreCompleto,
    };
}

class Producto {
    int productoId;
    String? nombreProducto;
    String nombreMarca;
    int? precioVentaProducto;
    String productoDetalle;
    DateTime? fechaVencimiento;
    int cantidadDisponible;
    String stockEstado;
    String nombreUnidad;
    String unidadAbreviatura;
    List<String> imagenes;

    Producto({
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

    factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        productoId: json["producto_id"],
        nombreProducto: json["nombre_producto"],
        nombreMarca: json["nombre_marca"],
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



class DataPropietario {
    int propietarioId;
    String imagenPropietario;
    String nombreCompleto;
    List<Mascota> mascotas;

    DataPropietario({
        required this.propietarioId,
        required this.imagenPropietario,
        required this.nombreCompleto,
        required this.mascotas,
    });

    factory DataPropietario.fromJson(Map<String, dynamic> json) => DataPropietario(
        propietarioId: json["propietario_id"],
        imagenPropietario: json["imagen_propietario"],
        nombreCompleto: json["nombre_completo"],
        mascotas: List<Mascota>.from(json["mascotas"].map((x) => Mascota.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "propietario_id": propietarioId,
        "imagen_propietario": imagenPropietario,
        "nombre_completo": nombreCompleto,
        "mascotas": List<dynamic>.from(mascotas.map((x) => x.toJson())),
    };
}

class Mascota {
    String nombre;

    Mascota({
        required this.nombre,
    });

    factory Mascota.fromJson(Map<String, dynamic> json) => Mascota(
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "nombre": nombre,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
