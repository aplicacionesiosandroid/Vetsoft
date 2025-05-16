import 'dart:convert';

Especies especiesFromJson(String str) => Especies.fromJson(json.decode(str));

String especiesToJson(Especies data) => json.encode(data.toJson());

class Especies {
  bool error;
  int code;
  String message;
  List<Especie> data;

  Especies({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory Especies.fromJson(Map<String, dynamic> json) {
  List<Especie> especiesList = [];
  if (json["data"] != null && json["data"] is List) {
    especiesList = List<Especie>.from(json["data"].map((x) => Especie.fromJson(x)));
  }
  
  return Especies(
    error: json["error"],
    code: json["code"],
    message: json["message"],
    data: especiesList,
  );
}

  Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Especie {
  int id;
  String nombre;

  Especie({
    required this.id,
    required this.nombre,
  });

  factory Especie.fromJson(Map<String, dynamic> json) => Especie(
        id: json["id"],
        nombre: json["nombre"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}
