import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'feed_test.dart';

import 'insta_create.dart';

Future fetchFeed() async {
  var url = 'http://54.177.126.159/ubuntu/flutter/feed/myfeed.php?userId=lyhthy6';
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
  home: MyFeedPage(),
  initialRoute: '/',
  routes: {
    // When we navigate to the "/" route, build the FirstScreen Widget
    // "/" Route로 이동하면, FirstScreen 위젯을 생성합니다.
    '/myfeed': (context) => MyFeedPage(),
    // "/second" route로 이동하면, SecondScreen 위젯을 생성합니다.
    '/feed': (context) => FeedPage(),
  },
));

class MyFeedPage extends StatefulWidget {
  const MyFeedPage({Key key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<MyFeedPage> {
  Future feeds;
  static const routeName = '/inst_home';

  @override
  void initState() {
    super.initState();
    feeds = fetchFeed();
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

  Widget buildColumn(snapshot) {
    String userid = 'lyhthy6';
    List<Widget> feedList = [];
    List<Widget> imgList = [];
    int cnt = snapshot.data["count"];
    feedList.add(
          Column(
            children: <Widget>[
              for(int i=0; i<cnt; i+=3)
                Row(
                  children: <Widget>[
                    Image.asset(snapshot.data["feed"][i]["feedImage"], width: 120, height: 120, fit: BoxFit.fill),
                    if(i+1 < cnt) Image.asset(snapshot.data["feed"][i+1]["feedImage"], width: 120, height: 120, fit: BoxFit.fill),
                    if(i+2 < cnt) Image.asset(snapshot.data["feed"][i+2]["feedImage"], width: 120, height: 120, fit: BoxFit.fill),
                  ],
                )
            ],
          )
      );

    List<Widget> lists = [
      Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                    userid,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                ),
              ],
            ),// ID, Setting 아이콘
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleAvatar(
                  radius: 40.0, backgroundImage: AssetImage("assets/human_1.jpg"),),
                Column(children: <Widget>[
                  Text('7', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  Text('게시글', style: const TextStyle(fontSize: 17)),
                ]), //게시물 수
                Column(children: <Widget>[
                  Text('206', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  Text('팔로워', style: const TextStyle(fontSize: 17)),
                ]), //팔로워 수
                Column(children: <Widget>[
                  Text('150', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  Text('팔로잉', style: const TextStyle(fontSize: 17)),
                ]),//팔로잉 수
                SizedBox(width: 7.0,),
              ],
            ), // 프사, 게시물 수, 팔로워 수, 팔로잉 수
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                    snapshot.data["name"],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
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
                              fontSize: 16.0,)
                      ),
                    ),
                ),
              ],
            ), // 자기소개
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlinedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 150)),
                  ),
                  child: Text('프로필 편집'),
                  )
                ],
            ), // 프로필 편집 or 팔로잉 or 팔로잉 취소
            SizedBox(height: 10.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: feedList,
            ),
            // 뒤에 GridView로 마이 피드 구성
          ],
      ),
    ];



    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/feed');
            },
            icon: const Icon(Icons.arrow_back),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CreatePage.routeName);
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
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/feed');
              },
              icon: Icon(Icons.home),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/myfeed');
                },
                icon: Icon(Icons.chat),
            ),
            label: 'My Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Community',
          ),
        ],
      ),
    );
  }
}