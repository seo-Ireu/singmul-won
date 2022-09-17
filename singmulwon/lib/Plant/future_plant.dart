// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './user_plant.dart';

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
        lumi: item['lumi'],
        humidity: item['humidity'],
        luminance: item['luminance']);
  }
  return sig_plants;
}

Future myPlantList(String user) async {
  var url = "http://54.177.126.159/ubuntu/flutter/plant/manage_plant.php";
  var response = await http.post(Uri.parse(url), body: {
    "userid": user,
  });
  String jsonData = utf8.decode(response.bodyBytes);
  var vld = await json.decode(jsonData)['myplant']; //List<dynamic>

  List<UserPlant> myplants = [];
  for (var item in vld) {
    UserPlant myitem = UserPlant(
        myPlantId: item['myPlantId'],
        myPlantNickname: item['myPlantNickname'],
        plantName: item['plantName'],
        plantImage: item['plantImage'],
        humi: item['humi'],
        lumi: item['lumi'],
        image: item['image']);
    myplants.add(myitem);
  }
  return myplants;
}

Future deletePlant(BuildContext context, plantId) async {
  var url = "http://54.177.126.159/ubuntu/flutter/plant/delete_plant.php";

  var response = await http.post(Uri.parse(url), body: {
    "myPlantId": plantId,
  });
  // Navigator.of(context).pop();
  // Navigator.of(context).pushNamed(
  // ManagePlant.routeName,
  // );
}

Future properValue(String plantInfoId) async {
  var url = "http://54.177.126.159/ubuntu/flutter/plant/auto_setting.php";
  var response = await http.post(Uri.parse(url), body: {
    "plantInfoId": plantInfoId,
  });
  String jsonData = utf8.decode(response.bodyBytes);
  var vld = await json.decode(jsonData)['setting'];
  print(vld);
  SuitableData suitable_data;
  for (var item in vld) {
    suitable_data = SuitableData(
        plantInfoId: item['plantInfoId'],
        humidity: item['humidity'],
        luminance: item['luminance']);
  }
  return suitable_data;
}
