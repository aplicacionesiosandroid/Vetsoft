import 'dart:convert';

class ApiResponseGeneral<T> {
  final bool error;
  final int code;
  final String message;
  final T data;

  ApiResponseGeneral({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ApiResponseGeneral.fromRawJson(String str, T Function(Map<String, dynamic>) fromJsonT) =>
      ApiResponseGeneral.fromJson(json.decode(str), fromJsonT);

  String toRawJson(T Function(dynamic) toJsonT) => json.encode(toJson(toJsonT));

  factory ApiResponseGeneral.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) => ApiResponseGeneral(
    error: json["error"],
    code: json["code"],
    message: json["message"],
    data: fromJsonT(json["data"]),
  );

  Map<String, dynamic> toJson(T Function(dynamic) toJsonT) => {
    "error": error,
    "code": code,
    "message": message,
    "data": toJsonT(data),
  };
}

