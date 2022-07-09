import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../home_page.dart';
import '../account_sql_helper.dart';

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

  @override
  void dispose() {
    _useridTextController.dispose();
    _passwordTextController.dispose();
    _nicknameTextController.dispose();
    _phoneTextController.dispose();
    _profileintroTextController.dispose();
    super.dispose();
  }

  _setIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', true);
  }

  // reference to our single class that manages the database
  final dbHelper = AccountSQLHelper;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.perm_identity,
                          ),
                          labelText: 'Id',
                          hintText: 'Type your Id'),
                      validator: (String value) {
                        if (value.length < 1) {
                          return 'Id is required';
                        }
                      },
                      controller: _useridTextController,
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    width: 360,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.lock),
                          labelText: 'Password',
                          hintText: 'Type password'),
                      validator: (String value) {
                        if (value.trim().isEmpty) {
                          return 'Password is required';
                        } else {
                          return null;
                        }
                      },
                      controller: _passwordTextController,
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    width: 360,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.badge),
                          labelText: 'Nickname',
                          hintText: 'Type Nickname'),
                      validator: (String value) {
                        if (value.trim().isEmpty) {
                          return 'Nickname is required';
                        } else {
                          return null;
                        }
                      },
                      controller: _nicknameTextController,
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    width: 360,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.phone),
                          labelText: 'Phone Number',
                          hintText: 'Type PhoneNum'),
                      validator: (String value) {
                        if (value.trim().isEmpty) {
                          return 'PhoneNum is required';
                        } else {
                          return null;
                        }
                      },
                      controller: _phoneTextController,
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    width: 360,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.contact_page),
                          labelText: 'ProfileIntro',
                          hintText: 'Type Profile'),
                      validator: (String value) {
                        if (value.trim().isEmpty) {
                          return 'ProfileIntro is required';
                        } else {
                          return null;
                        }
                      },
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
                      onPressed: () async {
                        Navigator.of(context).pushNamed(HomePage.routeName);
                        await AccountSQLHelper.createAccount(
                            _useridTextController.toString(),
                            _passwordTextController.toString(),
                            _nicknameTextController.toString(),
                            _phoneTextController.toString(),
                            _profileintroTextController.toString());
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
