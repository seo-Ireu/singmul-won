// ignore_for_file: prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, missing_required_param, deprecated_member_use, prefer_const_constructors, non_constant_identifier_names, unused_local_variable, use_key_in_widget_constructors, use_build_context_synchronously, sized_box_for_whitespace
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import './edit_button.dart';
import './user_plant.dart';
import './notification.dart';

class InsertPlant extends StatefulWidget {
  static const routeName = '/insert-plant';
  @override
  State<InsertPlant> createState() => _InsertPlantState();
}

double _currentWaterValue = 0;
double _currentLightValue = 0;

class _InsertPlantState extends State<InsertPlant> {
  final plantidController = TextEditingController();
  final List<String> _sortValueList = ['', '수선화', '민들레', '선인장'];
  String _selectedValue = '수선화';
  int _selectedSortIndex = 1;

  @override
  void initState() {
    super.initState();
    // 알림 초기화
    init(); //notification.dart
  }

  Future insertPlant(BuildContext context, userid, name, humi, lumi) async {
    var url = "http://54.177.126.159/ubuntu/flutter/plant/insert_plant.php";
    var response = await http.post(Uri.parse(url), body: {
      "userid": userid,
      "sort": _selectedSortIndex.toString(),
      "name": name,
      "humi": humi,
      "lumi": lumi,
    });
    showGroupedNotifications();
    Navigator.of(context).pop();
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (BuildContext context) => ManagePlant()),
    //     (route) => false);
  }

  Future AutoSetting() async {
    var url = "http://54.177.126.159/ubuntu/flutter/plant/auto_setting.php";
    var response = await http.post(Uri.parse(url), body: {
      "plantInfoId": _selectedSortIndex,
    });
    String jsonData = utf8.decode(response.bodyBytes);
    var vld = await json.decode(jsonData)['setting']; //List<dynamic>

    AiSetting setting_plant;
    for (var item in vld) {
      setting_plant = AiSetting(
          plantInfoId: item['plantInfoId'],
          humi: item['humi'],
          lumi: item['lumi']);
    }
    return [setting_plant.humidity(), setting_plant.luminance()];
  }

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context).settings.arguments;
    double waterValue = _currentWaterValue;
    double lightValue = _currentLightValue;
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
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.24,
                      height: MediaQuery.of(context).size.height * 0.18,
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundImage: AssetImage('assets/plant_1.jfif'),
                      ),
                    )
                  : Image.file(File(_image.path))));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('식물 등록'),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
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
                      child: TextField(
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '식물 이름',
                          hintText: '별명 입력',
                        ),
                        controller: plantidController,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 165, 171, 166),
                              width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      width: 240,
                      child: Row(
                        children: [
                          Container(
                            width: 5,
                          ),
                          SizedBox(
                              width: 130,
                              child: Text(
                                "식물 종류",
                                style: TextStyle(fontSize: 15),
                              )),
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
                                var index = _sortValueList.indexOf(value);
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
                Container(
                  height: 60,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WaterValue(waterValue.toInt()),
                    Container(
                      width: 10,
                    ),
                    LightValue(lightValue.toInt()),
                    Container(
                      width: 10,
                    ),
                    FavoriteValue(0),
                  ],
                ),
                SizedBox(
                  height: 40,
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
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
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
                        //수정
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      width: 50,
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
                          "식물등록",
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          insertPlant(
                              context,
                              userId,
                              // _selectedSortIndex.toString(),
                              plantidController.text,
                              waterValue.toString(),
                              lightValue.toString());
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
