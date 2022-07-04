// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';

String data_title = '';
String data_content = '';

class data {
  void setTitle(String title, String content) {
    data_title = title;
    data_content = content;
  }
}

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  data d = new data();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '게시판',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(data_title), //제목
                  ],
                ),
                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 10)),
                Divider(
                  color: Colors.black,
                  thickness: 2.0,
                ),
                Padding(padding: EdgeInsets.fromLTRB(10, 40, 10, 10)),
                Row(
                  children: <Widget>[
                    Text(data_content), //내용
                  ],
                ),
                Padding(padding: EdgeInsets.fromLTRB(10, 150, 10, 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
