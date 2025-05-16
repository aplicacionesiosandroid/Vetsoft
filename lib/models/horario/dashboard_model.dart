import 'dart:convert';

class DashboardModel {
  Ejes ejes;
  List<int> asistencia;
  List<int> ausencias;

  DashboardModel({
    required this.ejes,
    required this.asistencia,
    required this.ausencias,
  });

  factory DashboardModel.fromJson(String str) => DashboardModel.fromMap(json.decode(str));

  factory DashboardModel.fromMap(Map<String, dynamic> json) => DashboardModel(
        ejes: Ejes.fromMap(json["ejes"]),
        asistencia: List<int>.from(json["asistencia"].map((x) => x)),
        ausencias: List<int>.from(json["ausencias"].map((x) => x)),
      );
}

class Ejes {
  List<int> ejeY;
  List<DateTime> ejeX;

  Ejes({
    required this.ejeY,
    required this.ejeX,
  });

  factory Ejes.fromJson(String str) => Ejes.fromMap(json.decode(str));

  factory Ejes.fromMap(Map<String, dynamic> json) => Ejes(
        ejeY: List<int>.from(json["eje_y"].map((x) => x)),
        ejeX: List<DateTime>.from(json["eje_x"].map((x) => DateTime.parse(x))),
      );
}
