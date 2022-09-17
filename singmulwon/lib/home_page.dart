// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Feed/feed_test.dart';
import 'package:flutter_singmulwon_app/Feed/my_feed_test.dart';
import 'dart:developer';

import 'Community/screens/community_home_screen.dart';
import 'Plant/manage_plant.dart';
import 'Account/account.dart';

class HomePage extends StatefulWidget {
  String userid = '';
  HomePage(this.userid);

  static const routeName = '/homepage';
  @override
  State<HomePage> createState() => _HomePageState();
}

String tests_id = "";

class _HomePageState extends State<HomePage> {
  int selectedIndex = 2;
  final List<Widget> widgetOptions = <Widget>[
    // MyFeedPage(userId: tests_id),
    MyFeedPage(userId: 'lyhthy6'),
    ManagePlant(),
    FeedPage(),
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
        backgroundColor: Colors.green[50],
        selectedItemColor: Colors.green[600],
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
      ),
    );
  }
}
