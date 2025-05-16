import 'dart:convert';

class JornadaAvanceModel {
  int? userId;
  String? imagenUser;
  int? jornadaAvanzada;
  String? nombreCompleto;
  String? rol;
  int? porcentaje;
  String? mensaje;
  String? fichaEntrada;
  String? fichaSalida;
  String? horarioAsignado;

  JornadaAvanceModel({
    this.userId,
    this.imagenUser,
    this.jornadaAvanzada,
    this.nombreCompleto,
    this.rol,
    this.porcentaje,
    this.mensaje,
    this.fichaEntrada,
    this.fichaSalida,
    this.horarioAsignado,
  });

  factory JornadaAvanceModel.fromJson(String str) => JornadaAvanceModel.fromMap(json.decode(str));

  factory JornadaAvanceModel.fromMap(Map<String, dynamic> json) => JornadaAvanceModel(
        userId: json["user_id"],
        imagenUser: json["imagen_user"],
        jornadaAvanzada: json["jornada_avanzada"],
        nombreCompleto: json["nombre_completo"],
        rol: json["rol"],
        porcentaje: json["porcentaje"],
        mensaje: json["mensaje"],
        fichaEntrada: json["ficha_entrada"],
        fichaSalida: json["ficha_salida"],
        horarioAsignado: json["horario_asignado"],
      );
}
