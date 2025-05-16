import 'dart:convert';

import 'package:vet_sotf_app/models/horario/ausencias_model.dart';

class ListaAusenciasModel {
  List<AusenciasModel> proximasAusencias = [];
  List<AusenciasModel> ausenciasPasadas = [];
  List<AusenciasModel> ausenciasRevision = [];
  List<AusenciasModel> ausenciasRechazadas = [];

  ListaAusenciasModel({
    required this.proximasAusencias,
    required this.ausenciasPasadas,
    required this.ausenciasRevision,
    required this.ausenciasRechazadas,
  });

  factory ListaAusenciasModel.fromJson(String str) => ListaAusenciasModel.fromMap(json.decode(str));

  factory ListaAusenciasModel.fromMap(Map<String, dynamic> json) => ListaAusenciasModel(
        proximasAusencias: List<AusenciasModel>.from(json["proximas_ausencias"].map((x) => AusenciasModel.fromMap(x))),
        ausenciasPasadas: List<AusenciasModel>.from(json["ausencias_pasadas"].map((x) => AusenciasModel.fromMap(x))),
        ausenciasRevision: List<AusenciasModel>.from(json["ausencias_revision"].map((x) => AusenciasModel.fromMap(x))),
        ausenciasRechazadas: List<AusenciasModel>.from(json["ausencias_rechazadas"].map((x) => AusenciasModel.fromMap(x))),
      );
}
