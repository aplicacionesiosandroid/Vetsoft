import 'dart:convert';

class AdminTipoAusenciaModel {
  int tipoAusenciaId;
  String nombreAusencia;
  String color;

  AdminTipoAusenciaModel({
    required this.tipoAusenciaId,
    required this.nombreAusencia,
    required this.color,
  });

  factory AdminTipoAusenciaModel.fromJson(String str) => AdminTipoAusenciaModel.fromMap(json.decode(str));

  factory AdminTipoAusenciaModel.fromMap(Map<String, dynamic> json) => AdminTipoAusenciaModel(
        tipoAusenciaId: json["tipo_ausencia_id"],
        nombreAusencia: json["nombre_ausencia"],
        color: json["color"],
      );
}
