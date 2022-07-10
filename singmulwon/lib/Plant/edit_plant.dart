// ignore_for_file: prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, missing_required_param, deprecated_member_use, prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/Provider/plant.dart';
import './edit_button.dart';
import '/Provider/plants.dart';
import './plant_detail.dart';

class EditPlant extends StatefulWidget {
  static const routeName = '/edit-plant';

  @override
  State<EditPlant> createState() => _EditPlantState();
}

class _EditPlantState extends State<EditPlant> {
  final _form = GlobalKey<FormState>();

  var _editedPlant = Plant(
      id: null, name: '', sort: '', image: '', water: 0, light: 0, favorite: 0);
  var _initValues = {
    '별명': '',
    '종류': '',
    '습도': '',
    '조도': '',
  };
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final plantId = ModalRoute.of(context).settings.arguments as String;
      print("palntId:$plantId");
      //확인용
      if (plantId != null) {
        _editedPlant =
            Provider.of<Plants>(context, listen: false).findById(plantId);
        _initValues = {
          'name': _editedPlant.name,
          'sort': _editedPlant.sort,
          'water': _editedPlant.water.toString(),
          'light': _editedPlant.light.toString(),
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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

  // double _currentWaterValue = _editedPlant.water;
  double _currentWaterValue = 20;
  // double _currentLightValue = _editedPlant.light;
  double _currentLightValue = 20;

  @override
  Widget build(BuildContext context) {
    double waterValue = _currentWaterValue;
    double lightValue = _currentLightValue;
    final plantData = Provider.of<Plants>(context);

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
                FavoriteValue(_editedPlant.favorite),
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
