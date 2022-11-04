import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'feed_test.dart';
import 'feed_detail_test.dart';
import 'my_feed_test.dart';

Future fetchFeed(String userId) async {
  var url =
      'http://13.209.68.93/ubuntu/flutter/feed/feed_following.php?userId=' +
          userId;
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var tmp = json.decode(utf8.decode(response.bodyBytes));
    return tmp;
  } else {
    throw Exception('Failed to load post');
  }
}

// void main() => runApp(MaterialApp(
//   home: MyFollowing(),
//   initialRoute: '/',
//   routes: {
//     // When we navigate to the "/" route, build the FirstScreen Widget
//     // "/" Route로 이동하면, FirstScreen 위젯을 생성합니다.
//     '/myfeed': (context) => MyFeedPage(),
//     // "/second" route로 이동하면, SecondScreen 위젯을 생성합니다.
//     '/feed': (context) => FeedPage(),
//     '/feed_create': (context) => FeedCreate(),
//   },
// ));

class MyFollowing extends StatefulWidget {
  final String userId;
  const MyFollowing({Key key, @required this.userId}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState(userId);
}

class _FeedPageState extends State<MyFollowing> {
  String userId;

  _FeedPageState(this.userId);
  Future feeds;

  @override
  void initState() {
    super.initState();
    feeds = fetchFeed(userId);
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

  Widget buildColumn(snapshot) {
    int cnt = snapshot.data["count"];

    List<Widget> lists = [
      Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('팔로워'),
            ],
          ),
          for (int i = 0; i < cnt; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                      'http://13.209.68.93/ubuntu/flutter/account/image/' +
                          snapshot.data["follow"][i]["image"]),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyFeedPage(
                                    userId:
                                        '${snapshot.data["follow"][i]["toUser"]}',
                                    currentUserId:
                                        userId)));
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.black, //글자색
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('${snapshot.data["follow"][i]["toUser"]}',
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                            Text('${snapshot.data["follow"][i]["nickname"]}',
                                style: const TextStyle(fontSize: 17)),
                          ]),
                    ),
                  ],
                )
              ],
            ), // ID, Setting 아이콘
          // 뒤에 GridView로 마이 피드 구성
        ],
      ),
    ];

    int _selectedIndex = 0;
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
