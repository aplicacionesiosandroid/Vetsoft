// To parse this JSON data, do
//
//     final modelContactsCampain = modelContactsCampainFromJson(jsonString);

import 'dart:convert';

ModelContactsCampain modelContactsCampainFromJson(String str) => ModelContactsCampain.fromJson(json.decode(str));

String modelContactsCampainToJson(ModelContactsCampain data) => json.encode(data.toJson());

class ModelContactsCampain {
    bool error;
    int code;
    String message;
    List<Contacts> data;

    ModelContactsCampain({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelContactsCampain.fromJson(Map<String, dynamic> json) => ModelContactsCampain(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<Contacts>.from(json["data"].map((x) => Contacts.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Contacts {
    int contactoId;
    String nombres;
    String apellidos;
    String celular;

    Contacts({
        required this.contactoId,
        required this.nombres,
        required this.apellidos,
        required this.celular,
    });

    factory Contacts.fromJson(Map<String, dynamic> json) => Contacts(
        contactoId: json["contacto_id"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        celular: json["celular"],
    );

    Map<String, dynamic> toJson() => {
        "contacto_id": contactoId,
        "nombres": nombres,
        "apellidos": apellidos,
        "celular": celular,
    };
}
