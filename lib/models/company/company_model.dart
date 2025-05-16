import 'dart:convert';
import 'package:vet_sotf_app/models/company/apiResponse.dart';

class CompanyInfo {
  final bool error;
  final int code;
  final String message;
  final Company data;

  CompanyInfo({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory CompanyInfo.fromRawJson(String str) =>
      CompanyInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompanyInfo.fromJson(Map<String, dynamic> json) => CompanyInfo(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: Company.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": data,
      };
}

class Company {
  String nameCompany;
  String licenses;
  String nitFactura;
  String pasarelaPagos;
  String whatsapp;
  String tipoFicha;

  Company({
    required this.nameCompany,
    required this.licenses,
    required this.nitFactura,
    required this.pasarelaPagos,
    required this.whatsapp,
    required this.tipoFicha,
  });

  factory Company.fromRawJson(String str) => Company.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        nameCompany: json["nombre_empresa"],
        licenses: json["licencias"],
        nitFactura: json["nit_factura"],
        pasarelaPagos: json["pasarela_pagos"],
        whatsapp: json["whatsapp"],
        tipoFicha: json["tipo_ficha"],
      );

  Map<String, dynamic> toJson() => {
        "nombre_empresa": nameCompany,
        "licencias": licenses,
        "nit_factura": nitFactura,
        "tipo_ficha": tipoFicha,
      };
}

class ApiResponse {
  final bool error;
  final int code;
  final String message;
  final SignatureInfo data;

  ApiResponse({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromRawJson(String str) =>
      ApiResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: SignatureInfo.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}

class SignatureInfo {
  late String signature;
  late String stamp;

  SignatureInfo({
    required this.signature,
    required this.stamp,
  });

  factory SignatureInfo.fromRawJson(String str) =>
      SignatureInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SignatureInfo.fromJson(Map<String, dynamic> json) => SignatureInfo(
        signature: json["firma"],
        stamp: json["sello"],
      );

  Map<String, dynamic> toJson() => {
        "firma": signature,
        "sello": stamp,
      };
}

// Clase específica para los datos de la respuesta del servidor
class TaxpayerInfo {
  String numeroNit;
  String contribuyente;
  String domicilioTributario;
  String granActividad;
  String actividadPrincipal;
  String tipoContribuyente;
  String imagen;

  TaxpayerInfo({
    required this.numeroNit,
    required this.contribuyente,
    required this.domicilioTributario,
    required this.granActividad,
    required this.actividadPrincipal,
    required this.tipoContribuyente,
    required this.imagen,
  });

  factory TaxpayerInfo.fromRawJson(String str) =>
      TaxpayerInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaxpayerInfo.fromJson(Map<String, dynamic> json) => TaxpayerInfo(
        numeroNit: json["numero_nit"],
        contribuyente: json["contribuyente"],
        domicilioTributario: json["domicilio_tributario"],
        granActividad: json["gran_actividad"],
        actividadPrincipal: json["actividad_principal"],
        tipoContribuyente: json["tipo_contribuyente"],
        imagen: json["imagen"],
      );

  Map<String, dynamic> toJson() => {
        "numero_nit": numeroNit,
        "contribuyente": contribuyente,
        "domicilio_tributario": domicilioTributario,
        "gran_actividad": granActividad,
        "actividad_principal": actividadPrincipal,
        "tipo_contribuyente": tipoContribuyente,
        "imagen": imagen,
      };
}

// Clase específica ApiResponse para la respuesta del servidor
class TaxpayerApiResponse extends ApiResponseGeneral<TaxpayerInfo> {
  TaxpayerApiResponse({
    required bool error,
    required int code,
    required String message,
    required TaxpayerInfo data,
  }) : super(error: error, code: code, message: message, data: data);

  factory TaxpayerApiResponse.fromRawJson(String str) {
    final jsonData = json.decode(str);
    return TaxpayerApiResponse(
      error: jsonData['error'],
      code: jsonData['code'],
      message: jsonData['message'],
      data: TaxpayerInfo.fromJson(jsonData['data']),
    );
  }

  factory TaxpayerApiResponse.fromJson(Map<String, dynamic> json) {
    return TaxpayerApiResponse(
      error: json['error'],
      code: json['code'],
      message: json['message'],
      data: TaxpayerInfo.fromJson(json['data']),
    );
  }
}
