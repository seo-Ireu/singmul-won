// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './edit_plant.dart';
import './insert_plant.dart';
import './future_plant.dart';
import './bluetooth_plant.dart';

class Test1 extends StatefulWidget {
  @override
  State<Test1> createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final arguments = (ModalRoute.of(context).settings.arguments ??
        <String, String>{}) as Map;
    String user = arguments['userid'];

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(),
          Container(),
          SizedBox(
            height: size.height * 0.3,
            child: FutureBuilder(
                future: myPlantList('test1'),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("${snapshot.error}에러!!");
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 300,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 10,
                                right: 20,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: IconButton(
                                    onPressed: null,
                                    icon: Icon(Icons.favorite),
                                    color: Colors.red,
                                    iconSize: 30,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 50,
                                right: 50,
                                top: 50,
                                bottom: 50,
                                child:
                                    Image.asset('assets/images/plant-one.png'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }),
          )
        ],
      )),
    );
  }
}
