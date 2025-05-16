import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('myToken') ?? '';
    return token;
  }

  static Future<String> getRol() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('rol') ?? '';
    return token;
  }
}
