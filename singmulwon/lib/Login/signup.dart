// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, missing_return, unnecessary_this, prefer_is_empty

import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:async';
import 'dart:convert';

import '../home_page.dart';
import './login_model.dart';
import '../Board/board_api.dart';
import '../Board/board_repository_impl.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  final _useridTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _nicknameTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _profileintroTextController = TextEditingController();

  // Future<LoginModel> loginmodel;
  BoardRepositoryImpl boardrepositoryimpl;
  BoardApi api;

  var _Login = LoginModel(
      userId: '', pw: '', nickName: '', phoneNum: '', profileIntro: '');

  // @override
  // void dispose() {
  //   _useridTextController.dispose();
  //   _passwordTextController.dispose();
  //   _nicknameTextController.dispose();
  //   _phoneTextController.dispose();
  //   _profileintroTextController.dispose();
  //   super.dispose();
  // }
  Future create() async {
    if (_useridTextController.text == "" ||
        _passwordTextController.text == "" ||
        _nicknameTextController == "" ||
        _phoneTextController == "") {
      Fluttertoast.showToast(
          msg: "정보를 입력해주세요.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16);
    } else {
      var userid = _useridTextController.text;
      var pw = _passwordTextController.text;
      var nickname = _nicknameTextController.text;
      var phone_number = _phoneTextController.text;
      var profile_intro = _profileintroTextController.text;
      var url_bf =
          "http://54.177.126.159/ubuntu/flutter/account/signup_validate.php";
      var response = await http.post(Uri.parse(url_bf), body: {
        "userid": userid,
      });
      var vld = await json.decode(json.encode(response.body));
      if (vld == '"catch"\n') {
        Fluttertoast.showToast(
            msg: "아이디가 중복되었습니다.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16);
      } else {
        var url = "http://54.177.126.159/ubuntu/flutter/account/insert.php";
        await http.get(Uri.parse(
            '$url?userid=$userid&pw=$pw&nickname=$nickname&phone_number=$phone_number&profile_intro=$profile_intro'));
        Navigator.of(context).pushNamed(HomePage.routeName);
      }
    }
  }
  // _setIsLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isLogin', true);
  // }

  // reference to our single class that manages the database
  // final dbHelper = AccountSQLHelper;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // SingleChildScrollView
      body: Container(
        margin: const EdgeInsets.all(4.0),
        padding: const EdgeInsets.only(top: 70, bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SignUp',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(13.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 360,
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.perm_identity,
                          ),
                          labelText: 'Id',
                          hintText: 'Type your Id'),
                      // onSaved: (val) {
                      //   setState(() {
                      //     // this.user_id = val;
                      //     // _Login.userid = val;
                      //     _Login = LoginModel(
                      //         userId: val,
                      //         pw: _Login.pw,
                      //         nickName: _Login.nickName,
                      //         phoneNum: _Login.phoneNum,
                      //         profileIntro: _Login.profileIntro);
                      //   });
                      // },
                      // onChanged: (val) {
                      //   setState(() {
                      //     _Login = LoginModel(
                      //         userId: val,
                      //         pw: _Login.pw,
                      //         nickName: _Login.nickName,
                      //         phoneNum: _Login.phoneNum,
                      //         profileIntro: _Login.profileIntro);
                      //   });
                      // },
                      // validator: (String value) {
                      //   if (value.isEmpty) {
                      //     return 'Id is requiredPlease provide a value.';
                      //   }
                      //   return null;
                      // },
                      controller: _useridTextController,
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    width: 360,
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.lock),
                          labelText: 'Password',
                          hintText: 'Type password'),
                      // onSaved: (val) {
                      // setState(() {
                      //     // this.pw = val;
                      //     // _Login.pw = val;
                      //     _Login = LoginModel(
                      //         userId: _Login.userId,
                      //         pw: val,
                      //         nickName: _Login.nickName,
                      //         phoneNum: _Login.phoneNum,
                      //         profileIntro: _Login.profileIntro);
                      //   });
                      // },
                      // onChanged: (val) {
                      //   setState(() {
                      //     // this.pw = val;
                      //     // _Login.pw = val;
                      //     _Login = LoginModel(
                      //         userId: _Login.userId,
                      //         pw: val,
                      //         nickName: _Login.nickName,
                      //         phoneNum: _Login.phoneNum,
                      //         profileIntro: _Login.profileIntro);
                      //   });
                      // },
                      // validator: (String value) {
                      //   if (value.trim().isEmpty) {
                      //     return 'Password is required';
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      controller: _passwordTextController,
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    width: 360,
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.badge),
                          labelText: 'Nickname',
                          hintText: 'Type Nickname'),
                      // onSaved: (val) {
                      //   setState(() {
                      //     // this.nick_name = val;
                      //     // _Login.nickName = val;
                      //     _Login = LoginModel(
                      //         userId: _Login.userId,
                      //         pw: _Login.pw,
                      //         nickName: val,
                      //         phoneNum: _Login.phoneNum,
                      //         profileIntro: _Login.profileIntro);
                      //   });
                      // },
                      // onChanged: (val) {
                      //   setState(() {
                      //     // this.nick_name = val;
                      //     // _Login.nickName = val;
                      //     _Login = LoginModel(
                      //         userId: _Login.userId,
                      //         pw: _Login.pw,
                      //         nickName: val,
                      //         phoneNum: _Login.phoneNum,
                      //         profileIntro: _Login.profileIntro);
                      //   });
                      // },
                      // validator: (String value) {
                      //   if (value.trim().isEmpty) {
                      //     return 'Nickname is required';
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      controller: _nicknameTextController,
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    width: 360,
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.phone),
                          labelText: 'Phone Number',
                          hintText: 'Type PhoneNum'),
                      // onSaved: (val) {
                      //   setState(() {
                      //     // this.phone_number = val;
                      //     // _Login.phoneNum = val;
                      //     _Login = LoginModel(
                      //         userId: _Login.userId,
                      //         pw: _Login.pw,
                      //         nickName: _Login.nickName,
                      //         phoneNum: val,
                      //         profileIntro: _Login.profileIntro);
                      //   });
                      // },
                      // onChanged: (val) {
                      //   setState(() {
                      //     // this.phone_number = val;
                      //     // _Login.phoneNum = val;
                      //     _Login = LoginModel(
                      //         userId: _Login.userId,
                      //         pw: _Login.pw,
                      //         nickName: _Login.nickName,
                      //         phoneNum: val,
                      //         profileIntro: _Login.profileIntro);
                      //   });
                      // },
                      // validator: (String value) {
                      //   if (value.trim().isEmpty) {
                      //     return 'PhoneNum is required';
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      controller: _phoneTextController,
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    width: 360,
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.contact_page),
                          labelText: 'ProfileIntro',
                          hintText: 'Type Profile'),
                      // onSaved: (val) {
                      //   setState(() {
                      //     // this.profile_intro = val;
                      //     // _Login.profileIntro = val;
                      //     _Login = LoginModel(
                      //         userId: _Login.userId,
                      //         pw: _Login.pw,
                      //         nickName: _Login.nickName,
                      //         phoneNum: _Login.phoneNum,
                      //         profileIntro: val);
                      //   });
                      // },
                      // onChanged: (val) {
                      //   setState(() {
                      //     // this.profile_intro = val;
                      //     // _Login.profileIntro = val;
                      //     _Login = LoginModel(
                      //         userId: _Login.userId,
                      //         pw: _Login.pw,
                      //         nickName: _Login.nickName,
                      //         phoneNum: _Login.phoneNum,
                      //         profileIntro: val);
                      //   });
                      // },
                      // validator: (String value) {
                      //   if (value.trim().isEmpty) {
                      //     return 'ProfileIntro is required';
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      controller: _profileintroTextController,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                        //                    side: BorderSide(color: Colors.red)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Submit',
                            style: TextStyle(fontSize: 28),
                          ),
                        ],
                      ),
                      textColor: Colors.white,
                      color: Colors.green[700],
                      padding: EdgeInsets.all(10),
                      onPressed: () {
                        create();
                        // await AccountSQLHelper.createAccount(
                        //     _useridTextController.toString(),
                        //     _passwordTextController.toString(),
                        //     _nicknameTextController.toString(),
                        //     _phoneTextController.toString(),
                        //     _profileintroTextController.toString());
                        // await boardrepositoryimpl.add(
                        //     _Login.userId,
                        //     _Login.pw,
                        //     _Login.nickName,
                        //     _Login.phoneNum,
                        //     _Login.profileIntro);

                        // Navigator.of(context).pushNamed(HomePage.routeName);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Button onPressed methods

}
