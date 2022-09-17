import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'feed_comment_create_test.dart';
import 'feed_comment_test.dart';
import 'feed_delete_test.dart';
import 'image_upload.dart';
import 'my_feed_test.dart';
import 'feed_test.dart';
import 'feed_create_register_test.dart';
import 'feed_detail_test.dart';
import 'feed_create_test.dart';

final _nameController = new TextEditingController();
final _IntroController = new TextEditingController();
final _IdController = new TextEditingController();

Future fetchFeed(String userId) async {
  var url =
      'http://13.209.68.93/ubuntu/flutter/feed/profile_edit.php?userId=' +
          userId;
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

// void main() => runApp(MaterialApp(
//   home: ProfileEdit(),
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

class ProfileEdit extends StatefulWidget {
  final String userId;

  const ProfileEdit({Key key, @required this.userId}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState(userId);
}

class _FeedPageState extends State<ProfileEdit> {
  Future feeds;
  String userId;

  _FeedPageState(this.userId);

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
    _nameController.text = snapshot.data["name"];
    _IntroController.text = snapshot.data["profile_intro"];
    _IdController.text = snapshot.data["userId"];

    List<Widget> lists = [
      Center(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage(
                  'http://13.209.68.93/ubuntu/flutter/account/image/' +
                      snapshot.data["image_id"]),
            ),
            OutlinedButton(onPressed: () {}, child: Text("프로필 사진 변경")),
            Expanded(
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  icon: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage("assets/human_1.jpg"),
                  ),
                  labelText: '이름',
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: _IdController,
                decoration: const InputDecoration(
                  icon: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage("assets/human_1.jpg"),
                  ),
                  labelText: 'ID',
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: _IntroController,
                decoration: const InputDecoration(
                  icon: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage("assets/human_1.jpg"),
                  ),
                  labelText: '소개글',
                ),
              ),
            ),
            // 뒤에 GridView로 마이 피드 구성
          ],
        ),
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
