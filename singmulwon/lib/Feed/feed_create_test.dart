import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'my_feed_test.dart';
import 'feed_test.dart';


import 'insta_create.dart';
import 'insta_list.dart';

Future fetchFeed() async {
  var url = 'http://54.177.126.159/ubuntu/flutter/feed/feed.php?userId=lyhthy6';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    //만약 서버가 ok응답을 반환하면, json을 파싱합니다
    print('응답했다');
    var tmp = json.decode(utf8.decode(response.bodyBytes));
    print(tmp);
    return tmp;
  } else {
    //만약 응답이 ok가 아니면 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

void main() => runApp(MaterialApp(
  home: FeedCreate(),
  initialRoute: '/',
  routes: {
    // When we navigate to the "/" route, build the FirstScreen Widget
    // "/" Route로 이동하면, FirstScreen 위젯을 생성합니다.
    '/myfeed': (context) => MyFeedPage(),
    // "/second" route로 이동하면, SecondScreen 위젯을 생성합니다.
    '/feed': (context) => FeedPage(),
    '/feed_create': (context) => FeedCreate(),
  },
));

class FeedCreate extends StatefulWidget {
  const FeedCreate({Key key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

void saveFeed(){
  Future feeds;
  feeds = fetchFeed();
}

class _FeedPageState extends State<FeedCreate> {
  Future feeds;
  Widget ff;
  static const routeName = '/inst_home';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ff = buildColumn();
    return MaterialApp(
        home: Scaffold(
            body: buildColumn(),
        )
    );
  }

  Widget buildColumn() {
    List<Widget> lists = [

    ];
    
    return Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          padding: const EdgeInsets.all(3),
          children: <Widget>[
            Column(
              children: [
                Row(
                  children: [
                    Image.asset('assets/plant_1.jfif'),
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
  }
}