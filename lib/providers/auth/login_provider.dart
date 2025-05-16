import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vet_sotf_app/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/global/global_variables.dart';

class AuthProvider extends ChangeNotifier {
  List<Original> resultOriginal = [];

  //Password Login viusibilidad
  bool _isPasswordVisiblePass = false;
  bool get isPasswordVisiblePass => _isPasswordVisiblePass;

  void tooglePasswordVisivilityPass() {
    _isPasswordVisiblePass = !_isPasswordVisiblePass;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;

  bool _inicioSesion = false;
  bool get inicioSesion => _inicioSesion;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setInicioSesion(bool value) {
    _inicioSesion = value;
    notifyListeners();
  }

  final String _url = '${apiUrlGlobal}auth/login';

  String _mensajeError = '';
  String get mensajeError => _mensajeError;

  Future<bool> loginUser(String user, String pass) async {
    setLoading(true);
    try {
      final response = await http
          .post(Uri.parse(_url), body: {'username': user, 'password': pass});

      final resDecode = jsonDecode(response.body);
      print("error del resonse: ${response.body}");
      debugPrint('Error completo: ${response.body}');

      if (resDecode['code'] == 200) {
        final resultResponse = classLoginFromJson(response.body);
        resultOriginal.add(resultResponse.data.original);
        setLoading(false);
        setInicioSesion(true);
        notifyListeners();
        return inicioSesion;
      } else {
        print('fallido');
        setLoading(false);
        setInicioSesion(false);
        notifyListeners();
        return inicioSesion;
      }
    } catch (e, stacktrace) {
      print('errooorrr login $e');
      print('errooorrr login $stacktrace');
      _mensajeError = 'Usuario o contraseña incorrecta $e';
      setLoading(false);
      setInicioSesion(false);
      notifyListeners();
      return inicioSesion;
    }
  }

  // Para shared preferences

/*   Original? _userOriginal ;

  Original? get userOriginal => _userOriginal;

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = User(
      email: prefs.getString('email') ?? '',
    );
    _userOriginal =
        Original(accessToken: prefs.getString('myToken') ?? '', user: user);

    notifyListeners();
  }
 */
  //username: prefs.getString('username') ?? '',
  //photoUrl: prefs.getString('photoUrl') ?? '',
  //nivel: prefs.getString('nivel') ?? '',

  Future<void> removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('myToken');
    prefs.remove('email');
    prefs.remove('role');
    notifyListeners();
  }

  Future<void> saveData(String parametrica, String token, int id, String email,
      String nombre, String imgUser, String rol) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('parametrica', parametrica);
    await prefs.setString('myToken', token);
    await prefs.setInt('idCliente', id);
    await prefs.setString('email', email);
    await prefs.setString('nombre', nombre);
    await prefs.setString('imgUser', imgUser);
    await prefs.setString('role', rol);
    notifyListeners();
  }

  Future<void> cerrarSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Borra todo el almacenamiento de SharedPreferences
    notifyListeners(); // Notifica cambios si usas Provider
  }
}
