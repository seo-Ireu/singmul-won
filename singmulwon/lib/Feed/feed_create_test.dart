import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'my_feed_test.dart';
import 'feed_test.dart';
import 'feed_create_register_test.dart';
import 'package:image_picker/image_picker.dart';

final _textController = new TextEditingController();

// void main() => runApp(MaterialApp(
//   home: FeedCreate(),
//   initialRoute: '/',
//   routes: {
//     // When we navigate to the "/" route, build the FirstScreen Widget
//     // "/" Route로 이동하면, FirstScreen 위젯을 생성합니다.
//     '/myfeed': (context) => MyFeedPage(),
//     // "/second" route로 이동하면, SecondScreen 위젯을 생성합니다.
//     '/feed': (context) => FeedPage(),
//     '/feed_create': (context) => FeedCreate(),
//     '/feed_create_register': (context) => FeedCreateImage(),
//   },
//   )
// );

class FeedCreate extends StatefulWidget {
  static const routeName = '/feed_create_test.dart';
  final String userId;
  const FeedCreate({Key key, @required this.userId}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState(userId);
}

class _FeedPageState extends State<FeedCreate> {
  String userId;

  _FeedPageState(this.userId);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String trans_text;
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 등록'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          Expanded(
            child: TextField(
              controller: _textController,
            ),
          ),
          TextButton(
            child: Text("이미지 업로드"),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FeedCreateImage(
                        userId: userId, feedContent: _textController.text))),
          )
        ],
      ),
    );
  }

  Widget buildColumn() {
    List<Widget> lists = [];
  }

  void _handleSubmitted(String text) {
    print(text);
    _textController.clear(); //입력 후 텍스트창 비워준다.
  }
}
