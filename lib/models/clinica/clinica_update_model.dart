import 'dart:convert';

class ClinicaUpdateModel {
  bool error;
  int code;
  String message;
  Data data;

  ClinicaUpdateModel({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ClinicaUpdateModel.fromJson(String str) =>
      ClinicaUpdateModel.fromMap(
          json.decode(utf8.decode(str.runes.toList())));

  String toJson() => json.encode(toMap());

  factory ClinicaUpdateModel.fromMap(
          Map<String, dynamic> json) =>
      ClinicaUpdateModel(
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
  ProximaVisita proximaVisita;
  DatosClinicos? datosClinicos;
  PeticionesMuestras? peticionesMuestras;
  Diagnostico? diagnostico;
  List<Tratamiento>? tratamientos;
  String? recomendacionTratamiento;
  List<Archivo>? archivo;
  List<Parametrica>? parametrica;
  Cirugia? cirugia;
  Vacuna? vacuna;
  Desparacitacion? desparacitacion;
  Hospitalizacion? hospitalizacion;

  Data({
    required this.propietario,
    required this.paciente,
    required this.proximaVisita,
    this.datosClinicos,
    this.peticionesMuestras,
    this.diagnostico,
    this.tratamientos,
    this.recomendacionTratamiento,
    this.archivo,
    this.parametrica,
    this.cirugia,
    this.vacuna,
    this.desparacitacion,
    this.hospitalizacion,
  });

  factory Data.fromJson(String str) =>
      Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        propietario:
            Propietario.fromMap(json["propietario"]),
        paciente: Paciente.fromMap(json["paciente"]),
        proximaVisita:
            ProximaVisita.fromMap(json["proxima_visita"]),
        datosClinicos: json["datos_clinicos"] == null
            ? null
            : DatosClinicos.fromMap(json["datos_clinicos"]),
        peticionesMuestras:
            json["peticiones_muestras"] == null
                ? null
                : PeticionesMuestras.fromMap(
                    json["peticiones_muestras"]),
        diagnostico: json["diagnostico"] == null
            ? null
            : Diagnostico.fromMap(json["diagnostico"]),
        recomendacionTratamiento: json["recomendacion_tratamiento"] ?? '',
        tratamientos: json["tratamientos"] == null
            ? []
            : List<Tratamiento>.from(json["tratamientos"]!
                .map((x) => Tratamiento.fromMap(x))),
        archivo: json["archivo"] == null
            ? []
            : List<Archivo>.from(json["archivo"]!
                .map((x) => Archivo.fromMap(x))),
        parametrica: json["parametrica"] == null
            ? []
            : List<Parametrica>.from(json["parametrica"]!
                .map((x) => Parametrica.fromMap(x))),
        cirugia: json["cirugia"] == null
            ? null
            : Cirugia.fromMap(json["cirugia"]),
        vacuna: json["vacuna"] == null
            ? null
            : Vacuna.fromMap(json["vacuna"]),
        desparacitacion: json["desparacitacion"] == null
            ? null
            : Desparacitacion.fromMap(
                json["desparacitacion"]),
        hospitalizacion: json["hospitalizacion"] == null
            ? null
            : Hospitalizacion.fromMap(
                json["hospitalizacion"]),
      );

  Map<String, dynamic> toMap() => {
        "propietario": propietario.toMap(),
        "paciente": paciente.toMap(),
        "proxima_visita": proximaVisita.toMap(),
        "datos_clinicos": datosClinicos?.toMap(),
        "peticiones_muestras": peticionesMuestras?.toMap(),
        "diagnostico": diagnostico?.toMap(),
        "tratamientos": tratamientos == null
            ? []
            : List<dynamic>.from(
                tratamientos!.map((x) => x.toMap())),
        "archivo": archivo == null
            ? []
            : List<dynamic>.from(
                archivo!.map((x) => x.toMap())),
        "parametrica": parametrica == null
            ? []
            : List<dynamic>.from(
                parametrica!.map((x) => x.toMap())),
        "cirugia": cirugia?.toMap(),
        "vacuna": vacuna?.toMap(),
        "desparacitacion": desparacitacion?.toMap(),
      };
}

class Archivo {
  String? fotoPaciente;
  int? archivoId;
  String? tipo;
  String? archivo;
  String? autorizacionQuirurgica;
  List<String>? avancesPostOperatorios;
  String? vacuna;
  String? desparacitacion;

  Archivo({
    this.fotoPaciente,
    this.archivoId,
    this.tipo,
    this.archivo,
    this.autorizacionQuirurgica,
    this.avancesPostOperatorios,
    this.vacuna,
    this.desparacitacion,
  });

  factory Archivo.fromJson(String str) =>
      Archivo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Archivo.fromMap(Map<String, dynamic> json) =>
      Archivo(
        fotoPaciente: json["foto_paciente"],
        archivoId: json["archivo_id"],
        tipo: json["tipo"],
        archivo: json["archivo"],
        autorizacionQuirurgica:
            json["autorizacionQuirurgica"],
        avancesPostOperatorios:
            json["avancesPostOperatorios"] != null
                ? List<String>.from(
                    json["avancesPostOperatorios"])
                : null,
        vacuna: json["vacuna"],
        desparacitacion: json["desparacitacion"],
      );

  Map<String, dynamic> toMap() => {
        "foto_paciente": fotoPaciente,
        "archivo_id": archivoId,
        "tipo": tipo,
        "archivo": archivo,
        "autorizacionQuirurgica": autorizacionQuirurgica,
        "avancesPostOperatorios": avancesPostOperatorios,
        "vacuna": vacuna,
        "desparacitacion": desparacitacion,
      };
}

class Cirugia {
  int fichaCirugiaId;
  String tipoCirugia;
  String anestesicos;
  String observacionesPrecirugia;
  String postOperatorio;

  Cirugia({
    required this.fichaCirugiaId,
    required this.tipoCirugia,
    required this.anestesicos,
    required this.observacionesPrecirugia,
    required this.postOperatorio,
  });

  factory Cirugia.fromJson(String str) =>
      Cirugia.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Cirugia.fromMap(Map<String, dynamic> json) =>
      Cirugia(
        fichaCirugiaId: json["ficha_cirugia_id"],
        tipoCirugia: json["tipoCirugia"],
        anestesicos: json["anestesicos"],
        observacionesPrecirugia:
            json["observacionesPrecirugia"],
        postOperatorio: json["postOperatorio"],
      );

  Map<String, dynamic> toMap() => {
        "ficha_cirugia_id": fichaCirugiaId,
        "tipoCirugia": tipoCirugia,
        "anestesicos": anestesicos,
        "observacionesPrecirugia": observacionesPrecirugia,
        "postOperatorio": postOperatorio,
      };
}

class DatosClinicos {
  int fichaDatosClinicosId;
  String mucosas;
  String peso;
  String temperatura;
  String frecuenciaCardiaca;
  String frecuenciaRespiratoria;
  String hidratacion;
  String gangliosLinfaticos;
  String lesiones;
  String tiempoTenencia;
  String otroAnimal;
  String origenMascota;
  String enfermedadesPadecidas;
  String enfermedadesRecientes;
  String enferemedadTratamiento;
  String vacunasAldia;
  String reaccionAlergica;
  String? procedimiento;
  String? procedimientoArchivo;

  DatosClinicos({
    required this.fichaDatosClinicosId,
    required this.mucosas,
    required this.peso,
    required this.temperatura,
    required this.frecuenciaCardiaca,
    required this.frecuenciaRespiratoria,
    required this.hidratacion,
    required this.gangliosLinfaticos,
    required this.lesiones,
    required this.tiempoTenencia,
    required this.otroAnimal,
    required this.origenMascota,
    required this.enfermedadesPadecidas,
    required this.enfermedadesRecientes,
    required this.enferemedadTratamiento,
    required this.vacunasAldia,
    required this.reaccionAlergica,
    this.procedimiento,
    this.procedimientoArchivo,
  });

  factory DatosClinicos.fromJson(String str) =>
      DatosClinicos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DatosClinicos.fromMap(
          Map<String, dynamic> json) =>
      DatosClinicos(
        fichaDatosClinicosId:
            json["ficha_datos_clinicos_id"],
        mucosas: json["mucosas"],
        peso: json["peso"],
        temperatura: json["temperatura"],
        frecuenciaCardiaca: json["frecuencia_cardiaca"],
        frecuenciaRespiratoria:
            json["frecuencia_respiratoria"],
        hidratacion: json["hidratacion"],
        gangliosLinfaticos: json["ganglios_linfaticos"],
        lesiones: json["lesiones"],
        tiempoTenencia: json["tiempoTenencia"],
        otroAnimal: json["otroAnimal"],
        origenMascota: json["origenMascota"],
        enfermedadesPadecidas:
            json["enfermedadesPadecidas"],
        enfermedadesRecientes:
            json["enfermedadesRecientes"],
        enferemedadTratamiento:
            json["enferemedadTratamiento"],
        vacunasAldia: json["vacunasAldia"],
        reaccionAlergica: json["reaccionAlergica"],
        procedimiento: json["procedimiento"],
        procedimientoArchivo: json["procedimiento_archivo"],
      );

  Map<String, dynamic> toMap() => {
        "ficha_datos_clinicos_id": fichaDatosClinicosId,
        "mucosas": mucosas,
        "peso": peso,
        "temperatura": temperatura,
        "frecuencia_cardiaca": frecuenciaCardiaca,
        "frecuencia_respiratoria": frecuenciaRespiratoria,
        "hidratacion": hidratacion,
        "ganglios_linfaticos": gangliosLinfaticos,
        "lesiones": lesiones,
        "tiempoTenencia": tiempoTenencia,
        "otroAnimal": otroAnimal,
        "origenMascota": origenMascota,
        "enfermedadesPadecidas": enfermedadesPadecidas,
        "enfermedadesRecientes": enfermedadesRecientes,
        "enferemedadTratamiento": enferemedadTratamiento,
        "vacunasAldia": vacunasAldia,
        "reaccionAlergica": reaccionAlergica,
        "procedimiento": procedimiento,
        "procedimiento_archivo": procedimientoArchivo,
      };
}

class Desparacitacion {
  int fichaDesparacitacionId;
  String tipo;
  String producto;
  String principioActivo;
  DateTime fechaAplicacion;
  String via;

  Desparacitacion({
    required this.fichaDesparacitacionId,
    required this.tipo,
    required this.producto,
    required this.principioActivo,
    required this.fechaAplicacion,
    required this.via,
  });

  factory Desparacitacion.fromJson(String str) =>
      Desparacitacion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Desparacitacion.fromMap(
          Map<String, dynamic> json) =>
      Desparacitacion(
        fichaDesparacitacionId:
            json["ficha_desparacitacion_id"],
        tipo: json["tipo"],
        producto: json["producto"],
        principioActivo: json["principioActivo"],
        fechaAplicacion:
            DateTime.parse(json["fechaAplicacion"]),
        via: json["via"],
      );

  Map<String, dynamic> toMap() => {
        "ficha_desparacitacion_id": fichaDesparacitacionId,
        "tipo": tipo,
        "producto": producto,
        "principioActivo": principioActivo,
        "fechaAplicacion":
            "${fechaAplicacion.year.toString().padLeft(4, '0')}-${fechaAplicacion.month.toString().padLeft(2, '0')}-${fechaAplicacion.day.toString().padLeft(2, '0')}",
        "via": via,
      };
}

class Diagnostico {
  String listaProblemas;
  String diagnostico;
  String diagnosticoDiferencial;

  Diagnostico({
    required this.listaProblemas,
    required this.diagnostico,
    required this.diagnosticoDiferencial,
  });

  factory Diagnostico.fromJson(String str) =>
      Diagnostico.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Diagnostico.fromMap(Map<String, dynamic> json) =>
      Diagnostico(
        listaProblemas: json["listaProblemas"],
        diagnostico: json["diagnostico"],
        diagnosticoDiferencial:
            json["diagnosticoDiferencial"],
      );

  Map<String, dynamic> toMap() => {
        "listaProblemas": listaProblemas,
        "diagnostico": diagnostico,
        "diagnosticoDiferencial": diagnosticoDiferencial,
      };
}

class Paciente {
  int pacienteId;
  String nombre;
  String sexo;
  String edad;
  String tipoEdad;
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
    required this.tipoEdad,
    required this.especieId,
    required this.razaId,
    required this.tamao,
    required this.temperamento,
    required this.alimentacion,
  });

