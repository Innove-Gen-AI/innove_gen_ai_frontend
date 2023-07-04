import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfo extends ChangeNotifier {

  late String _passValue;
  
  
  String get getAuthValue => _passValue;

  void updatePassValue(String value) {
    _passValue = value;
    notifyListeners();
  }

  void clearPassValue() {
    _passValue = '';
    notifyListeners();
  }

}