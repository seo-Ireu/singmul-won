import 'package:flutter/material.dart';

import '../account_sql_helper.dart';
import '../http.dart';

class Account extends StatefulWidget {
  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final account = AccountSQLHelper.getAccounts;

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
              title: Text("알림"),
              leading: SizedBox(
                height: 50,
                width: 30,
                child: Icon(
                  Icons.notifications_none,
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
              title: Text("공개 범위 및 보안"),
              leading: SizedBox(
                height: 50,
                width: 30,
                child: Icon(
                  Icons.lock,
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
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              title: Text("도움말"),
              leading: SizedBox(
                height: 50,
                width: 30,
                child: Icon(
                  Icons.help_outline,
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
              title: Text("정보"),
              leading: SizedBox(
                height: 50,
                width: 30,
                child: Icon(
                  Icons.info,
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
            child: Column(children: [
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10, bottom: 4),
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
                    top: 10, left: 16, right: 10, bottom: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '계정추가',
                    style: TextStyle(fontSize: 16, color: Colors.blue[400]),
                  ),
                ),
              ),
              Divider(),
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 16, right: 10, bottom: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '로그아웃',
                    style: TextStyle(fontSize: 16, color: Colors.blue[400]),
                  ),
                ),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => InfoPage(),
              //         ));
              //   },
              // ),
            ]),
          )
        ],
      ),
    );
  }
}
