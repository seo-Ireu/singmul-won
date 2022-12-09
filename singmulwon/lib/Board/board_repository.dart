import 'package:flutter/material.dart';

import '../Login/login_model.dart';

abstract class BoardRepository {
  Future<List<LoginModel>> getPosts();
  Future add(String userid, String pw, String nickname, String phone_number,
      String profile_intro);
  Future update(String userid, String pw, String nickname, String phone_number,
      String profile_intro);
  Future remove(String userid);
}
