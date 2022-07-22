import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BoardApi {
  final http.Client _client;

  static const baseUrl = 'http://54.177.126.159/ubuntu/flutter/account';

  BoardApi({http.Client client}) : _client = (client ?? http.Client());

  Future<http.Response> query() async {
    return await _client.get(Uri.parse('$baseUrl/mysql_test.php'));
  }

  Future<http.Response> insert(String userid, String pw, String nickname,
      String phone_number, String profile_intro) async {
    return await _client.get(Uri.parse(
        '$baseUrl/insert.php?userid=$userid&pw=$pw&nickname=$nickname&phone_number=$phone_number&profile_intro=$profile_intro'));
  }

  Future<http.Response> update(String userid, String pw, String nickname,
      String phone_number, String profile_intro) async {
    return await _client.get(Uri.parse(
        '$baseUrl/update.php?userid=$userid&pw=$pw&nickname=$nickname&phone_number=$phone_number&profile_intro=$profile_intro'));
  }

  Future<http.Response> delete(String userid) async {
    return await _client.get(Uri.parse('$baseUrl/update.php?userid=$userid'));
  }
}
