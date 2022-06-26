import 'package:flutter/material.dart';
import './insta_stories.dart';
import '../sql_helper.dart';
import 'dart:developer';

import 'insta_create.dart';

class InstaList extends StatefulWidget {
  static const routeName = '/inst_list';

  @override
  _InstaListState createState() => _InstaListState();
}

class _InstaListState extends State<InstaList> {
  bool isPressed = false;

  //SQL추가
  bool _isLoading = true;
  List<Map<String, dynamic>> _feeds = [];

  void _refreshFeeds() async {
    final data = await SQLHelper.getFeeds();

    setState(() {
      _feeds = data;
      _isLoading = false;
    });
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteFeed(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshFeeds();
  }

  @override
  void initState() {
    super.initState();
    _refreshFeeds(); // Loading the diary when the app starts
  }

  @override
  Widget build(BuildContext context) {
    log("Insta List");
    var deviceSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Expanded(flex: 1, child: new InstaStories()),
        Flexible(
            child: ListView.builder(
          itemCount: _feeds.length,
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
                        new Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                          ),
                        ),
                        // //프로필 사진
                        new SizedBox(
                          width: 10.0,
                        ),
                        //아이디
                        new Text(
                          "imthpk",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                        // //아이디
                      ],
                    ),
                    new IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: null,
                    )
                  ],
                ),
              ),
              // 피드 사진
              Flexible(
                fit: FlexFit.loose,
                child: new Image.network(
                  "https://images.pexels.com/photos/672657/pexels-photo-672657.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                  fit: BoxFit.cover,
                ),
              ),
              // //피드 사진

              //아이콘들
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new IconButton(
                          icon: new Icon(
                              isPressed ? Icons.favorite : Icons.heart_broken),
                          color: isPressed ? Colors.red : Colors.black,
                          onPressed: () {
                            setState(() {
                              isPressed = !isPressed;
                            });
                          },
                        ),
                        new SizedBox(
                          width: 16.0,
                        ),
                        new Icon(
                          Icons.comment,
                        ),
                        new SizedBox(
                          width: 16.0,
                        ),
                        new IconButton(
                          icon: new Icon(Icons.delete),
                          onPressed: () {
                            _deleteItem(_feeds[index]['id']);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.abc),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                CreatePage.routeName,
                                arguments: (_feeds[index]['id']));
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
                  _feeds[index]['content'],
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
                    new SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: new TextField(
                        decoration: new InputDecoration(
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
