import 'dart:convert';

class EmpleadoModel {
  int empleadoId;
  String nombreApellidos;
  String rol;
  String imagenUser;
  String tipoHorario;
  String fechas;

  EmpleadoModel({
    required this.empleadoId,
    required this.nombreApellidos,
    required this.rol,
    required this.imagenUser,
    required this.tipoHorario,
    required this.fechas,
  });

  factory EmpleadoModel.fromJson(String str) => EmpleadoModel.fromMap(json.decode(str));

  factory EmpleadoModel.fromMap(Map<String, dynamic> json) => EmpleadoModel(
        empleadoId: json["empleado_id"],
        nombreApellidos: json["nombre_apellidos"],
        rol: json["rol"],
        imagenUser: json["imagen_user"],
        tipoHorario: json["tipo_horario"],
        fechas: json["fechas"],
      );

  get nombre => null;
}
