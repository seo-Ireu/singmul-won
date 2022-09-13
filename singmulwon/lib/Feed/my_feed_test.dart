import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Feed/profile_edit_test.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'feed_create_register_test.dart';
import 'feed_follower_test.dart';
import 'feed_following_test.dart';
import 'feed_test.dart';
import 'feed_detail_test.dart';
import 'feed_create_test.dart';

Future fetchFeed(String userId) async {
  var url =
      'http://54.177.126.159/ubuntu/flutter/feed/myfeed.php?userId=$userId';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var tmp = json.decode(utf8.decode(response.bodyBytes));
    return tmp;
  } else {
    throw Exception('Failed to load post');
  }
}

// void main() => runApp(MaterialApp(
//   home: MyFeedPage(),
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

class MyFeedPage extends StatefulWidget {
  static const routeName = '/my_feed_test.dart';
  final String userId;

  MyFeedPage({Key key, @required this.userId}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState(userId);
}

class _FeedPageState extends State<MyFeedPage> {
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
    Size size = MediaQuery.of(context).size;
    List<Widget> feedList = [];
    List<Widget> imgList = [];
    String userid = userId;
    int cnt = snapshot.data["count"];
    String feedCount =
        '${snapshot.data["count"]}'; //snapshot.data["count"] as String;
    String follower =
        '${snapshot.data["follower"]}'; //snapshot.data["follower"] as String;
    String following =
        '${snapshot.data["following"]}'; //snapshot.data["following"] as String;
    feedList.add(Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          for (int i = cnt - 1; i >= 0; i -= 3)
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FeedDetail(
                                feedId: snapshot.data["feed"][i]["feedId"],
                                userId: userId)));
                  },
                  child: Image.network(
                      'http://54.177.126.159/ubuntu/flutter/feed/image/' +
                          snapshot.data["feed"][i]["feedImage"],
                      width: size.width * 0.293,
                      height: size.height * 0.13,
                      fit: BoxFit.fill),
                ),
                SizedBox(
                  width: 5.0,
                ),
                if (i - 1 >= 0)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedDetail(
                                  feedId: snapshot.data["feed"][i - 1]
                                      ["feedId"],
                                  userId: userId)));
                    },
                    child: Image.network(
                        'http://54.177.126.159/ubuntu/flutter/feed/image/' +
                            snapshot.data["feed"][i - 1]["feedImage"],
                        width: size.width * 0.293,
                        height: size.height * 0.13,
                        fit: BoxFit.fill),
                  ),
                SizedBox(
                  width: 5.0,
                ),
                if (i - 2 >= 0)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedDetail(
                                  feedId: snapshot.data["feed"][i - 2]
                                      ["feedId"],
                                  userId: userId)));
                    },
                    child: Image.network(
                        'http://54.177.126.159/ubuntu/flutter/feed/image/' +
                            snapshot.data["feed"][i - 2]["feedImage"],
                        width: size.width * 0.293,
                        height: size.height * 0.13,
                        fit: BoxFit.fill),
                  ),
              ],
            ),
        ],
      ),
    ));

    List<Widget> lists = [
      Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('${userid}',
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)),
            ],
          ), // ID, Setting 아이콘
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundImage: NetworkImage(
                    'http://54.177.126.159/ubuntu/flutter/account/image/${snapshot.data["image"]}'),
              ),
              Column(children: <Widget>[
                Text(feedCount,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold)),
                Text('게시글', style: const TextStyle(fontSize: 17)),
              ]), //게시물 수
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyFollower(userId: userid)));
                },
                child: Column(children: <Widget>[
                  Text(follower,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  Text('팔로워', style: const TextStyle(fontSize: 17)),
                ]),
                style: TextButton.styleFrom(
                  primary: Colors.black, //글자색
                ),
              ), //팔로워 수
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyFollowing(userId: userid)));
                },
                child: Column(children: <Widget>[
                  Text(following,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  Text('팔로잉', style: const TextStyle(fontSize: 17)),
                ]),
                style: TextButton.styleFrom(
                  primary: Colors.black, //글자색
                ),
              ), //팔로잉 수
              SizedBox(
                width: 7.0,
              ),
            ],
          ), // 프사, 게시물 수, 팔로워 수, 팔로잉 수
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(snapshot.data["name"],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ), // 이름
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  strutStyle: StrutStyle(fontSize: 16.0),
                  text: TextSpan(
                      text: snapshot.data["profileIntro"],
                      style: TextStyle(
                        color: Colors.black,
                        height: 1.4,
                        fontSize: 16.0,
                      )),
                ),
              ),
            ],
          ), // 자기소개
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //OutlinedButton(
              //onPressed: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileEdit(userId: userId)));
              //},
              //style: ButtonStyle(
              //    padding: MaterialStateProperty.all(
              //        const EdgeInsets.symmetric(horizontal: 150)),
              //),
              //child: Text('프로필 편집'),
              // )
            ],
          ), // 프로필 편집 or 팔로잉 or 팔로잉 취소
          SizedBox(
            height: 10.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: feedList,
          ),
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => FeedPage()));
            },
            icon: const Icon(Icons.add),
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
