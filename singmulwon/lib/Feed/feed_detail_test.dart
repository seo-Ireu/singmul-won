import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'my_feed_test.dart';
import 'feed_test.dart';
import 'feed_create_test.dart';

Future fetchFeed(String feedId) async {
  var url = 'http://54.177.126.159/ubuntu/flutter/feed/feed_detail.php?userId=lyhthy6&feedId='+feedId;
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
  home: FeedPage(),
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

String all_feedId;

class FeedDetail extends StatefulWidget {
  final String feedId;
  FeedDetail({Key key, @required this.feedId}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState(feedId);
}

class _FeedPageState extends State<FeedDetail> {
  Future feeds;
  String feedId;
  static const routeName = '/inst_home';

  _FeedPageState(this. feedId);

  @override
  void initState() {
    super.initState();
    feeds = fetchFeed(feedId);
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
  var now = new DateTime.now(); // 임시 시간 변수

  Widget buildColumn(snapshot) {
    List<Widget> lists = [];

    for(int i=0; i<snapshot.data["count"]; i++){
      isPressed.add(false);
      lists.add(
          Card(
              margin: EdgeInsets.only(bottom: 20),
              child:
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽으로 정렬
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
                          children: <Widget>[
                            CircleAvatar(
                              radius: 20.0, backgroundImage: AssetImage("assets/human_1.jpg"),),
                            SizedBox(width: 10.0,), // 여백
                            Text('${snapshot.data["feed"][i]["userId"]}',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
                          children: <Widget>[
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.more_horiz)),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 5.0,),
                    Image.asset(
                        '${snapshot.data["feed"][i]["feedImage"]}', width: 400, height: 400, fit: BoxFit.fill),
                    SizedBox(height: 5.0,), // 여백
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(isPressed[i] ? Icons.favorite : Icons.favorite_border),
                          color: isPressed[i] ? Colors.red : Colors.black,
                          onPressed: () {
                            setState(() {
                              isPressed[i] = !isPressed[i];
                            });
                          },
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.chat_bubble_outline),
                        ),
                      ],
                    ),

                    SizedBox(height: 5.0,), // 여백
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('${snapshot.data["feed"][i]["userId"]}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(width: 5.0,), // 여백
                        Text('${snapshot.data["feed"][i]["content"]}',
                            style: const TextStyle(fontSize: 20))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(DateFormat('yyyy년 MM월 dd일 HH:mm:ss').format(now))
                      ],
                    ),
                    SizedBox(height: 5.0,), // 여백
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child:
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: CircleAvatar(
                                radius: 20.0, backgroundImage: AssetImage("assets/human_1.jpg"),),
                              suffixIcon: Icon(Icons.arrow_forward),
                              labelText: '댓글 달기...',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
          )
      );
    }

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
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
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