  factory Paciente.fromJson(String str) =>
      Paciente.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Paciente.fromMap(Map<String, dynamic> json) =>
      Paciente(
        pacienteId: json["paciente_id"],
        nombre: json["nombre"],
        sexo: json["sexo"],
        edad: json["edad"],
        tipoEdad: json["tipo_edad"],
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
        "tipo_edad": tipoEdad,
        "especie_id": especieId,
        "raza_id": razaId,
        "tamaño": tamao,
        "temperamento": temperamento,
        "alimentacion": alimentacion,
      };
}

class Parametrica {
  int fichaClinicaRespuestasId;
  int tipoFichaParametricaId;
  int tipoFichaParametricaPreguntasId;
  String respuesta;

  Parametrica({
    required this.fichaClinicaRespuestasId,
    required this.tipoFichaParametricaId,
    required this.tipoFichaParametricaPreguntasId,
    required this.respuesta,
  });

  factory Parametrica.fromJson(String str) =>
      Parametrica.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Parametrica.fromMap(Map<String, dynamic> json) =>
      Parametrica(
        fichaClinicaRespuestasId:
            json["ficha_clinica_respuestas_id"],
        tipoFichaParametricaId:
            json["tipo_ficha_parametrica_id"],
        tipoFichaParametricaPreguntasId:
            json["tipo_ficha_parametrica_preguntas_id"],
        respuesta: json["respuesta"],
      );

