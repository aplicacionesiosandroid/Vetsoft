// To parse this JSON data, do
//
//     final classLogin = classLoginFromJson(jsonString);

import 'dart:convert';

ClassLogin classLoginFromJson(String str) => ClassLogin.fromJson(json.decode(str));

String classLoginToJson(ClassLogin data) => json.encode(data.toJson());

class ClassLogin {
    bool error;
    int code;
    String message;
    Data data;

    ClassLogin({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ClassLogin.fromJson(Map<String, dynamic> json) => ClassLogin(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    Headers headers;
    Original original;
    dynamic exception;

    Data({
        required this.headers,
        required this.original,
        required this.exception,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        headers: Headers.fromJson(json["headers"]),
        original: Original.fromJson(json["original"]),
        exception: json["exception"],
    );

    Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
        "exception": exception,
    };
}

class Headers {
    Headers();

    factory Headers.fromJson(Map<String, dynamic> json) => Headers(
    );

    Map<String, dynamic> toJson() => {
    };
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

    factory Original.fromJson(Map<String, dynamic> json) => Original(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        user: User.fromJson(json["user"]),
        expiresIn: json["expires_in"],
    );

    Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "user": user.toJson(),
        "expires_in": expiresIn,
    };
}

class User {
    int id;
    String username;
    String email;
    dynamic unconfirmedEmail;
    dynamic registrationIp;
    int confirmedAt;
    dynamic blockedAt;
    int updatedAt;
    int createdAt;
    int? lastLoginAt;
    String? lastLoginIp;
    dynamic authTfKey;
    int authTfEnabled;
    int passwordChangedAt;
    int gdprConsent;
    dynamic gdprConsentDate;
    int gdprDeleted;
    DateTime fecha;
    int? intentos;
    String nombres;
    String apellidos;
    int clienteId;
    String imagenUser;
    String? numeroTelCelCuenta;
    String? rol;
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
        required this.numeroTelCelCuenta,
        required this.rol,
        required this.configuraciones,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
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
        fecha: DateTime.parse(json["fecha"] ?? DateTime.now().toString()),
        intentos: json["intentos"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        clienteId: json["cliente_id"],
        imagenUser: json["imagen_user"],
        numeroTelCelCuenta: json["numero_tel_cel_cuenta"],
        rol: json["rol"],
        configuraciones: Configuraciones.fromJson(json["configuraciones"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "unconfirmed_email": unconfirmedEmail,
        "registration_ip": registrationIp,
        "confirmed_at": confirmedAt,
        "blocked_at": blockedAt,
        "updated_at": updatedAt,
        "created_at": createdAt,
        "last_login_at": lastLoginAt,
        "last_login_ip": lastLoginIp,
        "auth_tf_key": authTfKey,
        "auth_tf_enabled": authTfEnabled,
        "password_changed_at": passwordChangedAt,
        "gdpr_consent": gdprConsent,
        "gdpr_consent_date": gdprConsentDate,
        "gdpr_deleted": gdprDeleted,
        "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "intentos": intentos,
        "nombres": nombres,
        "apellidos": apellidos,
        "cliente_id": clienteId,
        "imagen_user": imagenUser,
        "numero_tel_cel_cuenta": numeroTelCelCuenta,
        "rol": rol,
        "configuraciones": configuraciones.toJson(),
    };
}

class Configuraciones {
    String? fichaParametrica;

    Configuraciones({
        required this.fichaParametrica,
    });

    factory Configuraciones.fromJson(Map<String, dynamic> json) => Configuraciones(
        fichaParametrica: json["ficha_parametrica"],
    );

    Map<String, dynamic> toJson() => {
        "ficha_parametrica": fichaParametrica,
    };
}
