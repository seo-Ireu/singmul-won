import 'package:flutter/material.dart';

import 'Feed/insta_home.dart';
import 'Plant/manage_plant.dart';
import './home.dart';
import './community.dart';
import './account.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homepage';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 2;
  final List<Widget> widgetOptions = <Widget>[
    InstaHome(),
    ManagePlant(),
    Home(),
    Community(),
    Account(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
