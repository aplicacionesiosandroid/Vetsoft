import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_sotf_app/config/global/global_variables.dart';

import 'package:http/http.dart' as http;
import 'package:vet_sotf_app/models/cuenta/user.dart';




class AccountEmpProvider extends ChangeNotifier {

  bool isSwitchedNotification = false;

  void toggleSwitchNotification() {
    isSwitchedNotification = !isSwitchedNotification;
    notifyListeners();
  }

  //empresa

  //para switch de notifiacion para facturacion electronica
  bool isSwitchedNotificationFacElectronica = false;
  void toggleSwitchNotificationFacElectronica() {
    isSwitchedNotificationFacElectronica =
        !isSwitchedNotificationFacElectronica;
    notifyListeners();
  }

  //para switch de notifiacion para pasarela de pagos
  bool isSwitchedNotificationPasarelaPagos = false;
  void toggleSwitchNotificationPasarelaPagos() {
    isSwitchedNotificationPasarelaPagos = !isSwitchedNotificationPasarelaPagos;
    notifyListeners();
  }

  //para switch de notifiacion para wahtsap bussines
  bool isSwitchedNotificationWhatsappBuss = false;
  void toggleSwitchNotificationWhatsappBuss() {
    isSwitchedNotificationWhatsappBuss = !isSwitchedNotificationWhatsappBuss;
    notifyListeners();
  }

  //para switch de notifiacion para firma electroncia de  empresa
  bool isSwitchedNotificationFirmaEmpresa = false;
  void toggleSwitchNotificationFirmaEmpresa() {
    isSwitchedNotificationFirmaEmpresa = !isSwitchedNotificationFirmaEmpresa;
    notifyListeners();
  }

  //para controlar el valor del tabbar
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;
  void updateTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  
}
