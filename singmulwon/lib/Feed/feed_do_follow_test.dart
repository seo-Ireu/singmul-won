import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'feed_create_register_test.dart';
import 'feed_test.dart';
import 'feed_detail_test.dart';
import 'feed_create_test.dart';
import 'image_upload.dart';
import 'my_feed_test.dart';

Future fetchFeed(String userId, String currentId) async {
  var url = 'http://13.209.68.93/ubuntu/flutter/feed/feed_doing_follow.php?userId='+userId+'&currentId='+currentId;
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var tmp = json.decode(utf8.decode(response.bodyBytes));
    print(tmp);
    return tmp;
  } else {
    throw Exception('Failed to load post');
  }
}

class DoingFollow extends StatefulWidget {
  final String userId;
  final String currentUserId;
  const DoingFollow({Key key, @required this.userId, @required this.currentUserId}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState(userId, currentUserId);
}

class _FeedPageState extends State<DoingFollow> {
  String userId;
  String currentUserId;

  _FeedPageState(this.userId, this.currentUserId);

  Future feeds;

  @override
  void initState() {
    super.initState();
    feeds = fetchFeed(userId, currentUserId);
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
                return Text("${snapshot.error}에러!!${currentUserId}");
              }
              return const CircularProgressIndicator();
            },
          ),
        ));
  }

  Widget buildColumn(snapshot) {
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
          children: <Widget>[
            Text("팔로잉 완료!"),
          ],
        ),
      ),
    );
  }

}

//ProfileEdit(userId: userId, currentUserId: currentUserId)));