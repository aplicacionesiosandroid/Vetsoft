import 'dart:convert';

ModelTareasObjetivo modelTareasObjetivoFromJson(String str) => ModelTareasObjetivo.fromJson(json.decode(str));

String modelTareasObjetivoToJson(ModelTareasObjetivo data) => json.encode(data.toJson());

class ModelTareasObjetivo {
    bool error;
    int code;
    String message;
    List<TareaObjetivo> data;

    ModelTareasObjetivo({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelTareasObjetivo.fromJson(Map<String, dynamic> json) => ModelTareasObjetivo(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<TareaObjetivo>.from(json["data"].map((x) => TareaObjetivo.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class TareaObjetivo {
    int tareaId;
    String tiruloTarea;

    TareaObjetivo({
        required this.tareaId,
        required this.tiruloTarea,
    });

    factory TareaObjetivo.fromJson(Map<String, dynamic> json) => TareaObjetivo(
        tareaId: json["tarea_id"],
        tiruloTarea: json["tirulo_tarea"],
    );

    Map<String, dynamic> toJson() => {
        "tarea_id": tareaId,
        "tirulo_tarea": tiruloTarea,
    };
}
