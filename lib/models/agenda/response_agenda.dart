import 'dart:convert';

class ResponseModel {
  bool error;
  int code;
  String message;
  DataModel data;

  ResponseModel({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ResponseModel.fromJson(String jsonString) {
    final jsonData = json.decode(jsonString);
    return ResponseModel(
      error: jsonData['error'],
      code: jsonData['code'],
      message: jsonData['message'],
      data: DataModel.fromJson(jsonData['data']),
    );
  }
}

class DataModel {
  List<ClinicaModel> clinica;
  List<PeluqueriaModel> peluqueria;
  List<TareaModel> tareas;

  DataModel({
    required this.clinica,
    required this.peluqueria,
    required this.tareas,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      clinica: (json['clinica'] as List)
          .map((item) => ClinicaModel.fromJson(item))
          .toList(),
      peluqueria: (json['peluqueria'] as List)
          .map((item) => PeluqueriaModel.fromJson(item))
          .toList(),
      tareas: (json['tareas'] as List)
          .map((item) => TareaModel.fromJson(item))
          .toList(),
    );
  }
}

class ClinicaModel {
  int fichaClinicaId;
  int pacienteId;
  String horaAtencion;
  List<ResponsableModel> responsables;
  String tipoConsultaNombre;
  String nombreMascota;
  String edadMascota;
  String fotoMascota;
  String motivo;
  PropietarioModel propietario;

  ClinicaModel({
    required this.fichaClinicaId,
    required this.pacienteId,
    required this.horaAtencion,
    required this.responsables,
    required this.tipoConsultaNombre,
    required this.nombreMascota,
    required this.edadMascota,
    required this.fotoMascota,
    required this.motivo,
    required this.propietario,
  });

  factory ClinicaModel.fromJson(Map<String, dynamic> json) {
    return ClinicaModel(
      fichaClinicaId: json['ficha_clinica_id'],
      pacienteId: json['paciente_id'],
      horaAtencion: json['hora_atencion'],
      responsables: (json['responsables'] as List)
          .map((item) => ResponsableModel.fromJson(item))
          .toList(),
      tipoConsultaNombre: json['tipo_consulta_nombre'],
      nombreMascota: json['nombre_mascota'],
      edadMascota: json['edad_mascota'],
      fotoMascota: json['foto_mascota'],
      motivo: json['motivo'],
      propietario: PropietarioModel.fromJson(json['propietario']),
    );
  }
}

class PeluqueriaModel {
  int fichaPeluqueriaId;
  int pacienteId;
  String? horaAtencion;
  List<ResponsableModel> responsables;
  String tipoConsultaNombre;
  String nombreMascota;
  String edadMascota;
  String fotoMascota;
  String motivo;

  PeluqueriaModel({
    required this.fichaPeluqueriaId,
    required this.pacienteId,
    required this.horaAtencion,
    required this.responsables,
    required this.tipoConsultaNombre,
    required this.nombreMascota,
    required this.edadMascota,
    required this.fotoMascota,
    required this.motivo,
  });

  factory PeluqueriaModel.fromJson(Map<String, dynamic> json) {
    return PeluqueriaModel(
      fichaPeluqueriaId: json['ficha_peluqueria_id'],
      pacienteId: json['paciente_id'],
      horaAtencion: json['hora_atencion'],
      responsables: (json['responsables'] as List)
          .map((item) => ResponsableModel.fromJson(item))
          .toList(),
      tipoConsultaNombre: json['tipo_consulta_nombre'],
      nombreMascota: json['nombre_mascota'],
      edadMascota: json['edad_mascota'],
      fotoMascota: json['foto_mascota'],
      motivo: json['motivo'],
    );
  }
}

class TareaModel {
  int tareaId;
  String nombreTarea;
  String fecha;
  List<ResponsableModel> responsables;

  TareaModel({
    required this.tareaId,
    required this.nombreTarea,
    required this.fecha,
    required this.responsables,
  });

  factory TareaModel.fromJson(Map<String, dynamic> json) {
    return TareaModel(
      tareaId: json['tarea_id'],
      nombreTarea: json['nombre_tarea'],
      fecha: json['fecha'],
      responsables: (json['responsables'] as List)
          .map((item) => ResponsableModel.fromJson(item))
          .toList(),
    );
  }
}

class ResponsableModel {
  int responsableId;
  String responsableNombres;
  String responsableFoto;

  ResponsableModel({
    required this.responsableId,
    required this.responsableNombres,
    required this.responsableFoto,
  });

  factory ResponsableModel.fromJson(Map<String, dynamic> json) {
    return ResponsableModel(
      responsableId: json['responsable_id'],
      responsableNombres: json['responsable_nombres'],
      responsableFoto: json['responsable_foto'],
    );
  }
}

class PropietarioModel {
  String ultimaVisita;
  String nombres;
  String celular;
  String direccion;
  String imagenPropietario;

  PropietarioModel({
    required this.ultimaVisita,
    required this.nombres,
    required this.celular,
    required this.direccion,
    required this.imagenPropietario,
  });

  factory PropietarioModel.fromJson(Map<String, dynamic> json) {
    return PropietarioModel(
      ultimaVisita: json['ultima_visita'],
      nombres: json['nombres'],
      celular: json['celular'],
      direccion: json['direccion'],
      imagenPropietario: json['imagen_propietario'],
    );
  }
}
