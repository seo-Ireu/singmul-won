import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Board/board_api.dart';
import 'package:flutter_singmulwon_app/Login/login_model.dart';

import './board_repository.dart';
import './board_api.dart';

class BoardRepositoryImpl implements BoardRepository {
  BoardApi api;
  BoardRepositoryImpl(this.api);

  @override
  Future add(String userid, String pw, String nickname, String phone_number,
      String profile_intro) async {
    await api.insert(userid, pw, nickname, phone_number, profile_intro);
  }

  @override
  Future<List<LoginModel>> getPosts() async {
    final response = await api.query();
    final Iterable json = jsonDecode(response.body);
    return json.map((e) => LoginModel.fromJson(e)).toList();
  }

  @override
  Future remove(String userid) async {
    await api.delete(userid);
  }

  @override
  Future update(String userid, String pw, String nickname, String phone_number,
      String profile_intro) async {
    await api.update(userid, pw, nickname, phone_number, profile_intro);
  }
}
