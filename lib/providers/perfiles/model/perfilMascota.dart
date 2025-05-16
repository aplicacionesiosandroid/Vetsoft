class PerfilMascota {
  final int pacienteId;
  final int propietarioId;
  final String? fotoPropietario;
  final String nombrePaciente;
  final String edadPaciente;
  final String tipoEspecie;
  final String tipoRaza;
  final String? fotoPaciente;
  final List<Consulta?> consultas;
  final List<Peluqueria?> peluquerias;

  PerfilMascota({
    required this.pacienteId,
    required this.propietarioId,
    this.fotoPropietario,
    required this.nombrePaciente,
    required this.edadPaciente,
    required this.tipoEspecie,
    required this.tipoRaza,
    this.fotoPaciente,
    required this.consultas,
    required this.peluquerias,
  });

  factory PerfilMascota.fromJson(Map<String, dynamic> json) {
    return PerfilMascota(
      pacienteId: json['paciente_id'],
      propietarioId: json['propietario_id'],
      fotoPropietario: json['foto_propietario'],
      nombrePaciente: json['nombre_paciente'],
      edadPaciente: json['edad_paciente'],
      tipoEspecie: json['tipo_especie'],
      tipoRaza: json['tipo_raza'],
      fotoPaciente: json['foto_paciente'],
      consultas: (json['consulta'] as List)
          .map((consultaJson) => Consulta.fromJson(consultaJson))
          .toList(),
      peluquerias: (json['peluqueria'] as List)
          .map((peluqueriaJson) => Peluqueria.fromJson(peluqueriaJson))
          .toList(),
    );
  }
}

class Consulta {
  final int fichaClinicaId;
  final String fechaRevision;
  final String horaRevision;
  final String tipoAtencion;
  final String tipoFicha;
  final String nombresEncargado;
  final String apellidosEncargado;

  Consulta({
    required this.fichaClinicaId,
    required this.fechaRevision,
    required this.horaRevision,
    required this.tipoAtencion,
    required this.tipoFicha,
    required this.nombresEncargado,
    required this.apellidosEncargado,
  });

  factory Consulta.fromJson(Map<String, dynamic> json) {
    return Consulta(
      fichaClinicaId: json['ficha_clinica_id'],
      fechaRevision: json['fecha_revision'],
      horaRevision: json['hora_revision'],
      tipoAtencion: json['tipo_atencion'],
      tipoFicha: json['tipo_ficha'],
      nombresEncargado: json['nombres_encargado'],
      apellidosEncargado: json['apellidos_encargado'],
    );
  }
}

class Peluqueria {
  final int fichaPeluqueriaId;
  final String tipoAtencion;
  final String fechaProximaVisita;
  final String? horaInicio;
  final List<Encargado?> encargados;

  Peluqueria({
    required this.fichaPeluqueriaId,
    required this.tipoAtencion,
    required this.fechaProximaVisita,
    this.horaInicio,
    required this.encargados,
  });

  factory Peluqueria.fromJson(Map<String, dynamic> json) {
    return Peluqueria(
      fichaPeluqueriaId: json['ficha_peluqueria_id'],
      tipoAtencion: json['tipo_atencion'],
      fechaProximaVisita: json['fecha_proxima_visita'],
      horaInicio: json['hora_inicio'],
      encargados: (json['encargadors'] as List)
          .map((encargadoJson) => Encargado.fromJson(encargadoJson))
          .toList(),
    );
  }
}

class Encargado {
  final String nombres;
  final String apellidos;

  Encargado({
    required this.nombres,
    required this.apellidos,
  });

  factory Encargado.fromJson(Map<String, dynamic> json) {
    return Encargado(
      nombres: json['nombres'],
      apellidos: json['apellidos'],
    );
  }
}
