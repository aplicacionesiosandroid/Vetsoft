import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vet_sotf_app/config/global/global_variables.dart';
import 'package:vet_sotf_app/models/inicio/notifications.dart';
import 'package:vet_sotf_app/models/petshop/HomePetshop/notificacion_model.dart';

class NotificationsProvider extends ChangeNotifier {

  final String _urlBase = apiUrlGlobal;
  late List<NotificationData> notificationList = [];
  late List<CardNotify> cardNotifyList = [];

  //obtener detalle de caja
  bool _loadingNotification = false;
  bool get loadingNotification => _loadingNotification;
  set loadingNotification(bool state) {
    _loadingNotification = state;
    notifyListeners();
  }

  Future<void> getNotificaciones() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loadingNotification = true;
    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(Uri.parse('${_urlBase}inicio/notificaciones'), headers: headers);

    try {
      if (response.statusCode == 200) {
        final resp = ModelNotifications.fromJson(response.body);
        notificationList = resp.data;
        notificationListWidget();
        notifyListeners();

      } else {
        throw Exception('Error al obtener los datos de la API');
      }
    } catch (e) {
      print('Error al obtener los datos de la API catch $e');
    }

  }

  void notificationListWidget() {
    cardNotifyList.clear();
    for (var i = 0; i < notificationList.length; i++) {
      // Icon icon = Icon(Icons.hourglass_bottom, color: Colors.black);
      int id = notificationList[i].notificacionID;
      String icon = notificationList[i].imagen;
      String titulo = "Hora de cita";
      String descripcion = notificationList[i].mensaje;
      String hora = notificationList[i].creadoTiempo;
      Color color = notificationList[i].notificacionID.isOdd ? Color(0xFFF0EFFF) : Color(0xFF4743BC);

      cardNotifyList.add(CardNotify(id, icon, titulo, descripcion, hora, color));
    }
  }

  Future<bool> marcarLeidoNotificacion(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(Uri.parse('${_urlBase}inicio/marcar-leido-notificacion?notificacion_id=$id'), headers: headers);

    try {
      if (response.statusCode == 200) {
        cardNotifyList.removeWhere((notification) => notification.id == id);
        notificationList.removeWhere((notification) => notification.notificacionID == id);
        notifyListeners();
        return true;
      } else {
        throw Exception('Error al obtener los datos de la API');
      }
    } catch (e) {
      print('Error al obtener los datos de la API catch $e');
      return false;

    }

  }

  //obtener detalle de caja
  String _tipeWindow = "home";
  String get tipeWindow => _tipeWindow;
  set tipeWindow(String state) {
    _tipeWindow = state;
  }

  void notificationListWidgetChangedColor() {
    cardNotifyList.clear();
    for (var i = 0; i < notificationList.length; i++) {
      // Icon icon = Icon(Icons.hourglass_bottom, color: Colors.black);
      int id = notificationList[i].notificacionID;
      String icon = notificationList[i].imagen;
      String titulo = "Hora de cita";
      String descripcion = notificationList[i].mensaje;
      String hora = notificationList[i].creadoTiempo;
      Color color = notificationList[i].notificacionID.isOdd ?
              Color(0xFFF0EFFF) :
      _tipeWindow == 'home' ? Color(0xFF4743BC) :
      _tipeWindow == 'peluqeria' ?  Color(0xFF635CFF) :
      _tipeWindow == 'clinica' ?  Color(0xFF007AA0) : Color(0xFF007AA0);


      cardNotifyList.add(CardNotify(id, icon, titulo, descripcion, hora, color));
    }
  }

}