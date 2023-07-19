import 'package:flutter/material.dart';

class UserInfo extends ChangeNotifier {

  late String _passValue;
  late String _userNameValue;

  List<String> get getAuthValues => [_passValue, _userNameValue];


  void updateAuthValues(String username, String pass) {
    _userNameValue = username;
    _passValue = pass;
    notifyListeners();
  }

  void clearPassValue() {
    _userNameValue = '';
    _passValue = '';
    notifyListeners();
  }

}