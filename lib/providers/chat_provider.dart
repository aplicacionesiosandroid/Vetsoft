import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/models/chat/chatSession.dart';
import 'package:vet_sotf_app/models/chat/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  ChatSession? _chatSession;
  final String _urlBase = apiUrlGlobal;
  List<Message> messageList = [];
  List<String> messageListImages = [];
  final ScrollController chatScrollController = ScrollController();

  late String _chat = "";
  String get chat => _chat;

  void setChat(String chat){
    _chat = chat;
    notifyListeners();
  }

  ChatSession? get chatSession => _chatSession;

  void setChatSession(ChatSession session) {
    _chatSession = session;
    notifyListeners();
  }
  bool _isBotWriting = false;

  bool get isBotWriting => _isBotWriting;

  void setBotWriting(bool value) {
    _isBotWriting = value;
    notifyListeners();
  }

  Future<void> iniciarChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';
    final url = Uri.parse('${_urlBase}chatgpt/iniciar-chat');

    print(
        'Iniciando chat con URL: $url y Token: $token'); // Imprime la URL y el Token

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print('Respuesta del servidor chat gpt: ${response.statusCode}'); // Imprime el código de estado de la respuesta
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Datos recibidos: $jsonData'); // Imprime los datos recibidos

        if (jsonData['error'] == false) {
          final sessionData = ChatSession.fromJson(jsonData);
          setChatSession(sessionData);
          messageList.add(Message(
              text: sessionData.data.respuestaChatgpt, fromWho: FromWho.ia, imagen: ''));
          notifyListeners();
        } else {
          print(
              'Error del servidor: ${jsonData['message']}'); // Imprime el mensaje de error del servidor
        }
      } else {
        print(
            'No se pudo iniciar la sesión de chat. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al iniciar la sesión de chat: $error'); // Imprime el error
    }
  }

  //Cargando archivo sello
  String _imageChatBot = '';
  String get imageChatBot => _imageChatBot;
  void setImageChatBot(String fileName) {
    _imageChatBot = fileName;
    notifyListeners();
  }

  void clearImage(){
    _imageChatBot = '';
    notifyListeners();
  }

  Future<void> respuestaChatGPT(String preguntaTexto, String sessionId, String imagen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };

    // Crear una nueva solicitud multipart
    var request = http.MultipartRequest('post',Uri.parse('${apiUrlGlobal}chatgpt/enviarmensaje'));
    request.headers.addAll(headers);

    // Verificar si hay una imagen de sello disponible
    if (imagen.isNotEmpty) {
      // Agregar las imágenes de sello a la solicitud
      File imageFile = File(imagen);
      if (await imageFile.exists()) {
        request.files.add(await http.MultipartFile.fromPath('imagen', imageFile.path));
      }
    }
    request.fields['session'] = sessionId;
    request.fields['mensaje'] = preguntaTexto;

    // Enviar la solicitud
    var response = await request.send();
    print(response);
    // Manejar la respuesta
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);

      // Verificar si la respuesta contiene la información esperada
      if (jsonResponse.containsKey('data')) {
        var data = jsonResponse['data'];
        print("respuesta chatGPT $data");
        String respuestaChatGPT = jsonResponse['data']['respuesta_chatgpt'];
        messageList.add(Message(text: respuestaChatGPT, fromWho: FromWho.ia, imagen: ''));
        notifyListeners();
      }
      notifyListeners();
    } else {
      print('Error al enviar imágenes: ${response.reasonPhrase}');
    }
  }
  Future<void> sendMessage(String text) async {

    if (text.isEmpty || _chatSession == null) return;

    final newMessage = Message(text: text, fromWho: FromWho.me, imagen: imageChatBot);
    messageList.add(newMessage);
    notifyListeners();

    setBotWriting(true);
    clearImage();
    await respuestaChatGPT(text, _chatSession!.data.session, newMessage.imagen);

    setBotWriting(false);
    moveScrollToBottom();
  }

  Future<void> iaReply(String preguntaTexto, String sessionId) async {
    final urlFinal = '${_urlBase}chatgpt/enviarmensaje';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final datos = <String, dynamic>{
      'session': sessionId,
      'mensaje': preguntaTexto,
    };

    String body = jsonEncode(datos);

    final response = await http.post(Uri.parse(urlFinal), headers: headers, body: body);
    final jsonResponse = jsonDecode(response.body);

    try {
      if (jsonResponse['code'] == 200) {
        String respuestaChatGPT = jsonResponse['data']['respuesta_chatgpt'];
        messageList.add(Message(text: respuestaChatGPT, fromWho: FromWho.ia, imagen: ''));
        notifyListeners();
      } else {
        print('Error en la solicitud: ${jsonResponse['code']}');
      }
    } catch (e) {
      print('Error al obtener respuesta de IA: $e');
    }
  }


  Future<void> moveScrollToBottom() async {
    if (chatScrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 100));
      chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  //resetea la secion
  void resetChat() {
    _chatSession = null;
    messageList.clear();
    notifyListeners();
  }

  // historail del asistente virtual
  Map<String, List<Map<String, dynamic>>> historialChat = {
    'esta_semana': [],
    'semana_pasada': [],
    'antiguo': []
  };

  Future<void> fetchHistorialChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';
    final url = Uri.parse('${_urlBase}chatgpt/historial-chat');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (!jsonData['error']) {
          historialChat['esta_semana'] = List<Map<String, dynamic>>.from(jsonData['data']['esta_semana']);
          historialChat['semana_pasada'] = List<Map<String, dynamic>>.from(jsonData['data']['semana_pasada']);
          historialChat['antiguo'] = List<Map<String, dynamic>>.from(jsonData['data']['antiguo']);
          notifyListeners();
        } else {
          print('Error del servidor: ${jsonData['message']}');
        }
      } else {
        print('Error al obtener historial de chat. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al obtener historial de chat: $error');
    }
  }


  //historial de show chat
  List<Map<String, dynamic>> historialDetallado = [];

  // Método para obtener el detalle del historial de chat
  Future<void> fetchChatDetail(int historialId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';
    final url = Uri.parse('${_urlBase}chatgpt/show-chat/$historialId');
    print('url de peticion $url');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (!jsonData['error']) {
          historialDetallado = List<Map<String, dynamic>>.from(jsonData['data']);
          print('Historial detallado actualizado: $historialDetallado'); 
          notifyListeners();
        } else {
          print('Error del servidor: ${jsonData['message']}');
        }
      } else {
        print('Error al obtener detalle del historial de chat. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al obtener detalle del historial de chat: $error');
    }
  }

}
