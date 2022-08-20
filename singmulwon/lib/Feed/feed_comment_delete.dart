import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'feed_comment_delete_last_test.dart';
import 'feed_delete_last_test.dart';
import 'my_feed_test.dart';
import 'feed_test.dart';
import 'feed_create_register_test.dart';

final _textController = new TextEditingController();

void main() => runApp(MaterialApp(
  home: CommentDelete(),
  initialRoute: '/',
  routes: {
    // When we navigate to the "/" route, build the FirstScreen Widget
    // "/" Route로 이동하면, FirstScreen 위젯을 생성합니다.
    '/myfeed': (context) => MyFeedPage(),
    // "/second" route로 이동하면, SecondScreen 위젯을 생성합니다.
    '/feed': (context) => FeedPage(),
    '/feed_create_register': (context) => FeedCreateImage(),
  },
)
);

class CommentDelete extends StatefulWidget {
  final String userId;
  final String feedCommentId;
  final String feedId;

  const CommentDelete({Key key, @required this.userId, @required this.feedCommentId, @required this.feedId}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState(userId, feedCommentId, feedId);
}

class _FeedPageState extends State<CommentDelete> {
  String userId;
  String feedCommentId;
  String feedId;

  _FeedPageState(this. userId, this. feedCommentId, this. feedId);


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('피드 삭제'),
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
            SizedBox(height: 50.0,),
            Expanded(
              child:
              Text("해당 댓글를 정말로 삭제하시겠습니까?"),
            ),
            TextButton(child: Text("삭제"), onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => CommentDeleteResgister(userId: userId, feedCommentId: feedCommentId, feedId: feedId))),)
          ],
        ),
      ),
    );
  }
}