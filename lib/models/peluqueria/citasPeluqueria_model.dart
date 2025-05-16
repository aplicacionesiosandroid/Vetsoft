import 'dart:convert';

ModelCitasPeluqueria modelCitasPeluqueriaFromJson(String str) => ModelCitasPeluqueria.fromJson(json.decode(str));

String modelCitasPeluqueriaToJson(ModelCitasPeluqueria data) => json.encode(data.toJson());

class ModelCitasPeluqueria {
    bool error;
    int code;
    String message;
    List<CitaPeluqueria> data;

    ModelCitasPeluqueria({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelCitasPeluqueria.fromJson(Map<String, dynamic> json) => ModelCitasPeluqueria(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<CitaPeluqueria>.from(json["data"].map((x) => CitaPeluqueria.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CitaPeluqueria {
    int idPaciente;
    int idFichaPeluqueria;
    dynamic horaConsulta;
    String nombreMascota;
    String fotoMascota;
    DateTime fechaProximaVisita;
    String nombresPeluquero;
    String apellidosPeluquero;
    String descripcion;
    String pedidosEspeciales;

    CitaPeluqueria({
        required this.idPaciente,
        required this.idFichaPeluqueria,
        required this.horaConsulta,
        required this.nombreMascota,
        required this.fotoMascota,
        required this.fechaProximaVisita,
        required this.nombresPeluquero,
        required this.apellidosPeluquero,
        required this.descripcion,
        required this.pedidosEspeciales,
    });

    factory CitaPeluqueria.fromJson(Map<String, dynamic> json) => CitaPeluqueria(
        idPaciente: json["id_paciente"],
        idFichaPeluqueria: json["id_ficha_peluqueria"],
        horaConsulta: json["hora_consulta"],
        nombreMascota: json["nombre_mascota"],
        fotoMascota: json["foto_mascota"],
        fechaProximaVisita: DateTime.parse(json["fechaProximaVisita"]),
        nombresPeluquero: json["nombres_peluquero"],
        apellidosPeluquero: json["apellidos_peluquero"],
        descripcion: json["descripcion"],
        pedidosEspeciales: json["pedidosEspeciales"],
    );

    Map<String, dynamic> toJson() => {
        "id_paciente": idPaciente,
        "id_ficha_peluqueria": idFichaPeluqueria,
        "hora_consulta": horaConsulta,
        "nombre_mascota": nombreMascota,
        "foto_mascota": fotoMascota,
        "fechaProximaVisita": "${fechaProximaVisita.year.toString().padLeft(4, '0')}-${fechaProximaVisita.month.toString().padLeft(2, '0')}-${fechaProximaVisita.day.toString().padLeft(2, '0')}",
        "nombres_peluquero": nombresPeluquero,
        "apellidos_peluquero": apellidosPeluquero,
        "descripcion": descripcion,
        "pedidosEspeciales": pedidosEspeciales,
    };
}
