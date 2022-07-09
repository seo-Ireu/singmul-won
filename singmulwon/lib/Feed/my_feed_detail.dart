import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../Provider/feeds.dart';
import '../feed_sql_helper.dart';

class MyFeedDetail extends StatefulWidget {
  static const routeName = '/my_feed_detail.dart';

  const MyFeedDetail({Key key}) : super(key: key);

  @override
  State<MyFeedDetail> createState() => _MyFeedDetailState();
}

class _MyFeedDetailState extends State<MyFeedDetail> {
  bool isPressed = false;
  bool _isLoading = true;
  List<Map<String, dynamic>> _feeds = [];

  void _refreshFeeds() async {
    final data = await FeedSQLHelper.getFeeds();

    setState(() {
      _feeds = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshFeeds(); // Loading the diary when the app starts
  }

  @override
  Widget build(BuildContext context) {
    final _index = ModalRoute.of(context).settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FeedDetail(_index),
    );
  }

  Widget FeedDetail(_index) {
    final _temp = Provider.of<Feeds>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Expanded(flex: 1, child: new InstaStories()),
        Flexible(
            child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        // 프로필 사진
                        Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/human_1.jpg')),
                          ),
                        ),
                        // //프로필 사진
                        SizedBox(
                          width: 10.0,
                        ),
                        //아이디
                        Text(
                          "lshhh",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                        // //아이디
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: null,
                    )
                  ],
                ),
              ),
              // 피드 사진
              Flexible(
                fit: FlexFit.loose,
                child: Image.asset(_temp.feeds[_index].imageUrl,
                    fit: BoxFit.cover),
              ),
              // //피드 사진

              //아이콘들
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                              isPressed ? Icons.favorite : Icons.heart_broken),
                          color: isPressed ? Colors.red : Colors.black,
                          onPressed: () {
                            setState(() {
                              isPressed = !isPressed;
                            });
                          },
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Icon(
                          Icons.comment,
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // _deleteItem(_feeds[index]['id']);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.abc),
                          onPressed: () {
                            // Navigator.of(context).pushNamed(
                            //     CreatePage.routeName,
                            //     arguments: (_feeds[index]['id']));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // //아이콘들
              // 본문
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _feeds[_index]['content'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // //본문
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // 코맨트 왼쪽 부분
                    // new Container(
                    //   height: 40.0,
                    //   width: 40.0,
                    //   decoration: new BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     image: new DecorationImage(
                    //         fit: BoxFit.fill,
                    //         image: new NetworkImage(
                    //             "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                    //   ),
                    // ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Add a comment...",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(_feeds[index]['createdAt'],
                    style: TextStyle(color: Colors.grey)),
              )
            ],
          ),
        ))
      ],
    );
  }
}
