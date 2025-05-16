import 'dart:convert';

class NovedadesModel {
  int ausenciaId;
  String tituloAusencia;
  String nombreEmpleado;
  String fotoEmpleado;
  String motivo;
  String fecha;

  NovedadesModel({
    required this.ausenciaId,
    required this.tituloAusencia,
    required this.nombreEmpleado,
    required this.fotoEmpleado,
    required this.motivo,
    required this.fecha,
  });

  factory NovedadesModel.fromJson(String str) => NovedadesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NovedadesModel.fromMap(Map<String, dynamic> json) => NovedadesModel(
        ausenciaId: json["ausencia_id"],
        tituloAusencia: json["titulo_ausencia"],
        nombreEmpleado: json["nombre_empleado"],
        fotoEmpleado: json["foto_empleado"],
        motivo: json["motivo"],
        fecha: json["fecha"],
      );

  Map<String, dynamic> toMap() => {
        "ausencia_id": ausenciaId,
        "titulo_ausencia": tituloAusencia,
        "nombre_empleado": nombreEmpleado,
        "foto_empleado": fotoEmpleado,
        "motivo": motivo,
        "fecha": fecha,
      };
}
