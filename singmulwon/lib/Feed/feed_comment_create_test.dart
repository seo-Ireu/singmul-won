import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'feed_comment_test.dart';
import 'feed_detail_test.dart';
import 'my_feed_test.dart';
import 'feed_test.dart';
import 'feed_create_test.dart';

final _textController = new TextEditingController();

Future fetchFeed(String feedId, String userId, String commentContent) async {
  String formattedDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now()); // 임시 시간 변수
  var url =
      'http://54.177.126.159/ubuntu/flutter/feed/feed_comment_create.php?feedId=' +
          feedId +
          '&commentContent=' +
          commentContent +
          '&userId=' +
          userId +
          '&createAt=' +
          formattedDate +
          '&updateAt=' +
          formattedDate;
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var tmp = json.decode(utf8.decode(response.bodyBytes));
    print(tmp);
    return tmp;
  } else {
    throw Exception('Failed to load post');
  }
}

// void main() => runApp(MaterialApp(
//   home: CommentCreate(),
//   initialRoute: '/',
//   routes: {
//     // When we navigate to the "/" route, build the FirstScreen Widget
//     // "/" Route로 이동하면, FirstScreen 위젯을 생성합니다.
//     '/myfeed': (context) => MyFeedPage(),
//     // "/second" route로 이동하면, SecondScreen 위젯을 생성합니다.
//     '/feed': (context) => FeedPage(),
//     '/feed_create': (context) => FeedCreate(),
//     '/feed_detail': (context) => FeedDetail(),
//   },
// ));

class CommentCreate extends StatefulWidget {
  final String feedId;
  final String userId;
  final String commentContent;
  const CommentCreate(
      {Key key,
      @required this.feedId,
      @required this.userId,
      @required this.commentContent})
      : super(key: key);

  @override
  _FeedPageState createState() =>
      _FeedPageState(feedId, userId, commentContent);
}

class _FeedPageState extends State<CommentCreate> {
  Future feeds;
  String feedId;
  String userId;
  String commentContent;

  _FeedPageState(this.feedId, this.userId, this.commentContent);

  @override
  void initState() {
    super.initState();
    feeds = fetchFeed(feedId, userId, commentContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder(
        //통신데이터 가져오기
        future: feeds,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildColumn(snapshot);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}에러!!");
          }
          return const CircularProgressIndicator();
        },
      ),
    ));
  }

  //bool isPressed = false; // 좋아요 변수
  List<bool> isPressed = [];

  Widget buildColumn(snapshot) {
    List<Widget> lists = [
      Column(
        children: <Widget>[
          Text("게시가 완료되었습니다!"),
          TextButton(
            child: Text("돌아가기"),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FeedComment(
                          feedId: feedId,
                          userId: userId,
                        ))),
          )
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          padding: const EdgeInsets.all(3),
          children: lists,
        ),
      ),
    );
  }
}
