import 'dart:convert';

ModelParticipantesTareas modelParticipantesTareasFromJson(String str) => ModelParticipantesTareas.fromJson(json.decode(str));

String modelParticipantesTareasToJson(ModelParticipantesTareas data) => json.encode(data.toJson());

class ModelParticipantesTareas {
    bool error;
    int code;
    String message;
    List<ParticipanteTarea> data;

    ModelParticipantesTareas({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelParticipantesTareas.fromJson(Map<String, dynamic> json) => ModelParticipantesTareas(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<ParticipanteTarea>.from(json["data"].map((x) => ParticipanteTarea.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ParticipanteTarea {
    int encargadoId;
    String nombres;
    String apellidos;
    String itemName;
    String imgUser;

    ParticipanteTarea({
        required this.encargadoId,
        required this.nombres,
        required this.apellidos,
        required this.itemName,
        required this.imgUser,
    });

    factory ParticipanteTarea.fromJson(Map<String, dynamic> json) => ParticipanteTarea(
        encargadoId: json["encargado_id"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        itemName: json["item_name"],
        imgUser: json["imagen_user"],
    );

    Map<String, dynamic> toJson() => {
        "encargado_id": encargadoId,
        "nombres": nombres,
        "apellidos": apellidos,
        "item_name": itemName,
        "imagen_user": imgUser,
    };
}
