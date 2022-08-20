import 'package:flutter/material.dart';
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
            fontSize: 28.0,
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
              Navigator.pushNamed(context, CommunityWriteScreen.routeName);
              },
          ),
        ],
      ),
      body: CategorySelector(),
    );
  }
}
