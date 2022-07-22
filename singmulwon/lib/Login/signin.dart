// ignore_for_file: deprecated_member_use, prefer_const_constructors
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import './signup.dart';
import '../home_page.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  TextEditingController userid = TextEditingController();
  TextEditingController pw = TextEditingController();

  // @override
  // void dispose() {
  //   userid.dispose();
  //   pw.dispose();
  //   super.dispose();
  // }

  Future login(BuildContext cont) async {
    if (userid.text == "" || pw.text == "") {
      Fluttertoast.showToast(
          msg: "아이디와 비밀번호를 입력해주세요.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16);
    } else {
      var url = "http://54.177.126.159/ubuntu/flutter/account/signin.php";
      var response = await http.post(Uri.parse(url), body: {
        "userid": userid.text,
        "pw": pw.text,
      });
      // var vld = json.decode(response.body);
      var vld = await json.decode(json.encode(response.body));
      if (vld == '"Success"') {
        // Navigator.push(
        //     cont, MaterialPageRoute(builder: (context) => HomePage()));
        Navigator.of(context).pushNamed(HomePage.routeName);
      } else {
        Fluttertoast.showToast(
            msg: "아이디와 비밀번호가 일치하지 않습니다.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.only(top: 10, bottom: 24),
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
                'Login',
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
                    // validator: (String value) {
                    //   if (value.trim().isEmpty) {
                    //     return 'Id is required';
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    controller: userid,
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
                    // validator: (String value) {
                    //   if (value.trim().isEmpty) {
                    //     return 'Password is required';
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    controller: pw,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Sign in',
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                    textColor: Colors.white,
                    color: Colors.green[700],
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      // Navigator.of(context).pushNamed(HomePage.routeName);
                      login(context);
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Sign up',
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                    textColor: Colors.white,
                    color: Colors.green[700],
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
