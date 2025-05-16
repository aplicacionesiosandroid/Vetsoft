// To parse this JSON data, do
//
//     final modelAvanceDashBoard = modelAvanceDashBoardFromJson(jsonString);

import 'dart:convert';

ModelAvanceDashBoard modelAvanceDashBoardFromJson(String str) => ModelAvanceDashBoard.fromJson(json.decode(str));

String modelAvanceDashBoardToJson(ModelAvanceDashBoard data) => json.encode(data.toJson());

class ModelAvanceDashBoard {
    bool error;
    int code;
    String message;
    AvanceDashboard data;

    ModelAvanceDashBoard({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelAvanceDashBoard.fromJson(Map<String, dynamic> json) => ModelAvanceDashBoard(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: AvanceDashboard.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": data.toJson(),
    };
}

class AvanceDashboard {
    ClinicaDashboard clinica;
    ClinicaDashboard peluqueria;

    AvanceDashboard({
        required this.clinica,
        required this.peluqueria,
    });

    factory AvanceDashboard.fromJson(Map<String, dynamic> json) => AvanceDashboard(
        clinica: ClinicaDashboard.fromJson(json["clinica"]),
        peluqueria: ClinicaDashboard.fromJson(json["peluqueria"]),
    );

    Map<String, dynamic> toJson() => {
        "clinica": clinica.toJson(),
        "peluqueria": peluqueria.toJson(),
    };
}

class ClinicaDashboard {
    int totalCitasDia;
    int totalAcabados;
    int porcentaje;

    ClinicaDashboard({
        required this.totalCitasDia,
        required this.totalAcabados,
        required this.porcentaje,
    });

    factory ClinicaDashboard.fromJson(Map<String, dynamic> json) => ClinicaDashboard(
        totalCitasDia: json["total_citas_dia"],
        totalAcabados: json["total_acabados"],
        porcentaje: json["porcentaje"],
    );

    Map<String, dynamic> toJson() => {
        "total_citas_dia": totalCitasDia,
        "total_acabados": totalAcabados,
        "porcentaje": porcentaje,
    };
}
