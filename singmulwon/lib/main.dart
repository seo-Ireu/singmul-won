// main.dart
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Community/community.dart';
import 'package:flutter_singmulwon_app/Community/community_detail.dart';
import 'package:flutter_singmulwon_app/Feed/insta_create.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Community/write_page.dart';
import 'Feed/insta_home.dart';
import 'Feed/insta_list.dart';
import 'Feed/my_feed.dart';
import 'Feed/my_feed_detail.dart';
import 'Plant/edit_plant.dart';
import 'Plant/insert_plant.dart';
import 'Plant/manage_plant.dart';
import 'Provider/feeds.dart';
import 'Provider/plants.dart';
import 'Login/signin.dart';
import 'home_page.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => Plants()),
    ChangeNotifierProvider(create: (context) => Feeds()),
  ], child: MyApp()));
  //수정: EditPlant에서 Provider 가져올 수 없다고 해서 수정함
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'singmul-won',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Login(),
        routes: {
          ManagePlant.routeName: (ctx) => ManagePlant(),
          EditPlant.routeName: (ctx) => EditPlant(),
          InsertPlant.routeName: (ctx) => InsertPlant(),
          CreatePage.routeName: (ctx) => CreatePage(),
          InstaList.routeName: (ctx) => InstaList(),
          InstaHome.routeName: (ctx) => InstaHome(),
          HomePage.routeName: (ctx) => HomePage('?'),
          MyFeed.routeName: (ctx) => MyFeed(),
          MyFeedDetail.routeName: (ctx) => MyFeedDetail(),
          Community.routeName: (ctx) => Community(),
          CommunityDetail.routeName: (ctx) => CommunityDetail(),
          WritePage.routeName: (ctx) => WritePage()
        });
  }
}

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLogin = false;
  _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = (prefs.get('isLogin') ?? false);

    setState(() {
      _isLogin = isLogin;
    });
  }

  @override
  void initState() {
    _checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !_isLogin ? _signInWidget() : HomePage('?');
  }

  Widget _signInWidget() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[SignIn()],
        ),
      ),
    );
  }
}
