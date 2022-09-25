import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Community/models/boast_plant_model.dart';
import 'package:flutter_singmulwon_app/Feed/my_feed_test.dart';

class BoastResult extends StatefulWidget {

  @override
  State<BoastResult> createState() => _BoastResultState();

}

class _BoastResultState extends State<BoastResult> {
  List<BoastPlantModel>_result = [];

  @override
  void initState(){
    super.initState();
    Future.delayed(Duration.zero, () {
      _result = ModalRoute.of(context).settings.arguments as List<BoastPlantModel>;
      print("_result = ${_result[0].userId}");
    });
  }



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _result.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyFeedPage(userId: _result[index].userId, currentUserId: "admin"))
          ),

          child: Container(
            margin:
            EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
            padding: EdgeInsets.symmetric(
                horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: Text("${index+1}"),
                    ),
                    SizedBox(width: 25.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _result[index].userId,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.0),
                      ],
                    ),
                      ],
                    ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "피드방문",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                  ],
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
