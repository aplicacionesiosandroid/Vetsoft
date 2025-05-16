import 'package:flutter/foundation.dart';

class OrderFormModel extends ChangeNotifier {
  String clientName = '';
  String nit = '';
  bool isCashPayment = true;
  bool isOrderDelivered = false;

  void updateClientName(String name) {
    clientName = name;
    notifyListeners();
  }

  void updateNit(String nitValue) {
    nit = nitValue;
    notifyListeners();
  }

  void updateCashPayment(bool isCash) {
    isCashPayment = isCash;
    notifyListeners();
  }

  void updateOrderDeliveryStatus(bool delivered) {
    isOrderDelivered = delivered;
    notifyListeners();
  }
}
