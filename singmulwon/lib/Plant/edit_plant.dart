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

class _EditPlantState extends State<EditPlant> {
  final _form = GlobalKey<FormState>();
  final plantidController = TextEditingController();
  final List<String> _sortValueList = ['', '수선화', '민들레', '선인장'];
  String _selectedValue = '수선화';
  int _selectedSortIndex = 1;
  final picker = ImagePicker();
  File _image;

  double _currentWaterValue = 20;
  double _currentLightValue = 20;

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

  Future myPlant(String plantId) async {
    var url = "http://54.177.126.159/ubuntu/flutter/plant/plant_view.php";
    var response = await http.post(Uri.parse(url), body: {
      "myPlantId": plantId,
    });
    String jsonData = utf8.decode(response.bodyBytes);
    var vld = await json.decode(jsonData)['plantid']; //List<dynamic>

    SinglePlant sig_plants;
    for (var item in vld) {
      sig_plants = SinglePlant(
          myPlantId: item['myPlantId'],
          myPlantNickname: item['myPlantNickname'],
          plantInfoId: item['plantInfoId'],
          humi: item['humi'],
          lumi: item['lumi']);
    }
    return sig_plants;
  }

  Future updatePlant(
      BuildContext context, name, myplantId, humi, lumi, image) async {
    var url = "http://54.177.126.159/ubuntu/flutter/plant/edit_plant.php";

    await http.get(Uri.parse(
        '$url?myplantId=$myplantId&name=$name&sort=$_selectedSortIndex&lumi=$lumi&humi=$humi&image=$image'));
    // await http.post(Uri.parse(url), body: {
    //   "myplantId": myplantId,
    //   "name": name,
    //   "sort": _selectedSortIndex.toString(),
    //   "lumi": lumi,
    //   "humi": humi,
    //   "image": image,
    // });
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
              var nickname = snapshot.data.myPlantNickname;
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
                              width: 140,
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
                              height: 20,
                            ),
                            SizedBox(
                              width: 180,
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
                        WaterValue(_currentWaterValue.toInt()), //waterValue
                        LightValue(_currentLightValue.toInt()), //lightValue
                        FavoriteValue(20),
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
                            onPressed: () {
                              updatePlant(
                                  context,
                                  plantId,
                                  nickname,
                                  _currentWaterValue.toInt().toString(),
                                  _currentLightValue.toInt().toString(),
                                  'https://search.pstatic.net/sunny/?src=https%3A%2F%2Fmedia.istockphoto.com%2Fvectors%2Fecology-logo-green-design-vector-id862500344%3Fk%3D20%26m%3D862500344%26s%3D170667a%26w%3D0%26h%3D9B59bc6G5oyJ5aLBUi909Xkmxp8JB52r_aRvlZT8QwE%3D&type=sc960_832');
                            },
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
