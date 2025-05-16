import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/login_model.dart';

class SharedDataProvider extends ChangeNotifier {
  Original? _userOriginal;

  Original? get userData => _userOriginal;

  /* Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = User(
      email: prefs.getString('email') ?? '',
    );
    _userOriginal =
        Original(accessToken: prefs.getString('myToken') ?? '', user: user);
    notifyListeners();
  } */

  //username: prefs.getString('username') ?? '',
  //photoUrl: prefs.getString('photoUrl') ?? '',
  //nivel: prefs.getString('nivel') ?? '',

  Future<bool> removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('myToken');
    prefs.remove('email');
    notifyListeners();
    return true;
  }

  Future<void> saveData(Original userOriginal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('myToken', userOriginal.accessToken);
    await prefs.setString('email', userOriginal.user.email);
    _userOriginal = _userOriginal;
    notifyListeners();
  }

  Future<bool> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('myToken');
    bool respToken = false;

    if (token != null) {
      respToken = JwtDecoder.isExpired(token);
    }
    if (token==null) {
      respToken = true;
    }

    return respToken;
/* 
    if (token != null) {
      Navigator.pushNamed(
          context, '/homeScreen'); // Reemplaza con la ruta correcta.
    } else {
      // Si no tienes un token, navega a la pantalla de inicio de sesión.
      Navigator.pushNamed(context, '/login'); // Reemplaza con la ruta correcta.
    } */
  }
}
