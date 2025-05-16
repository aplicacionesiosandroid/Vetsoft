import 'dart:convert';

enum FromWho { me, ia }

class Message {
  final String text;
  final FromWho fromWho;
  final String imagen;

  Message({
    required this.text,
    required this.fromWho,
    required this.imagen,
  });
}


// To parse this JSON data, do
//
//     final modelRespChatGpt = modelRespChatGptFromJson(jsonString);



ModelRespChatGpt modelRespChatGptFromJson(String str) => ModelRespChatGpt.fromJson(json.decode(str));

String modelRespChatGptToJson(ModelRespChatGpt data) => json.encode(data.toJson());

class ModelRespChatGpt {
    bool error;
    int code;
    String message;
    Data data;

    ModelRespChatGpt({
        required this.error,
        required this.code,
        required this.message,
        required this.data,
    });

    factory ModelRespChatGpt.fromJson(Map<String, dynamic> json) => ModelRespChatGpt(
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
    String respuestaChatgpt;

    Data({
        required this.respuestaChatgpt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        respuestaChatgpt: json["respuesta_chatgpt"],
    );

    Map<String, dynamic> toJson() => {
        "respuesta_chatgpt": respuestaChatgpt,
    };

}
