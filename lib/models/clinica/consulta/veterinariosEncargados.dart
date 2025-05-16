import 'dart:convert';

ModelVeterinarios modelVeterinariosFromJson(String str) =>
    ModelVeterinarios.fromJson(json.decode(str));

String modelVeterinariosToJson(ModelVeterinarios data) =>
    json.encode(data.toJson());

class ModelVeterinarios {
  bool error;
  int code;
  String message;
  List<EncargadosVete> data;

  ModelVeterinarios({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

 factory ModelVeterinarios.fromJson(Map<String, dynamic> json) {
      List<EncargadosVete> encargadosList = [];
      if (json["data"] != null && json["data"] is List) {
        encargadosList = List<EncargadosVete>.from(json["data"].map((x) => EncargadosVete.fromJson(x)));
      }
      
      return ModelVeterinarios(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: encargadosList,
      );
    }


  Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class EncargadosVete {
  int encargadoVeteId;
  String nombres;
  String apellidos;
  String imgUser = 'files/logoVetsoft.png';

  EncargadosVete({
    required this.encargadoVeteId,
    required this.nombres,
    required this.apellidos,
    required this.imgUser,
  });

  factory EncargadosVete.fromJson(Map<String, dynamic> json) => EncargadosVete(
        encargadoVeteId: json["encargado_id"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        imgUser: 'files/logoVetsoft.png',
      );

  Map<String, dynamic> toJson() => {
        "encargado_id": encargadoVeteId,
        "nombres": nombres,
        "apellidos": apellidos,
        "img_user": imgUser,
      };
}
