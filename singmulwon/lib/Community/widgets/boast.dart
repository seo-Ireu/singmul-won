import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import '../models/boast_plant_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../screens/boast_result_screen.dart';
class Boast extends StatefulWidget {

  @override
  State<Boast> createState() => _BoastState();
}

class _BoastState extends State<Boast> {
  String baseUrl = dotenv.env['BASE_URL'];
  List<BoastPlantModel> _boastPlants = [];

  int _selectedMyPlantId = -1;
  int _selectedIndex = 0;

  List<BoastPlantModel> _likesIds =[];


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _loadRandomPlants();
    });
  }

  Future _loadRandomPlants() async {
    var url = baseUrl+"/community/get_random_plants.php";

    var response = await http.get(Uri.parse(url));
    String jsonData = response.body;

    if (response.statusCode == 200) {
      var results = json.decode(utf8.decode(response.bodyBytes));

      List<BoastPlantModel> bps = [];
      for (var i in results['random_plants']) {
        BoastPlantModel bpm = BoastPlantModel(
            feedId: int.parse(i['feedId']),
            userId: i['userId'],
            urls: "http://13.209.68.93/ubuntu/flutter/feed/image/"+i['urls'],
            myPlantId: int.parse(i['myPlantId'])
        );
        print("${bpm.feedId}, ${bpm.myPlantId}, ${bpm.urls}, ${bpm.userId}");
        bps.add(bpm);
      }
      setState(() {
        _boastPlants = bps;
        _selectedMyPlantId = _boastPlants[0].myPlantId;
      });
      print(_boastPlants.length);
    } else {
      throw Exception('Failed to load post');
    }

  }

  Future _addLikes(int myPlantId) async{
    var url = baseUrl+"/community/add_likes.php";

    var response = await http.post(Uri.parse(url), body: {
      "myPlantId": myPlantId.toString(),

    });

    if(response.body.isNotEmpty) {
      var message = json.decode(response.body);
      print(message);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height:50),
          Container(
            height: MediaQuery.of(context).size.height*0.5,
            child: new Swiper(
              itemBuilder: (BuildContext context,int index){
                return Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Image.network(_boastPlants[index].urls,
                              fit: BoxFit.fill
                          ),
                        ],
                      ),
                    ));
                // return new Image.network('http://13.209.68.93/ubuntu/flutter/community/flutter_upload_image/images/'+_boastPlants[index].image, fit: BoxFit.fill);
              },
              loop:false,
              itemCount: _boastPlants.length,
              pagination: new SwiperPagination(),
              control: new SwiperControl(),
              scale:0.9,
              viewportFraction: 0.8,
              itemHeight: 300.0,
              itemWidth: 300.0,
              onIndexChanged: (int newIndex){
                setState(() {
                  _selectedMyPlantId = _boastPlants[newIndex].myPlantId;
                  _selectedIndex = newIndex;
                });
              },

            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.5,
                    20,
                    MediaQuery.of(context).size.width * 0.1,
                    0),


                child: ElevatedButton(
                  onPressed: () {
                    _addLikes(_selectedMyPlantId);
                    _likesIds.add(_boastPlants[_selectedIndex]);
                  },
                  child: Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: <Widget>[
                    Icon(Icons.favorite),
                    Text(
                      ' 좋아요',
                    ),
                  ]),
                ),
              ),
              _selectedIndex+1 == _boastPlants.length ?
              Container(
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.5,
                    20,
                    MediaQuery.of(context).size.width * 0.10,
                    0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      BoastResultScreen.routeName,
                      arguments: (_likesIds),);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(
                      '결과보기',
                    ),
                  ]),
                ),
              ):Container(),
            ],
          ),
        ],
      ),
    );
  }
}
