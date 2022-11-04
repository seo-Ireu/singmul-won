import 'package:flutter/material.dart';

class Users with ChangeNotifier{

  String _userId  = "";
  String get userId => _userId;

  void setUserId(String id){
    _userId = id;
    notifyListeners();
  }

}