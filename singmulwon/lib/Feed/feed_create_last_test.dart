import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'feed_test.dart';
import 'my_feed_test.dart';

String img_url = "/home/ubuntu/flutter/feed/image/";

Future fetchFeed(String userId, String feedContent, String feedUrl) async {
  var url =
      'http://13.209.68.93/ubuntu/flutter/feed/feed_create.php?userId=$userId&feedContent=$feedContent&feedUrl=$img_url$feedUrl';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    //만약 서버가 ok응답을 반환하면, json을 파싱합니다
    print('응답했다');
    var tmp;
    if(utf8.decode(response.bodyBytes).isNotEmpty) {
      tmp = json.decode(response.body);
    }
    print(tmp);
    return tmp;
  } else {
    //만약 응답이 ok가 아니면 에러를 던집니다.
    throw Exception();
  }
}

// void main() => runApp(MaterialApp(
//   home: FeedCreateRegister(),
//   initialRoute: '/',
//   routes: {
//     // When we navigate to the "/" route, build the FirstScreen Widget
//     // "/" Route로 이동하면, FirstScreen 위젯을 생성합니다.
//     // "/second" route로 이동하면, SecondScreen 위젯을 생성합니다.
//     '/feed': (context) => FeedPage(),
//     '/feed_create': (context) => FeedCreate(),
//     '/feed_create_register': (context) => FeedCreateRegister(),
//     '/myfeed': (context) => MyFeedPage(),
//   },
// ));

class FeedCreateRegister extends StatefulWidget {
  final String userId;
  final String feedContent;
  final String feedUrl;
  const FeedCreateRegister(
      {Key key,
      @required this.userId,
      @required this.feedContent,
      @required this.feedUrl})
      : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState(userId, feedContent, feedUrl);
}

class _FeedPageState extends State<FeedCreateRegister> {
  Future feeds;
  String userId;
  String feedContent;
  String feedUrl;
  static const routeName = '/inst_home';

  _FeedPageState(this.userId, this.feedContent, this.feedUrl);

  @override
  void initState() {
    super.initState();
    feeds = fetchFeed(userId, feedContent, feedUrl);
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
      )
    );
  }

  Widget buildColumn(snapshot) {

    List<Widget> lists = [
      Center(
          child: Column(
        children: <Widget>[
          Text("게시가 완료되었습니다!"),
          OutlinedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyFeedPage(userId: userId, currentUserId: userId)));
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 150)),
            ),
            child: Text('돌아가기'),
          )
        ],
      )),
    ];
    //Navigator.push(context, MaterialPageRoute(builder: (context) => MyFeedPage()));
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyFeedPage(userId: userId, currentUserId: userId)));
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
