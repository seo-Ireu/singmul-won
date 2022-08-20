import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Feed/feed_comment_delete.dart';
import 'package:flutter_singmulwon_app/Feed/feed_delete_test.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'feed_comment_create_test.dart';
import 'feed_detail_test.dart';
import 'my_feed_test.dart';
import 'feed_test.dart';
import 'feed_create_test.dart';
import 'package:intl/intl.dart';

final _textController = new TextEditingController();

Future fetchFeed(String feedId, String userId) async {
  var url = 'http://54.177.126.159/ubuntu/flutter/feed/feed_comment.php?feedId='+feedId;
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var tmp = json.decode(utf8.decode(response.bodyBytes));
    print(tmp);
    return tmp;
  } else {
    throw Exception('Failed to load post');
  }
}

void main() => runApp(MaterialApp(
  home: FeedComment(),
  initialRoute: '/',
  routes: {
    // When we navigate to the "/" route, build the FirstScreen Widget
    // "/" Route로 이동하면, FirstScreen 위젯을 생성합니다.
    '/myfeed': (context) => MyFeedPage(),
    // "/second" route로 이동하면, SecondScreen 위젯을 생성합니다.
    '/feed': (context) => FeedPage(),
    '/feed_create': (context) => FeedCreate(),
    '/feed_detail': (context) => FeedDetail(),
  },
));


class FeedComment extends StatefulWidget {
  final String feedId;
  final String userId;
  const FeedComment({Key key, @required this.feedId, @required this.userId}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState(feedId, userId);
}

class _FeedPageState extends State<FeedComment> {
  Future feeds;
  String feedId;
  String userId;

  _FeedPageState(this. feedId, this. userId);

  @override
  void initState() {
    super.initState();
    feeds = fetchFeed(feedId, userId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
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
            )
        )
    );
  }

  //bool isPressed = false; // 좋아요 변수
  List<bool> isPressed = [];

  Widget buildColumn(snapshot) {
    int cnt = snapshot.data["count"];

    List<Widget> lists = [
      Column(
        children: <Widget>[
            for(int i=0; i<cnt; i++)
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 20.0, backgroundImage: AssetImage("assets/human_1.jpg"),),
                SizedBox(width: 10.0,), // 여백
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        children: <Widget>[
                          Text('${snapshot.data["comment"][i]["userId"]}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(width: 10.0,),
                          Text('${snapshot.data["comment"][i]["comment"]}',
                              style: const TextStyle(fontSize: 20)),
                        ],
                    ),
                    Row(
                      children: <Widget>[
                        TextButton(
                          child: Text('${snapshot.data["comment"][i]["updateAt"]}'),
                          onPressed: null,
                          style: TextButton.styleFrom(fixedSize: Size.fromHeight(1), padding: EdgeInsets.zero, primary: Colors.grey,), //글자색
                        ),
                        SizedBox(width: 5.0,),
                        //if(userId == '${snapshot.data["comment"][i]["userId"]}') TextButton(
                        //    child: Text("수정"),
                        //    onPressed: () {

                        //    },
                        //    style: TextButton.styleFrom(fixedSize: Size.fromHeight(1),padding: EdgeInsets.zero, primary: Colors.grey,), //글자색
                        //),
                        if(userId == '${snapshot.data["comment"][i]["userId"]}') TextButton(
                          child: Text("삭제"),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CommentDelete(userId: userId, feedCommentId: '${snapshot.data["comment"][i]["feedCommentId"]}', feedId: feedId)));
                          },
                          style: TextButton.styleFrom(fixedSize: Size.fromHeight(1),padding: EdgeInsets.zero, primary: Colors.grey,), //글자색
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          SizedBox(width: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child:
                TextFormField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    icon: CircleAvatar(
                      radius: 20.0, backgroundImage: AssetImage("assets/human_1.jpg"),),
                    labelText: '댓글 달기...',
                  ),
                ),
              ),
              TextButton(
                child: Text("게시"),
                onPressed: () {
                  String texts = _textController.text;
                  _textController.clear();
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          CommentCreate(userId: userId,
                              commentContent: texts,
                              feedId: feedId)));
                }
              ),
            ],
          ),

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
