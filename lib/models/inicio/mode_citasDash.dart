// To parse this JSON data, do
//
//     final modelCitasDiaDashboard = modelCitasDiaDashboardFromJson(jsonString);

import 'dart:convert';

ModelCitasDiaDashboard modelCitasDiaDashboardFromJson(String str) => ModelCitasDiaDashboard.fromJson(json.decode(str));

String modelCitasDiaDashboardToJson(ModelCitasDiaDashboard data) => json.encode(data.toJson());

class ModelCitasDiaDashboard {
    bool error;
    int code;
    String message;
    List<CitaDiaDash> data;

    ModelCitasDiaDashboard({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelCitasDiaDashboard.fromJson(Map<String, dynamic> json) => ModelCitasDiaDashboard(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<CitaDiaDash>.from(json["data"].map((x) => CitaDiaDash.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CitaDiaDash {
    int? fichaPeluqueriaId;
    String tipo;
    int pacienteId;
    String fotoPaciente;
    String nombrePaciente;
    String hora;
    String motivo;
    List<Responsable> responsables;
    int? fichaClinicaId;

    CitaDiaDash({
        this.fichaPeluqueriaId,
        required this.tipo,
        required this.pacienteId,
        required this.fotoPaciente,
        required this.nombrePaciente,
        required this.hora,
        required this.motivo,
        required this.responsables,
        this.fichaClinicaId,
    });

    factory CitaDiaDash.fromJson(Map<String, dynamic> json) => CitaDiaDash(
        fichaPeluqueriaId: json["ficha_peluqueria_id"],
        tipo: json["tipo"],
        pacienteId: json["paciente_id"],
        fotoPaciente: json["foto_paciente"],
        nombrePaciente: json["nombre_paciente"],
        hora: json["hora"],
        motivo: json["motivo"],
        responsables: List<Responsable>.from(json["responsables"].map((x) => Responsable.fromJson(x))),
        fichaClinicaId: json["ficha_clinica_id"],
    );

    Map<String, dynamic> toJson() => {
        "ficha_peluqueria_id": fichaPeluqueriaId,
        "tipo": tipo,
        "paciente_id": pacienteId,
        "foto_paciente": fotoPaciente,
        "nombre_paciente": nombrePaciente,
        "hora": hora,
        "motivo": motivo,
        "responsables": List<dynamic>.from(responsables.map((x) => x.toJson())),
        "ficha_clinica_id": fichaClinicaId,
    };
}

class Responsable {
    int responsableId;
    String nombreResponsable;
    String fotoResponsable;

    Responsable({
        required this.responsableId,
        required this.nombreResponsable,
        required this.fotoResponsable,
    });

    factory Responsable.fromJson(Map<String, dynamic> json) => Responsable(
        responsableId: json["responsable_id"],
        nombreResponsable: json["nombre_responsable"],
        fotoResponsable: json["foto_responsable"],
    );

    Map<String, dynamic> toJson() => {
        "responsable_id": responsableId,
        "nombre_responsable": nombreResponsable,
        "foto_responsable": fotoResponsable,
    };
}
