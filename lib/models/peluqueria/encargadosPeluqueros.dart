import 'dart:convert';

ModelPeluqueros modelPeluquerosFromJson(String str) => ModelPeluqueros.fromJson(json.decode(str));

String modelPeluquerosToJson(ModelPeluqueros data) => json.encode(data.toJson());

class ModelPeluqueros {
    bool error;
    int code;
    String message;
    List<EncarPeluqueros> data;

    ModelPeluqueros({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelPeluqueros.fromJson(Map<String, dynamic> json) => ModelPeluqueros(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<EncarPeluqueros>.from(json["data"].map((x) => EncarPeluqueros.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class EncarPeluqueros {
    int encargadoPeluqueroId;
    String nombres;
    String apellidos;

    EncarPeluqueros({
        required this.encargadoPeluqueroId,
        required this.nombres,
        required this.apellidos,
    });

    factory EncarPeluqueros.fromJson(Map<String, dynamic> json) => EncarPeluqueros(
        encargadoPeluqueroId: json["encargado_id"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
    );

    Map<String, dynamic> toJson() => {
        "encargado_id": encargadoPeluqueroId,
        "nombres": nombres,
        "apellidos": apellidos,
    };
}
