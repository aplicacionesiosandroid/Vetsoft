import 'package:flutter/material.dart';

class TabBarProvider extends ChangeNotifier {
  final List<String> _TabsPantalla = [
    'NORMAL',
    'CIRUGIA',
    'VACUNAS',
    'DESPARASITACION',
    'PROCEDIMIENTO',
    'HOSPITALIZACION',
  ];
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentTabIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

   String obtieneNombreTab() {
    return _TabsPantalla[_currentIndex];
  }
}
