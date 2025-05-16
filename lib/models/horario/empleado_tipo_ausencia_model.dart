import 'dart:convert';

class EmpleadoTipoAusenciaModel {
  int tipoAusenciaId;
  String nombreAusencia;
  bool documento;

  EmpleadoTipoAusenciaModel({
    required this.tipoAusenciaId,
    required this.nombreAusencia,
    required this.documento,
  });

  factory EmpleadoTipoAusenciaModel.fromJson(String str) => EmpleadoTipoAusenciaModel.fromMap(json.decode(str));

  factory EmpleadoTipoAusenciaModel.fromMap(Map<String, dynamic> json) => EmpleadoTipoAusenciaModel(
        tipoAusenciaId: json["tipo_ausencia_id"],
        nombreAusencia: json["nombre_ausencia"],
        documento: json["documento"],
      );
}
