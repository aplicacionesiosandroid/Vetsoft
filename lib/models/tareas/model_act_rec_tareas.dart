import 'dart:convert';

ModelActividadRecienteTareas modelActividadRecienteTareasFromJson(String str) => ModelActividadRecienteTareas.fromJson(json.decode(str));

String modelActividadRecienteTareasToJson(ModelActividadRecienteTareas data) => json.encode(data.toJson());

class ModelActividadRecienteTareas {
    bool error;
    int code;
    String message;
    List<ActRecienteTarea> data;

    ModelActividadRecienteTareas({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelActividadRecienteTareas.fromJson(Map<String, dynamic> json) => ModelActividadRecienteTareas(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<ActRecienteTarea>.from(json["data"].map((x) => ActRecienteTarea.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ActRecienteTarea {
    int tareaId;
    String tituloTarea;
    String estado;
    dynamic fechaInicio;
    dynamic fechaFin;
    DateTime fechaActualizacion;
    String horaActualizacion;
    String mensajeActualizacion;
    List<Participante> participantes;

    ActRecienteTarea({
        required this.tareaId,
        required this.tituloTarea,
        required this.estado,
        required this.fechaInicio,
        required this.fechaFin,
        required this.fechaActualizacion,
        required this.horaActualizacion,
        required this.mensajeActualizacion,
        required this.participantes,
    });

    factory ActRecienteTarea.fromJson(Map<String, dynamic> json) => ActRecienteTarea(
        tareaId: json["tarea_id"],
        tituloTarea: json["titulo_tarea"],
        estado: json["estado"],
        fechaInicio: json["fecha_inicio"] ?? 'F. Inicio',
        fechaFin: json["fecha_fin"] ?? 'F. Fin',
        fechaActualizacion: DateTime.parse(json["fecha_actualizacion"]),
        horaActualizacion: json["hora_actualizacion"],
        mensajeActualizacion: json["mensaje_actualizacion"],
        participantes: List<Participante>.from(json["participantes"].map((x) => Participante.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "tarea_id": tareaId,
        "titulo_tarea": tituloTarea,
        "estado": estado,
        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFin,
        "fecha_actualizacion": "${fechaActualizacion.year.toString().padLeft(4, '0')}-${fechaActualizacion.month.toString().padLeft(2, '0')}-${fechaActualizacion.day.toString().padLeft(2, '0')}",
        "hora_actualizacion": horaActualizacion,
        "mensaje_actualizacion": mensajeActualizacion,
        "participantes": List<dynamic>.from(participantes.map((x) => x.toJson())),
    };
}

class Participante {
    int userId;
    String nombres;
    String apellidos;
    String imagenUser;

    Participante({
        required this.userId,
        required this.nombres,
        required this.apellidos,
        required this.imagenUser,
    });

    factory Participante.fromJson(Map<String, dynamic> json) => Participante(
        userId: json["user_id"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        imagenUser: json["imagen_user"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "nombres": nombres,
        "apellidos": apellidos,
        "imagen_user": imagenUser,
    };
}
