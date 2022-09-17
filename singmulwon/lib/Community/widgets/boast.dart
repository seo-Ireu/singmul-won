import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import '../models/boast_plant_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class Boast extends StatefulWidget {

  @override
  State<Boast> createState() => _BoastState();
}

class _BoastState extends State<Boast> {
  String baseUrl = dotenv.env['BASE_URL'];
  int _selectedMyPlantId = -1;
  List<BoastPlantModel> _boastPlants = [];

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
            myPlantId: int.parse(i['myPlantId']),
            plantName: i['plantName'],
            image: i['image'],
            likes: int.parse(i['likes']));
        bps.add(bpm);
      }
      setState(() {
        _boastPlants = bps;
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
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.9,
            child: new Swiper(
              itemBuilder: (BuildContext context,int index){
                return Image.asset(_boastPlants[index].image);
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
                _selectedMyPlantId = _boastPlants[newIndex].myPlantId;
              },

            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.5,
                20,
                MediaQuery.of(context).size.width * 0.18,
                0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.green),
                top: BorderSide(color: Colors.green),
                left: BorderSide(color: Colors.green),
                right: BorderSide(color: Colors.green),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () {
                print(_selectedMyPlantId);
                _addLikes(_selectedMyPlantId);
              },
              child: Row(children: [
                Icon(Icons.favorite, color: Colors.green[700]),
                Text(
                  ' 좋아요',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.green[700],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
