import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class LoginModel {
  String userId;
  String pw;
  String nickName;
  String phoneNum;
  String profileIntro;

  LoginModel(
      {this.userId, this.pw, this.nickName, this.phoneNum, this.profileIntro});

  factory LoginModel.fromJson(Map<String, dynamic> parsedJson) {
    return LoginModel(
      userId: parsedJson['userid'],
      pw: parsedJson['pw'],
      nickName: parsedJson['nickname'],
      phoneNum: parsedJson['phone_number'],
      profileIntro: parsedJson['profile_intro'],
    );
  }
}
