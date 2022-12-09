// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Feed/feed_test.dart';
import 'package:flutter_singmulwon_app/Feed/my_feed_test.dart';
import 'dart:developer';

import 'Community/screens/community_home_screen.dart';
import 'Plant/manage_plant.dart';
import 'Account/account.dart';

class HomePage extends StatefulWidget {
  final String userid;
  HomePage(this.userid);

  static const routeName = '/homepage';
  @override
  State<HomePage> createState() => _HomePageState(userid);
}

String tests_id = "";

class _HomePageState extends State<HomePage> {
  int selectedIndex = 2;
  _HomePageState(tests_id);

  final List<Widget> widgetOptions = <Widget>[
    // MyFeedPage(userId: tests_id),
    MyFeedPage(userId: tests_id, currentUserId: tests_id),
    ManagePlant(),
    FeedPage(userid: tests_id),
    CommunityHomeScreen(),
    Account(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context).settings.arguments ??
        <String, String>{}) as Map;
    log(arguments['userid']);
    setState(() {
      tests_id = arguments['userid'];
    });

    return Scaffold(
      body: SafeArea(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'feed'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_florist), label: 'plant'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'community'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'my'),
        ],
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
