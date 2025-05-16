import 'dart:convert';

class PeluqueriaUpdateForm {
  bool error;
  int code;
  String message;
  Data data;

  PeluqueriaUpdateForm({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

// decode utf8 bytes to json
  factory PeluqueriaUpdateForm.fromJson(String str) => PeluqueriaUpdateForm.fromMap(json.decode(utf8.decode(str.runes.toList())));

  String toJson() => json.encode(toMap());

  factory PeluqueriaUpdateForm.fromMap(Map<String, dynamic> json) => PeluqueriaUpdateForm(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "error": error,
        "code": code,
        "message": message,
        "data": data.toMap(),
      };
}

class Data {
  Propietario propietario;
  Paciente paciente;
  ServiciosEsteticos serviciosEsteticos;

  Data({
    required this.propietario,
    required this.paciente,
    required this.serviciosEsteticos,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        propietario: Propietario.fromMap(json["propietario"]),
        paciente: Paciente.fromMap(json["paciente"]),
        serviciosEsteticos: ServiciosEsteticos.fromMap(json["servicios_esteticos"]),
      );

  Map<String, dynamic> toMap() => {
        "propietario": propietario.toMap(),
        "paciente": paciente.toMap(),
        "servicios_esteticos": serviciosEsteticos.toMap(),
      };
}

class Paciente {
  int pacienteId;
  String nombre;
  String sexo;
  String edad;
  int especieId;
  int razaId;
  String tamao;
  String temperamento;
  String alimentacion;

  Paciente({
    required this.pacienteId,
    required this.nombre,
    required this.sexo,
    required this.edad,
    required this.especieId,
    required this.razaId,
    required this.tamao,
    required this.temperamento,
    required this.alimentacion,
  });

  factory Paciente.fromJson(String str) => Paciente.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Paciente.fromMap(Map<String, dynamic> json) => Paciente(
        pacienteId: json["paciente_id"],
        nombre: json["nombre"],
        sexo: json["sexo"],
        edad: json["edad"],
        especieId: json["especie_id"],
        razaId: json["raza_id"],
        tamao: json["tamaño"],
        temperamento: json["temperamento"],
        alimentacion: json["alimentacion"],
      );

  Map<String, dynamic> toMap() => {
        "paciente_id": pacienteId,
        "nombre": nombre,
        "sexo": sexo,
        "edad": edad,
        "especie_id": especieId,
        "raza_id": razaId,
        "tamaño": tamao,
        "temperamento": temperamento,
        "alimentacion": alimentacion,
      };
}

class Propietario {
  int propietarioId;
  String nombres;
  String apellidos;
  String celular;
  String direccion;
  String documento;

  Propietario({
    required this.propietarioId,
    required this.nombres,
    required this.apellidos,
    required this.celular,
    required this.direccion,
    required this.documento,
  });

  factory Propietario.fromJson(String str) => Propietario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Propietario.fromMap(Map<String, dynamic> json) => Propietario(
        propietarioId: json["propietario_id"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        celular: json["celular"],
        direccion: json["direccion"],
        documento: json["documento"],
      );

  Map<String, dynamic> toMap() => {
        "propietario_id": propietarioId,
        "nombres": nombres,
        "apellidos": apellidos,
        "celular": celular,
        "direccion": direccion,
        "documento": documento,
      };
}

class ServiciosEsteticos {
  String pedidosEspeciales;
  String cortePelo;
  String mascotaDificil;
  String baoCompleto;
  String limpiezaOidos;
  String pedicura;
  String limpiezaDental;
  String limpiezaGlandulas;
  String eliminacionPulgas;
  String tratamiento;
  String indicacionesEspeciales;
  String horaEntrega;
  String consentimiento;
  DateTime fechaProximaVisita;
  String horaProximaVisita;
  List<String> encargadoId;

  ServiciosEsteticos({
    required this.pedidosEspeciales,
    required this.cortePelo,
    required this.mascotaDificil,
    required this.baoCompleto,
    required this.limpiezaOidos,
    required this.pedicura,
    required this.limpiezaDental,
    required this.limpiezaGlandulas,
    required this.eliminacionPulgas,
    required this.tratamiento,
    required this.indicacionesEspeciales,
    required this.horaEntrega,
    required this.consentimiento,
    required this.fechaProximaVisita,
    required this.horaProximaVisita,
    required this.encargadoId,
  });

  factory ServiciosEsteticos.fromJson(String str) => ServiciosEsteticos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ServiciosEsteticos.fromMap(Map<String, dynamic> json) => ServiciosEsteticos(
        pedidosEspeciales: json["pedidosEspeciales"],
        cortePelo: json["cortePelo"],
        mascotaDificil: json["mascotaDificil"],
        baoCompleto: json["bañoCompleto"],
        limpiezaOidos: json["limpiezaOidos"],
        pedicura: json["pedicura"],
        limpiezaDental: json["limpiezaDental"],
        limpiezaGlandulas: json["limpiezaGlandulas"],
        eliminacionPulgas: json["eliminacionPulgas"],
        tratamiento: json["tratamiento"],
        indicacionesEspeciales: json["indicaciones_especiales"],
        horaEntrega: json["hora_entrega"],
        consentimiento: json["consentimiento"],
        fechaProximaVisita: DateTime.parse(json["fecha_proxima_visita"]),
        horaProximaVisita: json["hora_proxima_visita"],
        encargadoId: List<String>.from(json["encargado_id"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "pedidosEspeciales": pedidosEspeciales,
        "cortePelo": cortePelo,
        "mascotaDificil": mascotaDificil,
        "bañoCompleto": baoCompleto,
        "limpiezaOidos": limpiezaOidos,
        "pedicura": pedicura,
        "limpiezaDental": limpiezaDental,
        "limpiezaGlandulas": limpiezaGlandulas,
        "eliminacionPulgas": eliminacionPulgas,
        "tratamiento": tratamiento,
        "indicaciones_especiales": indicacionesEspeciales,
        "hora_entrega": horaEntrega,
        "consentimiento": consentimiento,
        "fecha_proxima_visita": fechaProximaVisita,
        "hora_proxima_visita": horaProximaVisita,
        "encargado_id": List<dynamic>.from(encargadoId.map((x) => x)),
      };
}
