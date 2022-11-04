// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePw extends StatefulWidget {
  @override
  State<ChangePw> createState() => _ChangePwState();
}

class _ChangePwState extends State<ChangePw> {
  final pwController = TextEditingController();

  Future ChangePwd(BuildContext context, userid, pw) async {
    var url = "http://13.209.68.93/ubuntu/flutter/my/update_pwd.php";
    var response = await http.post(Uri.parse(url), body: {
      "userid": userid,
      "pw": pw,
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: const Text('계정'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              width: 300,
              height: 60,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '비밀번호 변경',
                ),
                controller: pwController,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 110,
              height: 40,
              child: FlatButton(
                textColor: Colors.white,
                color: Color.fromARGB(255, 75, 143, 77),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  "변경",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  ChangePwd(
                    context,
                    userId,
                    pwController.text,
                  );
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ));
  }
}