  Map<String, dynamic> toMap() => {
        "ficha_clinica_respuestas_id":
            fichaClinicaRespuestasId,
        "tipo_ficha_parametrica_id": tipoFichaParametricaId,
        "tipo_ficha_parametrica_preguntas_id":
            tipoFichaParametricaPreguntasId,
        "respuesta": respuesta,
      };
}

class PeticionesMuestras {
  String muestrasRequeridas;
  String pruebasRequeridas;

  PeticionesMuestras({
    required this.muestrasRequeridas,
    required this.pruebasRequeridas,
  });

  factory PeticionesMuestras.fromJson(String str) =>
      PeticionesMuestras.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PeticionesMuestras.fromMap(
          Map<String, dynamic> json) =>
      PeticionesMuestras(
        muestrasRequeridas: json["muestrasRequeridas"],
        pruebasRequeridas: json["pruebasRequeridas"],
      );

  Map<String, dynamic> toMap() => {
        "muestrasRequeridas": muestrasRequeridas,
        "pruebasRequeridas": pruebasRequeridas,
      };
}

class Propietario {
  int propietarioId;
  String ci;
  String nombres;
  String apellidos;
  String celular;
  String direccion;
  String documento;

  Propietario({
    required this.propietarioId,
    required this.ci,
    required this.nombres,
    required this.apellidos,
    required this.celular,
    required this.direccion,
    required this.documento,
  });

