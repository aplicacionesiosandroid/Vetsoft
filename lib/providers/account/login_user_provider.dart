import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUserProvider extends ChangeNotifier {
  bool? _isAdmin;
  bool? get isAdmin => _isAdmin;

  Future<void> checkIfUserIsAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    if (role != null) {
      _isAdmin = role.toUpperCase() == 'ADMINISTRADOR';
      notifyListeners();
    }
    print('Role: $role');
  }

  static Future<String> getRol() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    return role ?? '';
  }
}
