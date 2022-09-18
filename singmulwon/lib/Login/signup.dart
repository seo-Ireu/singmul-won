// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, missing_return, unnecessary_this, prefer_is_empty, use_key_in_widget_constructors, prefer_final_fields, unrelated_type_equality_checks, deprecated_member_use

import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer';

import 'dart:async';
import 'dart:convert';

import '../home_page.dart';

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
          "http://13.209.68.93/ubuntu/flutter/account/signup_validate.php";
      var response = await http.post(Uri.parse(url_bf), body: {
        "userid": userid,
      });
      var vld = await json.decode(json.encode(response.body));
      log('****');
      log(vld);
      log('****');
      if (vld == '"catch"') {
        Fluttertoast.showToast(
            msg: "아이디가 중복되었습니다.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16);
      } else {
        var url = "http://13.209.68.93/ubuntu/flutter/account/insert.php";
        await http.get(Uri.parse(
            '$url?userid=$userid&pw=$pw&nickname=$nickname&phone_number=$phone_number&profile_intro=$profile_intro'));
        Navigator.of(context)
            .pushNamed(HomePage.routeName, arguments: {'userid': userid});
      }
    }
  }

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
                      //validation 추가 필요
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
                      //validation 추가 필요
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
                      //validation 추가 필요
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
                      //validation 추가 필요
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
                      //validation 추가 필요
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
                      // ignore: sort_child_properties_last
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
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
}
