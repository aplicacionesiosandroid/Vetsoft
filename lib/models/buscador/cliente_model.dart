class ClienteResponse {
  final bool error;
  final int code;
  final String message;
  final List<ClienteData> data;

  ClienteResponse({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ClienteResponse.fromJson(Map<String, dynamic> json) {
    return ClienteResponse(
      error: json['error'],
      code: json['code'],
      message: json['message'],
      data: List<ClienteData>.from(json['data'].map((item) => ClienteData.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'code': code,
      'message': message,
      'data': List<dynamic>.from(data.map((item) => item.toJson())),
    };
  }
}

class ClienteData {
  final String fotoPropietario;
  final String nombresPropietario;
  final String apellidosPropietario;
  final String telefonoCelular;
  final String direccion;
  final String nit;
  final int cliente;
  final List<PetData> mascotas;

  ClienteData({
    required this.fotoPropietario,
    required this.nombresPropietario,
    required this.apellidosPropietario,
    required this.telefonoCelular,
    required this.direccion,
    required this.nit,
    required this.cliente,
    required this.mascotas,
  });

  factory ClienteData.fromJson(Map<String, dynamic> json) {
    return ClienteData(
      fotoPropietario: json['foto_propietario'],
      nombresPropietario: json['nombres_propietario'],
      apellidosPropietario: json['apellidos_propietario'],
      telefonoCelular: json['telefono_celular'],
      direccion: json['direccion'],
      nit: json['nit'],
      cliente: json['cliente'],
      mascotas: List<PetData>.from(json['mascotas'].map((item) => PetData.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foto_propietario': fotoPropietario,
      'nombres_propietario': nombresPropietario,
      'apellidos_propietario': apellidosPropietario,
      'telefono_celular': telefonoCelular,
      'direccion': direccion,
      'nit': nit,
      'cliente': cliente,
      'mascotas': List<dynamic>.from(mascotas.map((item) => item.toJson())),
    };
  }
}

class PetData {
  final int pacienteId;
  final String fotoPaciente;

  PetData({
    required this.pacienteId,
    required this.fotoPaciente,
  });

  factory PetData.fromJson(Map<String, dynamic> json) {
    return PetData(
      pacienteId: json['paciente_id'],
      fotoPaciente: json['foto_paciente'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paciente_id': pacienteId,
      'foto_paciente': fotoPaciente,
    };
  }
}
