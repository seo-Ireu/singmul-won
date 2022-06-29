class User {
  String _userid;
  String _password;
  String _nickname;
  String _phone;
  String _profileintro;

  User(this._userid, this._password, this._nickname, this._phone,
      this._profileintro);

  User.fromMap(dynamic obj) {
    this._userid = obj['userId'];
    this._password = obj['password'];
    this._nickname = obj['nickname'];
    this._phone = obj['phone'];
    this._profileintro = obj['profileIntro'];
  }

  String get userid => _userid;
  String get password => _password;
  String get nickname => _nickname;
  String get phone => _phone;
  String get profileintro => _profileintro;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["userId"] = _userid;
    map["password"] = _password;
    map["nickname"] = _nickname;
    map["phone"] = _phone;
    map["profileIntro"] = _profileintro;
    return map;
  }
}
