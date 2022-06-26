// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Feed/insta_home.dart';
import 'Plant/manage_plant.dart';
import 'account.dart';
import 'community.dart';
import 'plant_feed.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
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

    return Scaffold();
  }
}
