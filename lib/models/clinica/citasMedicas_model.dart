import 'dart:convert';

ModelCitasMedicas modelCitasMedicasFromJson(String str) => ModelCitasMedicas.fromJson(json.decode(str));

String modelCitasMedicasToJson(ModelCitasMedicas data) => json.encode(data.toJson());

class ModelCitasMedicas {
  bool error;
  int code;
  String message;
  List<CitaMedica> data;

  ModelCitasMedicas({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ModelCitasMedicas.fromJson(Map<String, dynamic> json) {
    List<CitaMedica> citasList = [];
    if (json["data"] != null && json["data"] is List) {
      citasList = List<CitaMedica>.from(json["data"].map((x) => CitaMedica.fromJson(x)));
    }

    return ModelCitasMedicas(
      error: json["error"],
      code: json["code"],
      message: json["message"],
      data: citasList,
    );
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CitaMedica {
  int idPaciente;
  int idFichaClinica;
  String nombreMascota;
  String fotoMascota;
  DateTime fechaSiguienteRevision;
  String horaSiguienteRevision;
  String nombresVeterinario;
  String apellidosVeterinario;
  String descripcion;
  String tipoFicha;

  CitaMedica({
    required this.idPaciente,
    required this.idFichaClinica,
    required this.nombreMascota,
    required this.fotoMascota,
    required this.fechaSiguienteRevision,
    required this.horaSiguienteRevision,
    required this.nombresVeterinario,
    required this.apellidosVeterinario,
    required this.descripcion,
    required this.tipoFicha,
  });

  factory CitaMedica.fromJson(Map<String, dynamic> json) => CitaMedica(
        idPaciente: json["id_paciente"],
        idFichaClinica: json["id_ficha_clinica"],
        nombreMascota: json["nombre_mascota"],
        fotoMascota: json["foto_mascota"],
        fechaSiguienteRevision: DateTime.parse(json["fecha_siguiente_revision"]),
        horaSiguienteRevision: json["hora_siguiente_revision"],
        nombresVeterinario: json["nombres_veterinario"],
        apellidosVeterinario: json["apellidos_veterinario"],
        descripcion: json["descripcion"],
        tipoFicha: json["tipo_ficha"],
      );

  Map<String, dynamic> toJson() => {
        "id_paciente": idPaciente,
        "id_ficha_clinica": idFichaClinica,
        "nombre_mascota": nombreMascota,
        "foto_mascota": fotoMascota,
        "fecha_siguiente_revision":
            "${fechaSiguienteRevision.year.toString().padLeft(4, '0')}-${fechaSiguienteRevision.month.toString().padLeft(2, '0')}-${fechaSiguienteRevision.day.toString().padLeft(2, '0')}",
        "hora_siguiente_revision": horaSiguienteRevision,
        "nombres_veterinario": nombresVeterinario,
        "apellidos_veterinario": apellidosVeterinario,
        "descripcion": descripcion,
        "tipo_ficha": tipoFicha,
      };
}
