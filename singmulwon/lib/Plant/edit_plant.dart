// ignore_for_file: prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, missing_required_param, deprecated_member_use, prefer_const_constructors, non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import '/Provider/plant.dart';
import '/Provider/plants.dart';

import './edit_button.dart';
import './plant_detail.dart';
import './user_plant.dart';

class EditPlant extends StatefulWidget {
  static const routeName = '/edit-plant';
  @override
  State<EditPlant> createState() => _EditPlantState();
}

Future myPlant() async {
  //(String myPlantId)
  String myPlantId = "6";
  var url = "http://54.177.126.159/ubuntu/flutter/plant/plant_view.php";
  var response = await http.post(Uri.parse(url), body: {
    "myPlantId": myPlantId,
  });
  String jsonData = response.body;
  var vld = await json.decode(jsonData)['plantid']; //List<dynamic>

  List<SinglePlant> sig_plants = [];
  for (var item in vld) {
    SinglePlant myitem = SinglePlant(
        myPlantId: item['myPlantId'], humi: item['humi'], lumi: item['lumi']);
    sig_plants.add(myitem);
  }
  return sig_plants;
}

class _EditPlantState extends State<EditPlant> {
  final _form = GlobalKey<FormState>();
  var _editedPlant = Plant(
      id: null, name: '', sort: '', image: '', water: 0, light: 0, favorite: 0);

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editedPlant.id != null) {
      Provider.of<Plants>(context, listen: false)
          .updatePlant(_editedPlant.id, _editedPlant);
    } else {
      Provider.of<Plants>(context, listen: false).addPlant(_editedPlant);
    }
    Navigator.of(context).pop();
  }

  double _currentWaterValue = 20;
  double _currentLightValue = 20;

  @override
  Widget build(BuildContext context) {
    myPlant();
    // final arguments = (ModalRoute.of(context).settings.arguments ??
    //     <String, String>{}) as Map;
    // String plantId = arguments['plantId'];

    // var singlePlant = myPlant(myplantId);

    double waterValue = _currentWaterValue;
    double lightValue = _currentLightValue;

    return Scaffold(
      appBar: AppBar(
        title: Text('식물 편집'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WaterValue(waterValue),
                LightValue(lightValue),
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
                    label: _currentWaterValue.round().toString(),
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
                      "식물편집",
                      style: TextStyle(fontSize: 20),
                    ),
                    //수정
                    onPressed: () async {
                      var plantTemp = await Navigator.of(context)
                          .pushNamed(PlantDetail.routeName);
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
                    color: Colors.green,
                    child: Text(
                      "자동설정",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
