import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'insta_create.dart';

Future fetchFeed() async {
  var url = 'http://54.177.126.159/ubuntu/flutter/feed/feed.php';
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

void main() => runApp(const FeedPage());

class FeedPage extends StatefulWidget {
  const FeedPage({Key key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
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
    List<Widget> lists = [];

    for (int i = 0; i < snapshot.data["count"]; i++) {

    }
    return Scaffold(
      appBar: AppBar(
        actions: [
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
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