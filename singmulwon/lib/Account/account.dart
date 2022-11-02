// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../Login/signup.dart';
import './change_pw.dart';

class Account extends StatefulWidget {
  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // final account = AccountSQLHelper.getAccounts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text("친구 팔로우 및 초대"),
              leading: SizedBox(
                height: 50,
                width: 30,
                child: Icon(
                  Icons.person_add_alt,
                ),
              ),
              trailing: Text(
                ">  ",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              title: Text("계정"),
              leading: SizedBox(
                height: 50,
                width: 30,
                child: Icon(
                  Icons.account_circle,
                ),
              ),
              trailing: Text(
                ">  ",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePw()),
                );
              },
            ),
          ),
          Card(
            child: Column(children: [
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10, bottom: 4),
                // ignore: prefer_const_constructors
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '로그인',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Divider(),
              Container(
                padding: const EdgeInsets.only(
                    top: 2, left: 6, right: 10, bottom: 2),
                child: ListTile(
                  title: Text("계정추가",
                      style: TextStyle(fontSize: 16, color: Colors.blue[400])),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                ),
              ),
              Divider(),
              Container(
                padding: const EdgeInsets.only(
                    top: 2, left: 6, right: 10, bottom: 2),
                child: ListTile(
                  title: Text("로그아웃",
                      style: TextStyle(fontSize: 16, color: Colors.blue[400])),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
