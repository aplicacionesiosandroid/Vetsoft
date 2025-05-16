import 'dart:convert';

class User {
    InformacionPersonal informacionPersonal;
    InformacionAdicional informacionAdicional;

    User({
        required this.informacionPersonal,
        required this.informacionAdicional,
    });

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory User.fromJson(Map<String, dynamic> json) => User(
        informacionPersonal: InformacionPersonal.fromJson(json["informacion_personal"]),
        informacionAdicional: InformacionAdicional.fromJson(json["informacion_adicional"]),
    );

    Map<String, dynamic> toJson() => {
        "informacion_personal": informacionPersonal.toJson(),
        "informacion_adicional": informacionAdicional.toJson(),
    };
}

class InformacionAdicional {
    String grupoSanguineo;
    String alergias;
    ReferenciaEmergencia referenciaEmergencia;
    Formacion? formacion;

    InformacionAdicional({
        required this.grupoSanguineo,
        required this.alergias,
        required this.referenciaEmergencia,
        required this.formacion,
    });

    factory InformacionAdicional.fromRawJson(String str) => InformacionAdicional.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory InformacionAdicional.fromJson(Map<String, dynamic> json) => InformacionAdicional(
        grupoSanguineo: json["grupo_sanguineo"],
        alergias: json["alergias"],
        referenciaEmergencia: ReferenciaEmergencia.fromJson(json["referencia_emergencia"]),
        formacion: Formacion.fromJson(json["formacion"]),
    );

    Map<String, dynamic> toJson() => {
        "grupo_sanguineo": grupoSanguineo,
        "alergias": alergias,
        "referencia_emergencia": referenciaEmergencia.toJson(),
        "formacion": formacion?.toJson() ?? null,
    };
}

class Formacion {
    String cv;
    List<String> titulosDiplomas;

    Formacion({
        required this.cv,
        required this.titulosDiplomas,
    });

    factory Formacion.fromRawJson(String str) => Formacion.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Formacion.fromJson(Map<String, dynamic> json) => Formacion(
        cv: json["cv"],
        titulosDiplomas: List<String>.from(json["titulos_diplomas"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "cv": cv,
        "titulos_diplomas": List<dynamic>.from(titulosDiplomas.map((x) => x)),
    };
}

class ReferenciaEmergencia {
    String nombres;
    String apellidos;
    String celular;
    String parentesco;

    ReferenciaEmergencia({
        required this.nombres,
        required this.apellidos,
        required this.celular,
        required this.parentesco,
    });

    factory ReferenciaEmergencia.fromRawJson(String str) => ReferenciaEmergencia.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ReferenciaEmergencia.fromJson(Map<String, dynamic> json) => ReferenciaEmergencia(
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        celular: json["celuar"],
        parentesco: json["parentesco"],
    );

    Map<String, dynamic> toJson() => {
        "nombres": nombres,
        "apellidos": apellidos,
        "celuar": celular,
        "parentesco": parentesco,
    };
}

class InformacionPersonal {
    String email;
    String password;
    String nombres;
    String apellidos;
    String telefono;
    String fechaNacimiento;
    String paisNacimiento;
    String ciudadNacimiento;
    String numIdentificacion;
    String sexo;
    String estadoCivil;
    String direccion;
    String altura;
    String paisResidencia;
    String ciudadResidencia;

    InformacionPersonal({
        required this.email,
        required this.password,
        required this.nombres,
        required this.apellidos,
        required this.telefono,
        required this.fechaNacimiento,
        required this.paisNacimiento,
        required this.ciudadNacimiento,
        required this.numIdentificacion,
        required this.sexo,
        required this.estadoCivil,
        required this.direccion,
        required this.altura,
        required this.paisResidencia,
        required this.ciudadResidencia,
    });

    factory InformacionPersonal.fromRawJson(String str) => InformacionPersonal.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    String informacionPersonalToJson(InformacionPersonal info) {
      return json.encode(info.toJson());
    }

    factory InformacionPersonal.fromJson(Map<String, dynamic> json) => InformacionPersonal(
        email: json["email"],
        password: json["password"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        telefono: json["telefono"],
        fechaNacimiento: json["fecha_nacimiento"],
        paisNacimiento: json["pais_nacimiento"],
        ciudadNacimiento: json["ciudad_nacimiento"],
        numIdentificacion: json["num_identificacion"],
        sexo: json["sexo"],
        estadoCivil: json["estado_civil"],
        direccion: json["direccion"],
        altura: json["altura"],
        paisResidencia: json["pais_residencia"],
        ciudadResidencia: json["ciudad_residencia"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "nombres": nombres,
        "apellidos": apellidos,
        "telefono": telefono,
        "fecha_nacimiento": fechaNacimiento,
        "pais_nacimiento": paisNacimiento,
        "ciudad_nacimiento": ciudadNacimiento,
        "num_identificacion": numIdentificacion,
        "sexo": sexo,
        "estado_civil": estadoCivil,
        "direccion": direccion,
        "altura": altura,
        "pais_residencia": paisResidencia,
        "ciudad_residencia": ciudadResidencia,
    };
}