  factory Propietario.fromJson(String str) =>
      Propietario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Propietario.fromMap(Map<String, dynamic> json) =>
      Propietario(
        propietarioId: json["propietario_id"],
        ci: json["documento"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        celular: json["celular"],
        direccion: json["direccion"],
        documento: json["documento"],
      );

  Map<String, dynamic> toMap() => {
        "propietario_id": propietarioId,
        "ci": ci,
        "nombres": nombres,
        "apellidos": apellidos,
        "celular": celular,
        "direccion": direccion,
        "documento": documento,
      };
}

class ProximaVisita {
  DateTime fecha;
  String hora;
  int encargadoId;

  ProximaVisita({
    required this.fecha,
    required this.hora,
    required this.encargadoId,
  });

  factory ProximaVisita.fromJson(String str) =>
      ProximaVisita.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProximaVisita.fromMap(
          Map<String, dynamic> json) =>
      ProximaVisita(
        fecha: DateTime.parse(json["fecha"]),
        hora: json["hora"],
        encargadoId: json["encargado_id"],
      );

  Map<String, dynamic> toMap() => {
        "fecha":
            "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "hora": hora,
        "encargado_id": encargadoId,
      };
}

class Tratamiento {
  int fichaTratamientoId;
  String descripcion;

  Tratamiento({
    required this.fichaTratamientoId,
    required this.descripcion,
  });

  factory Tratamiento.fromJson(String str) =>
      Tratamiento.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tratamiento.fromMap(Map<String, dynamic> json) =>
      Tratamiento(
        fichaTratamientoId: json["ficha_tratamiento_id"],
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toMap() => {
        "ficha_tratamiento_id": fichaTratamientoId,
        "descripcion": descripcion,
      };
}

class Vacuna {
  int fichaVacunaId;
  String contra;
  String laboratorio;
  String serie;
  String procedencia;
  DateTime fechaExpiracion;

  Vacuna({
    required this.fichaVacunaId,
    required this.contra,
    required this.laboratorio,
    required this.serie,
    required this.procedencia,
    required this.fechaExpiracion,
  });

  factory Vacuna.fromJson(String str) =>
      Vacuna.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Vacuna.fromMap(Map<String, dynamic> json) =>
      Vacuna(
        fichaVacunaId: json["ficha_vacuna_id"],
        contra: json["contra"],
        laboratorio: json["laboratorio"],
        serie: json["serie"],
        procedencia: json["procedencia"],
        fechaExpiracion:
            DateTime.parse(json["fechaExpiracion"]),
      );

  Map<String, dynamic> toMap() => {
        "ficha_vacuna_id": fichaVacunaId,
        "contra": contra,
        "laboratorio": laboratorio,
        "serie": serie,
        "procedencia": procedencia,
        "fechaExpiracion":
            "${fechaExpiracion.year.toString().padLeft(4, '0')}-${fechaExpiracion.month.toString().padLeft(2, '0')}-${fechaExpiracion.day.toString().padLeft(2, '0')}",
      };
}

class Hospitalizacion {
  DateTime inicio;
  DateTime fin;
  String alimentacion;
  String tipoIntervalo;
  String intervalo;

  Hospitalizacion({
    required this.inicio,
    required this.fin,
    required this.alimentacion,
    required this.tipoIntervalo,
    required this.intervalo,
  });

  factory Hospitalizacion.fromJson(String str) =>
      Hospitalizacion.fromMap(json.decode(str));

  factory Hospitalizacion.fromMap(
          Map<String, dynamic> json) =>
      Hospitalizacion(
        inicio: DateTime.parse(json["inicio"]),
        fin: DateTime.parse(json["fin"]),
        alimentacion: json["alimentacion"],
        tipoIntervalo: json["tipo_intervalo"],
        intervalo: json["intervalo"],
      );
}
