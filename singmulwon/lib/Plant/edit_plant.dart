// ignore_for_file: prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, missing_required_param, deprecated_member_use, prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '/Provider/plant.dart';
import '/Provider/plants.dart';

class WaterRate extends ChangeNotifier {
  int _water = 0;

  void get change {
    notifyListeners();
  }
}

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: FlatButton(
                    height: 100,
                    onPressed: () {
                      setState(() {
                        // Text(
                        //   'water\n' + _currentWaterValue.toString() + '%',
                        // );
                      });
                    },
                    child: Text(
                      'water\n${_editedPlant.water.toInt().toString()}%',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    height: 100,
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text(
                      'light\n${_editedPlant.light.toInt().toString()}',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    height: 100,
                    onPressed: () {
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        Icon(Icons.favorite),
                        Text(
                          _editedPlant.favorite.toInt().toString(),
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
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
                  child: Icon(Icons.water_drop_outlined),
                ),
                Expanded(
                  flex: 7,
                  child: ChangeNotifierProvider(
                    create: (_) => WaterRate(),
                    child: Slider(
                      value: _currentWaterValue,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: _currentWaterValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentWaterValue = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
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
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
