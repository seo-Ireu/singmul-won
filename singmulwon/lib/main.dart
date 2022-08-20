// main.dart
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Community/community.dart';
import 'package:flutter_singmulwon_app/Community/community_detail.dart';
import 'package:flutter_singmulwon_app/Feed/feed_test.dart';
import 'package:flutter_singmulwon_app/Feed/my_feed_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Community/screens/community_detail_screen.dart';
import 'Community/screens/community_home_screen.dart';
import 'Community/screens/community_write_screen.dart';
import 'Community/write_page.dart';
import 'Feed/feed_create_test.dart';
import 'Feed/feed_detail_test.dart';
import 'Plant/edit_plant.dart';
import 'Plant/insert_plant.dart';
import 'Plant/manage_plant.dart';
import 'Provider/feeds.dart';
import 'Login/signin.dart';
import 'home_page.dart';

void main() {
  runApp(MultiProvider(providers: [
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
          FeedCreate.routeName: (ctx) => FeedCreate(),
          FeedPage.routeName: (ctx) => FeedPage(),
          HomePage.routeName: (ctx) => HomePage('?'),
          MyFeedPage.routeName: (ctx) => MyFeedPage(userId: "lyhthy6"),
          FeedDetail.routeName: (ctx) => FeedDetail(),

          CommunityHomeScreen.routeName: (ctx) => CommunityHomeScreen(),
          CommunityDetailScreen.routeName: (ctx) => CommunityDetailScreen(),
          CommunityWriteScreen.routeName: (ctx) => CommunityWriteScreen()
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
