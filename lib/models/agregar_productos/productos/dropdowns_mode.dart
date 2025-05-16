// To parse this JSON data, do
//
//     final modelDropDowns = modelDropDownsFromJson(jsonString);

import 'dart:convert';

ModelDropDowns modelDropDownsFromJson(String str) => ModelDropDowns.fromJson(json.decode(str));

String modelDropDownsToJson(ModelDropDowns data) => json.encode(data.toJson());

class ModelDropDowns {
    bool error;
    int code;
    String message;
    Dropdowns data;

    ModelDropDowns({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelDropDowns.fromJson(Map<String, dynamic> json) => ModelDropDowns(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: Dropdowns.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": data.toJson(),
    };
}

class Dropdowns {
    List<Grupo> grupo;
    List<Marca> marcas;
    List<UnidadesMedida> unidadesMedida;
    List<Almacene> almacenes;

    Dropdowns({
        required this.grupo,
        required this.marcas,
        required this.unidadesMedida,
        required this.almacenes,
    });

    factory Dropdowns.fromJson(Map<String, dynamic> json) => Dropdowns(
        grupo: List<Grupo>.from(json["grupo"].map((x) => Grupo.fromJson(x))),
        marcas: List<Marca>.from(json["marcas"].map((x) => Marca.fromJson(x))),
        unidadesMedida: List<UnidadesMedida>.from(json["unidades_medida"].map((x) => UnidadesMedida.fromJson(x))),
        almacenes: List<Almacene>.from(json["almacenes"].map((x) => Almacene.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "grupo": List<dynamic>.from(grupo.map((x) => x.toJson())),
        "marcas": List<dynamic>.from(marcas.map((x) => x.toJson())),
        "unidades_medida": List<dynamic>.from(unidadesMedida.map((x) => x.toJson())),
        "almacenes": List<dynamic>.from(almacenes.map((x) => x.toJson())),
    };
}

class Almacene {
    int alamcenId;
    String nombre;

    Almacene({
        required this.alamcenId,
        required this.nombre,
    });

    factory Almacene.fromJson(Map<String, dynamic> json) => Almacene(
        alamcenId: json["alamcen_id"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "alamcen_id": alamcenId,
        "nombre": nombre,
    };
}

class Grupo {
    int grupoId;
    String nombreGrupo;
    List<List<SubGrupo>> subGrupo;

    Grupo({
        required this.grupoId,
        required this.nombreGrupo,
        required this.subGrupo,
    });

    factory Grupo.fromJson(Map<String, dynamic> json) => Grupo(
        grupoId: json["grupo_id"],
        nombreGrupo: json["nombre_grupo"],
        subGrupo: List<List<SubGrupo>>.from(json["sub_grupo"].map((x) => List<SubGrupo>.from(x.map((x) => SubGrupo.fromJson(x))))),
    );

    Map<String, dynamic> toJson() => {
        "grupo_id": grupoId,
        "nombre_grupo": nombreGrupo,
        "sub_grupo": List<dynamic>.from(subGrupo.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    };
}

class SubGrupo {
    int subGrupoId;
    String nombre;

    SubGrupo({
        required this.subGrupoId,
        required this.nombre,
    });

    factory SubGrupo.fromJson(Map<String, dynamic> json) => SubGrupo(
        subGrupoId: json["sub_grupo_id"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "sub_grupo_id": subGrupoId,
        "nombre": nombre,
    };
}

class Marca {
    int marcaId;
    String nombre;

    Marca({
        required this.marcaId,
        required this.nombre,
    });

    factory Marca.fromJson(Map<String, dynamic> json) => Marca(
        marcaId: json["marca_id"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "marca_id": marcaId,
        "nombre": nombre,
    };
}

class UnidadesMedida {
    int unidadId;
    String unidad;
    String abreviatura;

    UnidadesMedida({
        required this.unidadId,
        required this.unidad,
        required this.abreviatura,
    });

    factory UnidadesMedida.fromJson(Map<String, dynamic> json) => UnidadesMedida(
        unidadId: json["unidad_id"],
        unidad: json["unidad"],
        abreviatura:json["abreviatura"],
    );

    Map<String, dynamic> toJson() => {
        "unidad_id": unidadId,
        "unidad": unidad,
        "abreviatura": abreviatura,
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
