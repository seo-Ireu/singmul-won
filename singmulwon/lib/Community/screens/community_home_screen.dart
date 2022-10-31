import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Community/screens/boast_home_screen.dart';
import 'package:flutter_singmulwon_app/Community/screens/community_write_screen.dart';
import '../widgets/category_selector.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CommunityHomeScreen extends StatefulWidget {
  static const routeName = '/community_home_screen.dart';
  @override
  _CommunityHomeScreenState createState() => _CommunityHomeScreenState();
}

class _CommunityHomeScreenState extends State<CommunityHomeScreen> {

  var _userid;

  @override
  void initState() {
    super.initState();
  }

  bool value = false;
  void changeData(){
    setState(() {
      value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context).settings.arguments ??
        <String, String>{}) as Map;
    _userid = arguments['userid'];
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Color(0x7C476649),
        children: [
          SpeedDialChild(
            child:Icon(Icons.add),
            label: '글작성',
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CommunityWriteScreen()))
                  .then((value) {
                setState(() {});
              });
            },
          ),
          SpeedDialChild(
            child:Icon(Icons.local_activity_rounded),
            label: '뽐내기',
            onTap: (){
          Navigator.of(context)
              .pushNamed(BoastHomeScreen.routeName);
            }
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(
          'Daily daily',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
      ),
      body: CategorySelector(),
    );
  }
}
