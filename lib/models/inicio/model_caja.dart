import 'dart:convert';

class ModelCaja {
  bool error;
  int code;
  String message;
  Data data;

  ModelCaja({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ModelCaja.fromJson(String str) => ModelCaja.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ModelCaja.fromMap(Map<String, dynamic> json) => ModelCaja(
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
  String estadoCaja;

  Data({
    required this.estadoCaja,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        estadoCaja: json["estado_caja"],
      );

  Map<String, dynamic> toMap() => {
        "estado_caja": estadoCaja,
      };
}

class ModelDetalleCaja {
  bool error;
  int code;
  String message;
  DataCajaDetalle data;

  ModelDetalleCaja({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ModelDetalleCaja.fromJson(String str) =>
      ModelDetalleCaja.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ModelDetalleCaja.fromMap(Map<String, dynamic> json) => ModelDetalleCaja(
    error: json["error"],
    code: json["code"],
    message: json["message"],
    data: DataCajaDetalle.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "error": error,
    "code": code,
    "message": message,
    "data": data.toMap(),
  };
}

class DataCajaDetalle {
  List<CajaDetalle> estaSemana;
  List<CajaDetalle> esteMes;
  List<CajaDetalle> anteriores;

  DataCajaDetalle({
    required this.estaSemana,
    required this.esteMes,
    required this.anteriores,
  });

  factory DataCajaDetalle.fromJson(String str) => DataCajaDetalle.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataCajaDetalle.fromMap(Map<String, dynamic> json) => DataCajaDetalle(
    estaSemana: List<CajaDetalle>.from(json["esta_semana"].map((x) => CajaDetalle.fromMap(x))),
    esteMes: List<CajaDetalle>.from(json["este_mes"].map((x) => CajaDetalle.fromMap(x))),
    anteriores: List<CajaDetalle>.from(json["anteriores"].map((x) => CajaDetalle.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "esta_semana": List<dynamic>.from(estaSemana.map((x) => x.toMap())),
    "este_mes": List<dynamic>.from(esteMes.map((x) => x.toMap())),
    "anteriores": List<dynamic>.from(anteriores.map((x) => x.toMap())),
  };
}

class CajaDetalle {
  String fechaCaja;
  String detalle;

  CajaDetalle({
    required this.fechaCaja,
    required this.detalle,
  });

  factory CajaDetalle.fromJson(String str) => CajaDetalle.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CajaDetalle.fromMap(Map<String, dynamic> json) => CajaDetalle(
    fechaCaja: json["fecha_caja"],
    detalle: json["detalle"],
  );

  Map<String, dynamic> toMap() => {
    "fecha_caja": fechaCaja,
    "detalle": detalle,
  };
}
