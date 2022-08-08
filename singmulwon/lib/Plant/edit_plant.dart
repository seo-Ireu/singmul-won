// ignore_for_file: prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, missing_required_param, deprecated_member_use, prefer_const_constructors, non_constant_identifier_names, unused_local_variable, use_key_in_widget_constructors, sized_box_for_whitespace
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import './edit_button.dart';
import './user_plant.dart';

class EditPlant extends StatefulWidget {
  static const routeName = '/edit-plant';
  @override
  State<EditPlant> createState() => _EditPlantState();
}

Future myPlant(String plantId) async {
  var url = "http://54.177.126.159/ubuntu/flutter/plant/plant_view.php";
  var response = await http.post(Uri.parse(url), body: {
    "myPlantId": plantId,
  });
  String jsonData = response.body;
  var vld = await json.decode(jsonData)['plantid']; //List<dynamic>

  SinglePlant sig_plants;
  for (var item in vld) {
    sig_plants = SinglePlant(
        myPlantId: item['myPlantId'], humi: item['humi'], lumi: item['lumi']);
  }
  return sig_plants;
}

double _currentWaterValue = 20;
double _currentLightValue = 20;

class _EditPlantState extends State<EditPlant> {
  final plantidController = TextEditingController();
  final List<String> _sortValueList = ['', '수선화', '민들레', '선인장'];
  String _selectedValue = '수선화';
  int _selectedSortIndex = 1;
  final picker = ImagePicker();
  File _image;

  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _image = File(image.path); // 가져온 이미지를 _image에 저장
    });
  }

  Widget showImage() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Center(
            child: _image == null
                ? CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage('assets/plant_1.jfif'),
                  )
                : Image.file(File(_image.path))));
  }

  Future updatePlant(BuildContext context, myplantId, humi, lumi) async {
    var url = "http://54.177.126.159/ubuntu/flutter/plant/edit_plant.php";
    var response = await http.post(Uri.parse(url),
        body: {"myplantId": myplantId, "humi": humi, "lumi": lumi});
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
              double waterValue = changeWater(context, snapshot);
              double lightValue = changeLight(context, snapshot);
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            showImage(),
                            ElevatedButton(
                              onPressed: () {
                                getImage(ImageSource.gallery);
                              },
                              child: Text('식물 사진 편집'),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: 200,
                              child: TextField(
                                // ignore: prefer_const_constructors
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'snapshot.data.name',
                                  hintText: 'snapshot.data.name',
                                ),
                                controller: plantidController,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: Row(
                                children: [
                                  SizedBox(width: 100, child: Text("식물 종류")),
                                  DropdownButton(
                                    value: _selectedValue,
                                    items: _sortValueList.map((value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        var index =
                                            _sortValueList.indexOf(value);
                                        _selectedValue = value;
                                        _selectedSortIndex = index;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        WaterValue(snapshot.data.humi),
                        LightValue(snapshot.data.lumi),
                        FavoriteValue(20),
                      ],
                    ),
                    SizedBox(
                      height: 60,
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
                            value: _currentWaterValue,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            label:
                                _currentWaterValue //double.parse(snapshot.data.humi)
                                    .round()
                                    .toString(),
                            onChanged: (double value) {
                              setState(() {
                                _currentWaterValue = value;
                                waterValue = _currentWaterValue;
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
                            value: _currentLightValue,
                            max: 100,
                            divisions: 100,
                            label: _currentLightValue.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                _currentLightValue = value;
                                lightValue = _currentLightValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 110,
                          height: 40,
                          child: FlatButton(
                            textColor: Colors.white,
                            color: Colors.green,
                            child: Text(
                              "자동설정",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {},
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
                            color: Colors.green,
                            child: Text(
                              "식물저장",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}

double changeWater(BuildContext context, snapshot) {
  return double.parse(snapshot.data.humi);
}

double changeLight(BuildContext context, snapshot) {
  return double.parse(snapshot.data.lumi);
}
