
import 'dart:convert';

BuscarPacientes buscarPacientesFromJson(String str) => BuscarPacientes.fromJson(json.decode(str));

String buscarPacientesToJson(BuscarPacientes data) => json.encode(data.toJson());

class BuscarPacientes {
    bool error;
    int code;
    String message;
    List<ResultBusPacientes> data;

    BuscarPacientes({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory BuscarPacientes.fromJson(Map<String, dynamic> json) => BuscarPacientes(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: List<ResultBusPacientes>.from(json["data"].map((x) => ResultBusPacientes.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ResultBusPacientes {
    int idPaciente;
    String nombrePaciente;
    String nombrePropietario;
    String apellidosPropietario;

    ResultBusPacientes({
        required this.idPaciente,
        required this.nombrePaciente,
        required this.nombrePropietario,
        required this.apellidosPropietario,
    });

    factory ResultBusPacientes.fromJson(Map<String, dynamic> json) => ResultBusPacientes(
        idPaciente: json["id_paciente"],
        nombrePaciente: json["nombre_paciente"],
        nombrePropietario: json["nombre_propietario"],
        apellidosPropietario: json["apellidos_propietario"],
    );

    Map<String, dynamic> toJson() => {
        "id_paciente": idPaciente,
        "nombre_paciente": nombrePaciente,
        "nombre_propietario": nombrePropietario,
        "apellidos_propietario": apellidosPropietario,
    };
}