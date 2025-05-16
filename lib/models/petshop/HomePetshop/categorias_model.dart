import 'dart:convert';

ModelGrupoProductos modelGrupoProductosFromJson(String str) => ModelGrupoProductos.fromJson(json.decode(str));

String modelGrupoProductosToJson(ModelGrupoProductos data) => json.encode(data.toJson());

class ModelGrupoProductos {
  bool error;
  int code;
  String message;
  List<GrupoProducto> data;

  ModelGrupoProductos({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ModelGrupoProductos.fromJson(Map<String, dynamic> json) => ModelGrupoProductos(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<GrupoProducto>.from(json["data"].map((x) => GrupoProducto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class GrupoProducto {
  int grupoId;
  String nombreGrupo;
  int cantidadProductos;

  GrupoProducto({
    required this.grupoId,
    required this.nombreGrupo,
    required this.cantidadProductos,
  });

  factory GrupoProducto.fromJson(Map<String, dynamic> json) => GrupoProducto(
        grupoId: json["grupo_id"],
        nombreGrupo: json["nombre_grupo"],
        cantidadProductos: json["cantidad_productos"],
      );

  Map<String, dynamic> toJson() => {
        "grupo_id": grupoId,
        "nombre_grupo": nombreGrupo,
        "cantidad_productos": cantidadProductos,
      };
}
