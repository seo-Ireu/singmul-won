import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'feed_test.dart';
import 'feed_detail_test.dart';
import 'my_feed_test.dart';

Future fetchFeed(String userId, String currentId) async {
  var url = 'http://13.209.68.93/ubuntu/flutter/feed/feed_delete_follow.php?userId='+userId+'&currentId='+currentId;
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var tmp = json.decode(utf8.decode(response.bodyBytes));
    print(tmp);
    return tmp;
  } else {
    throw Exception('Failed to load post');
  }
}

class DeleteFollow extends StatefulWidget {
  final String userId;
  final String currentUserId;
  const DeleteFollow({Key key, @required this.userId, @required this.currentUserId}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState(userId, currentUserId);
}

class _FeedPageState extends State<DeleteFollow> {
  String userId;
  String currentUserId;

  _FeedPageState(this.userId, this.currentUserId);

  @override
  void initState() {
    super.initState();
    fetchFeed(userId, currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('팔로잉 취소'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          Expanded(
            child: Text("팔로잉 취소 완료!"),
          ),
          TextButton(
            child: Text("돌아가기"),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyFeedPage(userId: currentUserId, currentUserId: currentUserId))),
          )
        ],
      ),
    );
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
            Text("팔로잉 취소 완료!"),
          ],
        ),
      ),
    );
  }

}

//ProfileEdit(userId: userId, currentUserId: currentUserId)));