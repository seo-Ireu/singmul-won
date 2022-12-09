// ignore_for_file: prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, missing_required_param, deprecated_member_use, prefer_const_constructors, non_constant_identifier_names, unused_local_variable, use_key_in_widget_constructors, sized_box_for_whitespace, use_build_context_synchronously, missing_return, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './edit_button.dart';
import './future_plant.dart';

class EditPlant extends StatefulWidget {
  static const routeName = '/edit-plant';
  @override
  State<EditPlant> createState() => EditPlantState();

  static EditPlantState of(BuildContext context) => //추가
      context.findAncestorStateOfType<EditPlantState>();
}

class EditPlantState extends State<EditPlant> {
  double currentWaterValue;
  double currentLightValue;
  var flag1 = 1;

  void changeWater(BuildContext context, snapshot) {
    currentWaterValue = double.parse(snapshot.data.humi);
  }

  double changeLight(BuildContext context, snapshot) {
    currentLightValue = double.parse(snapshot.data.lumi);
  }

  //_EditPlant
  final _form = GlobalKey<FormState>();
  final plantidController = TextEditingController();

  var humidity;
  var luminance;

  Future updatePlant(
      BuildContext context, name, myplantId, humi, lumi, flag) async {
    var url = "http://13.209.68.93/ubuntu/flutter/plant/edit_plant.php";

    await http.get(Uri.parse(
        '$url?myplantId=$myplantId&name=$name&lumi=$lumi&humi=$humi&flag=$flag'));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final plantId = ModalRoute.of(context).settings.arguments;
    var singlePlant = myPlant(plantId);

    return Scaffold(
      appBar: AppBar(
        title: Text('식물 편집'),
        elevation: 0,
      ),
      body: FutureBuilder(
          future: singlePlant,
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // double waterValue = changeWater(context, snapshot);
              if (flag1 == 1) {
                changeWater(context, snapshot);
                changeLight(context, snapshot);
              }
              double waterValue = currentWaterValue;
              double lightValue = currentLightValue;
              var nickname = snapshot.data.myPlantNickname;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                          ),
                          Container(
                            width: 240,
                            height: 50,
                            child: Form(
                              key: _form,
                              child: TextFormField(
                                // ignore: prefer_const_constructors
                                initialValue: nickname,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '식물 별명',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please provide a value.';
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  nickname = val;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 38,
                          ),
                        ],
                      ),
                      Container(
                        height: 60,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          WaterValue(waterValue.toInt()), //waterValue
                          Container(
                            width: 10,
                          ),
                          LightValue(lightValue.toInt()), //lightValue
                          Container(
                            width: 10,
                          ),
                          FavoriteValue(int.parse(snapshot.data.likes)),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Icon(Icons.water_drop_outlined),
                          ),
                          Expanded(
                            flex: 7,
                            child: Slider(
                              value: currentWaterValue,
                              min: 0,
                              max: 100,
                              divisions: 100,
                              label:
                                  currentWaterValue //double.parse(snapshot.data.humi)
                                      .round()
                                      .toString(),
                              onChanged: (double value) {
                                setState(() {
                                  flag1 = 2;
                                  currentWaterValue = value;
                                  waterValue = currentWaterValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Icon(Icons.sunny),
                          ),
                          Expanded(
                            flex: 7,
                            child: Slider(
                              value: currentLightValue,
                              max: 100,
                              divisions: 100,
                              label: currentLightValue.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  flag1 = 2;
                                  currentLightValue = value;
                                  lightValue = currentLightValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 110,
                            height: 40,
                            child: FlatButton(
                              textColor: Colors.white,
                              color: Color.fromARGB(255, 75, 143, 77),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                "자동설정",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                setState(() {
                                  currentWaterValue =
                                      double.parse(snapshot.data.humidity);
                                  waterValue =
                                      double.parse(snapshot.data.humidity);
                                  currentLightValue =
                                      double.parse(snapshot.data.luminance);
                                  lightValue =
                                      double.parse(snapshot.data.luminance);
                                });
                                //자동세팅
                              },
                            ),
                          ),
                          SizedBox(
                            width: 60,
                          ),
                          SizedBox(
                            width: 110,
                            height: 40,
                            child: FlatButton(
                              textColor: Colors.white,
                              color: Color.fromARGB(255, 75, 143, 77),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                "식물저장",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                updatePlant(
                                    context,
                                    nickname,
                                    plantId,
                                    currentWaterValue.toInt().toString(),
                                    currentLightValue.toInt().toString(),
                                    flag1);
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
