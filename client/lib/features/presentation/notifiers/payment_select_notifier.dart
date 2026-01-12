import 'package:flutter/material.dart';

class PaymentSelectionProvider extends ChangeNotifier {
  String _selectedPaymentMethod = "Cash on Delivery";

  String get selectedPaymentMethod => _selectedPaymentMethod;

  void selectPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }
}
