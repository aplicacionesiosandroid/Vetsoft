import 'package:flutter/material.dart';

class PaymentMethodModel extends ChangeNotifier {
  bool isPaymentInCash = true;
  String selectedCurrency = 'BOL';
  double cashAmount = 0.0;
  String discountCode = '';

  // Métodos para actualizar los datos del modelo
  void updatePaymentMethod(bool inCash) {
    isPaymentInCash = inCash;
    notifyListeners();
  }

  void updateCurrency(String currency) {
    selectedCurrency = currency;
    notifyListeners();
  }

  void updateCashAmount(double amount) {
    cashAmount = amount;
    notifyListeners();
  }

  void updateDiscountCode(String code) {
    discountCode = code;
    notifyListeners();
  }
}
