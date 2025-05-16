class ChatSession {
  bool error;
  int code;
  String message;
  ChatData data;

  ChatSession({
    required this.error,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
        error: json["error"],
        code: json["code"],
        message: json["message"],
        data: ChatData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}

class ChatData {
  String session;
  String respuestaChatgpt;

  ChatData({
    required this.session,
    required this.respuestaChatgpt,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
        session: json["session"],
        respuestaChatgpt: json["respuesta_chatgpt"],
      );

  Map<String, dynamic> toJson() => {
        "session": session,
        "respuesta_chatgpt": respuestaChatgpt,
      };
}
