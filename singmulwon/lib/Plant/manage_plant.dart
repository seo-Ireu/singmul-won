// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './user_plant.dart';
import './edit_plant.dart';

class ManagePlant extends StatefulWidget {
  static const routeName = '/manage-plant';
  @override
  State<ManagePlant> createState() => _ManagePlantState();
}

Future myPlantList(String user) async {
  var url = "http://54.177.126.159/ubuntu/flutter/plant/manage_plant.php";
  var response = await http.post(Uri.parse(url), body: {
    "userid": user,
  });
  String jsonData = response.body;
  var vld = await json.decode(jsonData)['myplant']; //List<dynamic>

  List<UserPlant> myplants = [];
  for (var item in vld) {
    UserPlant myitem = UserPlant(
        myPlantId: item['myPlantId'],
        myPlantNickname: item['myPlantNickname'],
        plantName: item['plantName'],
        humi: item['humi'],
        lumi: item['lumi'],
        image: item['image']);
    myplants.add(myitem);
  }
  return myplants;
}

class _ManagePlantState extends State<ManagePlant> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context).settings.arguments ??
        <String, String>{}) as Map;
    String user = arguments['userid'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '내 식물관리',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                  EditPlant.routeName); //, arguments: {'userid': userid} 추가 예정
              //수정: arguments(plantId) 추가
            },
            icon: const Icon(Icons.add),
          ),
        ],
        elevation: 0,
      ),
      body: MyPlantView(context, user),
    );
  }
}

Card MyPlantView(BuildContext context, user) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return Card(
    child: FutureBuilder(
      future: myPlantList(user),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // buildColumn(snapshot);
          return ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      EditPlant.routeName,
                      // arguments: (snapshot.data[index].myPlantId),
                    );
                  },
                  child: Container(
                    height: height * 0.2,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(6),
                    color: Color(0xffD9F8C4),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: SizedBox(
                            width: width * 0.25,
                            child: Image.network(snapshot.data[index].image),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              "별명 :  " + snapshot.data[index].myPlantNickname,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.028,
                            ),
                            SizedBox(
                              width: width * 0.5,
                              child: Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                "     종류 :  " + snapshot.data[index].plantName,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}에러!!");
        }
        return const CircularProgressIndicator();
      },
    ),
  );
}
