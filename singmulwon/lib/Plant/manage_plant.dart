// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Plant/user_plant.dart';
import 'package:provider/provider.dart';

import '../Provider/plants.dart';
import './user_plant.dart';
import './edit_plant.dart';

class ManagePlant extends StatelessWidget {
  static const routeName = '/manage-plant';
  @override
  Widget build(BuildContext context) {
    final plantData = Provider.of<Plants>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('내 식물관리'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditPlant.routeName, arguments: ("00"));
              //수정: arguments(plantId) 추가
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: plantData.plants.length,
          itemBuilder: (_, i) => Column(
            children: [
              UserPlant(
                plantData.plants[i].id,
                plantData.plants[i].name,
                plantData.plants[i].sort,
                plantData.plants[i].image,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
