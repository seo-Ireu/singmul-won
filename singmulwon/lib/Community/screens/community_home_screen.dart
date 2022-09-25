import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Community/screens/boast_home_screen.dart';
import 'package:flutter_singmulwon_app/Community/screens/community_write_screen.dart';
import '../widgets/category_selector.dart';

class CommunityHomeScreen extends StatefulWidget {
  static const routeName = '/community_home_screen.dart';
  @override
  _CommunityHomeScreenState createState() => _CommunityHomeScreenState();
}

class _CommunityHomeScreenState extends State<CommunityHomeScreen> {

  bool value = false;
  void changeData(){
    setState(() {
      value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          'Daily daily',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(CommunityWriteScreen.routeName);
              },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(BoastHomeScreen.routeName);
            },
            child: Row(children: [
              Icon(Icons.favorite, color: Colors.green[700]),
              Text(
                '뽐내기',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.green[700],
                ),
              ),
            ]),
          ),
        ],
      ),
      body: CategorySelector(),
    );
  }
}
