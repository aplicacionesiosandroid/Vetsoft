import 'package:flutter/material.dart';

class UiProvider extends ChangeNotifier {
  //Drawer
  String _selectedOptionDrawer = 'Home';
  String get selectedOptionDrawer => _selectedOptionDrawer;

  void setOptionSelectedDrawer(String option) {
    _selectedOptionDrawer = option;
    notifyListeners();
  }

  //BottomNavigationBar
  int _selectedIndexBottomBar = 0;
  int get selectedIndexBottomBar => _selectedIndexBottomBar;
  void setSelectedIndexBottomBar(int index) {
    _selectedIndexBottomBar = index;
    notifyListeners();
  }

  //OnboardingScreen
  int _currentPageIndexOnboarding = 0;

  int get currentPageIndexOnboarding => _currentPageIndexOnboarding;

  void setCurrentPageIndexOnboarding(int index) {
    _currentPageIndexOnboarding = index;
    notifyListeners();
  }

}
