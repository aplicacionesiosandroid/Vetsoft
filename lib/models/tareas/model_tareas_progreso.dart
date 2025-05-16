import 'dart:convert';


ModelTareaPorcentajeHome modelTareaPorcentajeHomeFromJson(String str) => ModelTareaPorcentajeHome.fromJson(json.decode(str));

class ModelTareaPorcentajeHome {
    bool error;
    int code;
    String message;
    TareaPorcentajeHome data;

    ModelTareaPorcentajeHome({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelTareaPorcentajeHome.fromJson(Map<String, dynamic> json) => ModelTareaPorcentajeHome(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: TareaPorcentajeHome.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": data,
    };
}

class TareaPorcentajeHome {
    int porcentaje;
    String mensaje;

    TareaPorcentajeHome({
        required this.porcentaje,
        required this.mensaje,
    });

    factory TareaPorcentajeHome.fromJson(Map<String, dynamic> json) => TareaPorcentajeHome(
        porcentaje: json["porcentaje"],
        mensaje: json["mensaje"],
    );

    Map<String, dynamic> toJson() => {
        "porcentaje": porcentaje,
        "mensaje": mensaje,
    };
}

ModelTareaProgreso modelTareaProgresoFromJson(String str) => ModelTareaProgreso.fromJson(json.decode(str));

String modelTareaProgresoToJson(ModelTareaProgreso data) => json.encode(data.toJson());

class ModelTareaProgreso {
    bool error;
    int code;
    String message;
    List<TareaProgreso> data;

    ModelTareaProgreso({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelTareaProgreso.fromJson(Map<String, dynamic> json) => ModelTareaProgreso(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<TareaProgreso>.from(json["data"].map((x) => TareaProgreso.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class TareaProgreso {
    int tareaId;
    String titulo;
    String estado;
    int totalSubtareas;
    int subtareasRealizadas;
    int porcentaje;
    List<List<User>> users;

    TareaProgreso({
        required this.tareaId,
        required this.titulo,
        required this.estado,
        required this.totalSubtareas,
        required this.subtareasRealizadas,
        required this.porcentaje,
        required this.users,
    });

    factory TareaProgreso.fromJson(Map<String, dynamic> json) => TareaProgreso(
        tareaId: json["tarea_id"],
        titulo: json["titulo"],
        estado: json["estado"],
        totalSubtareas: json["total_subtareas"],
        subtareasRealizadas: json["subtareas_realizadas"],
        porcentaje: json["porcentaje"],
        users: List<List<User>>.from(json["users"].map((x) => List<User>.from(x.map((x) => User.fromJson(x))))),
    );

    Map<String, dynamic> toJson() => {
        "tarea_id": tareaId,
        "titulo": titulo,
        "estado": estado,
        "total_subtareas": totalSubtareas,
        "subtareas_realizadas": subtareasRealizadas,
        "porcentaje": porcentaje,
        "users": List<dynamic>.from(users.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    };
}

class User {
    int userId;
    String nombres;

    User({
        required this.userId,
        required this.nombres,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        nombres: json["nombres"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "nombres": nombres,
    };
}
