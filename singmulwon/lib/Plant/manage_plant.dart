// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/plants.dart';
import './user_plant.dart';
import './edit_plant.dart';

class ManagePlant extends StatefulWidget {
  static const routeName = '/manage-plant';

  @override
  State<ManagePlant> createState() => _ManagePlantState();
}

var titleList = [
  '새싹이',
  '민들민들',
];

var imageList = [
  'assets/plant_1.jfif',
  'assets/plant_3.jfif',
];

var description = [
  '수선화',
  '민들레',
];

class _ManagePlantState extends State<ManagePlant> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context).settings.arguments ??
        <String, String>{}) as Map;
    final userid = arguments['userid'];
    double width = MediaQuery.of(context).size.width * 0.6;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '내 식물관리',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                  EditPlant.routeName); //, arguments: {'userid': userid} 추가 예정
              //수정: arguments(plantId) 추가
            },
            icon: const Icon(Icons.add),
          ),
        ],
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
        itemCount: titleList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(EditPlant.routeName);
            },
            child: Container(
              height: 160,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(6),
              color: Color(0xffD9F8C4),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: SizedBox(
                      width: 100,
                      height: 140,
                      child: Image.asset(imageList[index]),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "별명 :  " + titleList[index],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: width,
                        child: Text(
                          "     종류 :  " + description[index],
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
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
