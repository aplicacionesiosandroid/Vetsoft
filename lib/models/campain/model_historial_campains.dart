// To parse this JSON data, do
//
//     final modelHistorialCampains = modelHistorialCampainsFromJson(jsonString);

import 'dart:convert';

ModelHistorialCampains modelHistorialCampainsFromJson(String str) => ModelHistorialCampains.fromJson(json.decode(str));

String modelHistorialCampainsToJson(ModelHistorialCampains data) => json.encode(data.toJson());

class ModelHistorialCampains {
    bool error;
    int code;
    String message;
    HistorialCampain data;

    ModelHistorialCampains({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelHistorialCampains.fromJson(Map<String, dynamic> json) => ModelHistorialCampains(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: HistorialCampain.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": data.toJson(),
    };
}

class HistorialCampain {
    List<Promocione> promociones;

    HistorialCampain({
        required this.promociones,
    });

    factory HistorialCampain.fromJson(Map<String, dynamic> json) => HistorialCampain(
        promociones: List<Promocione>.from(json["promociones"].map((x) => Promocione.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "promociones": List<dynamic>.from(promociones.map((x) => x.toJson())),
    };
}

class Promocione {
    String nombrePromo;
    String tipo;
    int descuento;
    String descripcion;

    Promocione({
        required this.nombrePromo,
        required this.tipo,
        required this.descuento,
        required this.descripcion,
    });

    factory Promocione.fromJson(Map<String, dynamic> json) => Promocione(
        nombrePromo: json["nombre_promo"],
        tipo: json["tipo"],
        descuento: json["descuento"],
        descripcion: json["descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "nombre_promo": nombrePromo,
        "tipo": tipo,
        "descuento": descuento,
        "descripcion": descripcion,
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
