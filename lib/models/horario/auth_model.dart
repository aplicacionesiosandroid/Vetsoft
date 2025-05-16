import 'dart:convert';

class AuthModel {
  Headers headers;
  Original original;
  String? exception;

  AuthModel({
    required this.headers,
    required this.original,
    required this.exception,
  });

  factory AuthModel.fromJson(String str) => AuthModel.fromMap(json.decode(str));

  factory AuthModel.fromMap(Map<String, dynamic> json) => AuthModel(
        headers: Headers.fromMap(json["headers"]),
        original: Original.fromMap(json["original"]),
        exception: json["exception"],
      );
}

class Headers {
  Headers();

  factory Headers.fromJson(String str) => Headers.fromMap(json.decode(str));

  factory Headers.fromMap(Map<String, dynamic> json) => Headers();
}

class Original {
  String accessToken;
  String tokenType;
  User user;
  int expiresIn;

  Original({
    required this.accessToken,
    required this.tokenType,
    required this.user,
    required this.expiresIn,
  });

  factory Original.fromJson(String str) => Original.fromMap(json.decode(str));

  factory Original.fromMap(Map<String, dynamic> json) => Original(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        user: User.fromMap(json["user"]),
        expiresIn: json["expires_in"],
      );
}

class User {
  int id;
  String username;
  String email;
  String? unconfirmedEmail;
  String? registrationIp;
  int confirmedAt;
  String? blockedAt;
  int updatedAt;
  int createdAt;
  int lastLoginAt;
  String lastLoginIp;
  String? authTfKey;
  int authTfEnabled;
  int passwordChangedAt;
  int gdprConsent;
  String? gdprConsentDate;
  int gdprDeleted;
  DateTime fecha;
  int intentos;
  String nombres;
  String apellidos;
  int clienteId;
  String? imagenUser;
  Configuraciones configuraciones;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.unconfirmedEmail,
    required this.registrationIp,
    required this.confirmedAt,
    required this.blockedAt,
    required this.updatedAt,
    required this.createdAt,
    required this.lastLoginAt,
    required this.lastLoginIp,
    required this.authTfKey,
    required this.authTfEnabled,
    required this.passwordChangedAt,
    required this.gdprConsent,
    required this.gdprConsentDate,
    required this.gdprDeleted,
    required this.fecha,
    required this.intentos,
    required this.nombres,
    required this.apellidos,
    required this.clienteId,
    required this.imagenUser,
    required this.configuraciones,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        unconfirmedEmail: json["unconfirmed_email"],
        registrationIp: json["registration_ip"],
        confirmedAt: json["confirmed_at"],
        blockedAt: json["blocked_at"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        lastLoginAt: json["last_login_at"],
        lastLoginIp: json["last_login_ip"],
        authTfKey: json["auth_tf_key"],
        authTfEnabled: json["auth_tf_enabled"],
        passwordChangedAt: json["password_changed_at"],
        gdprConsent: json["gdpr_consent"],
        gdprConsentDate: json["gdpr_consent_date"],
        gdprDeleted: json["gdpr_deleted"],
        fecha: DateTime.parse(json["fecha"]),
        intentos: json["intentos"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        clienteId: json["cliente_id"],
        imagenUser: json["imagen_user"],
        configuraciones: Configuraciones.fromMap(json["configuraciones"]),
      );
}

class Configuraciones {
  String fichaParametrica;

  Configuraciones({
    required this.fichaParametrica,
  });

  factory Configuraciones.fromJson(String str) => Configuraciones.fromMap(json.decode(str));

  factory Configuraciones.fromMap(Map<String, dynamic> json) => Configuraciones(
        fichaParametrica: json["ficha_parametrica"],
      );
}
