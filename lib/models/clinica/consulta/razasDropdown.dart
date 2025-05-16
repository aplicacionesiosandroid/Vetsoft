import 'dart:convert';


Razas razasFromJson(String str) => Razas.fromJson(json.decode(str));

String razasToJson(Razas data) => json.encode(data.toJson());

class Razas {
  bool error;
  int code;
  String message;
  List<Raza> data;

  Razas({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory Razas.fromJson(Map<String, dynamic> json) {
      List<Raza> razasList = [];
      if (json["data"] != null && json["data"] is List) {
        razasList = List<Raza>.from(json["data"].map((x) => Raza.fromJson(x)));
      }
      
      return Razas(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: razasList,
      );
    }


  Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Raza {
  int id;
  String nombre;

  Raza({
    required this.id,
    required this.nombre,
  });

  factory Raza.fromJson(Map<String, dynamic> json) => Raza(
        id: json["id"],
        nombre: json["nombre"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}
