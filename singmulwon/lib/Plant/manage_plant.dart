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
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(30, 30, 0, 0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(EditPlant.routeName);
              },
              child: Container(
                width: 300,
                height: 100,
                padding: EdgeInsets.all(10),
                child: Icon(Icons.add, color: Colors.white, size: 48),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// UserPlant(
//                 plantData.plants[i].id,
//                 plantData.plants[i].name,
//                 plantData.plants[i].sort,
//                 plantData.plants[i].image,
//               ),