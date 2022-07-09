import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../Provider/feeds.dart';
import '../feed_sql_helper.dart';
import 'insta_home.dart';
import 'insta_list.dart';
import 'my_feed_detail.dart';

class MyFeed extends StatefulWidget {
  static const routeName = '/my_feed';
  const MyFeed({Key key}) : super(key: key);

  @override
  State<MyFeed> createState() => _MyFeedState();
}

class _MyFeedState extends State<MyFeed> {
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
    _refreshFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        createProfileTopView(),
      ],
    ));
  }

  createProfileTopView() {
    final _temp = Provider.of<Feeds>(context);
    return Padding(
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(height: 20),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context); //뒤로가기
                  },
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // 사용자 이름
                children: [
                  Text(
                    "lshhhh",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        letterSpacing: 0.4),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage('assets/human_1.jpg'),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // 게시글, 팔로워, 팔로잉 수 (임시로 숫자 박아놓자)
                          createColumns('posts', 4),
                          createColumns('followers', 103),
                          createColumns('following', 90),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            // 사용자 이름
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20),
              Text(
                "lshhhhh",
                style: TextStyle(
                    color: Colors.black, fontSize: 18, letterSpacing: 0.4),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            // 사용자 이름
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20),
              Text(
                "다육이를 좋아해요",
                style: TextStyle(
                    color: Colors.black, fontSize: 16, letterSpacing: 0.4),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            // 상황에 따라 Edit profile, follow, unfollow 버튼으로 분기처리
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              createButton(),
            ],
          ),
          // ignore: prefer_const_constructors

          SizedBox(height: 20),
          GridView.count(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            crossAxisCount: 3,
            children: List.generate(_feeds.length, (index) {
              //item 의 반목문 항목 형성
              return GestureDetector(
                // When the child is tapped, show a snackbar.
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(MyFeedDetail.routeName, arguments: (index));
                },
                // The custom button
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[200],
                  ),
                  child: Flexible(
                    fit: FlexFit.loose,
                    child: new Image.asset(_temp.feeds[index].imageUrl,
                        fit: BoxFit.cover),
                  ),
                  // //피드 사진,
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  // 게시글/팔로워/팔로잉
  Column createColumns(String title, int count) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$count',
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }

  // 팔로우/언팔로우 상태에 따라 보여줘야 함
  createButton() {
    bool ownProfile = true; //
    if (ownProfile) {
      // 본인의 프로필을 보려는 경우
      return createButtonTitleAndFunction(
        title: 'Edit Profile',
        performFunction: editUserProfile,
      );
    } else {
      // return
    }
  }

  // 본인의 프로필인 경우 Edit Profile 버튼을 보여주고, 그에맞게 동작하도록 구
  createButtonTitleAndFunction({String title, Function performFunction}) {
    return Container(
      padding: EdgeInsets.only(top: 3),
      child: FlatButton(
        onPressed: () {
          performFunction;
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.03,
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.green[400], borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  // 버튼 클릭시 Edit 페이지로 전환
  editUserProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Container(),
        ));
  }
}
