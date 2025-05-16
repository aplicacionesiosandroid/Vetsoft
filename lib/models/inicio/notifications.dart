import 'dart:convert';

class ModelNotifications {
  bool error;
  int code;
  String message;
  List<NotificationData> data;

  ModelNotifications({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ModelNotifications.fromJson(String str) => ModelNotifications.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ModelNotifications.fromMap(Map<String, dynamic> json) => ModelNotifications(
    error: json["error"],
    code: json["code"],
    message: json["message"],
    data: List<NotificationData>.from(json["data"].map((x) => NotificationData.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "error": error,
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class NotificationData {
  int notificacionID;
  String mensaje;
  String imagen;
  String creadoTiempo;

  NotificationData({
    required this.notificacionID,
    required this.mensaje,
    required this.imagen,
    required this.creadoTiempo,
  });

  factory NotificationData.fromJson(String str) => NotificationData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationData.fromMap(Map<String, dynamic> json) => NotificationData(
    notificacionID: json["notificacion_id"],
    mensaje: json["mensaje"],
    imagen: json["imagen"],
    creadoTiempo: json["creado_tiempo"],
  );

  Map<String, dynamic> toMap() => {
    "notificacion_id": notificacionID,
    "mensaje": mensaje,
    "imagen": imagen,
    "creado_tiempo": creadoTiempo,
  };
}
