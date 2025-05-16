import 'dart:convert';

class RespuestaModel<T> {
  bool error;
  int code;
  String message;
  T data;

  RespuestaModel({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory RespuestaModel.fromJson(String str) => RespuestaModel.fromMap(json.decode(str));

  factory RespuestaModel.fromMap(Map<String, dynamic> json) => RespuestaModel(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: json["data"],
      );
}
