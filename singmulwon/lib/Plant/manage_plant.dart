// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names
import 'package:flutter/material.dart';

import './edit_plant.dart';
import './insert_plant.dart';
import './future_plant.dart';
import './bluetooth_plant.dart';

class ManagePlant extends StatefulWidget {
  static const routeName = '/manage-plant';
  @override
  State<ManagePlant> createState() => _ManagePlantState();
}

class _ManagePlantState extends State<ManagePlant> {
  final Map<String, String> _PlantIlusterMap = {
    '수선화': 'assets/plant1.png',
    '민들레': 'assets/plant2.png',
    '선인장': 'assets/plant3.png',
    '1': 'assets/plant4.png',
    '2': 'assets/plant5.png',
    '3': 'assets/plant6.png',
    '4': 'assets/plant7.png',
    '5': 'assets/plant8.png',
  };
  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context).settings.arguments ??
        <String, String>{}) as Map;
    String user = arguments['userid'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '내 식물관리',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(InsertPlant.routeName,
                  arguments: user); //, arguments: {'userid': userid} 추가 예정
            },
            icon: const Icon(Icons.add),
          ),
        ],
        elevation: 0,
      ),
      body: MyPlantView(context, user),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Bluetooth()),
          );
        },
        child: Icon(Icons.search),
      ),
    );
  }
}

SingleChildScrollView MyPlantView(BuildContext context, user) {
  Size size = MediaQuery.of(context).size;
  return SingleChildScrollView(
    child: FutureBuilder(
      future: myPlantList(user),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 12,
                    bottom: 16,
                    top: 24,
                  ),
                  child: const Text(
                    'My Plants',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.4,
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              EditPlant.routeName,
                              arguments: (snapshot.data[index].myPlantId),
                            );
                          },
                          child: Container(
                            width: 270,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            // ignore: sort_child_properties_last
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 50,
                                  right: 50,
                                  top: 50,
                                  bottom: 50,
                                  child: Image.asset('assets/plant2.png'),
                                ),
                                Positioned(
                                  bottom: 15,
                                  left: 20,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      Text(
                                        snapshot.data[index].myPlantNickname,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        height: 2,
                                      ),
                                      Text(
                                        snapshot.data[index].plantName,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 86, 138, 88),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    bottom: 10,
                    top: 30,
                  ),
                  child: const Text(
                    'Simply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: size.height * 0.22,
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 189, 200, 189),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 80,
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          margin: const EdgeInsets.only(bottom: 10, top: 10),
                          width: size.width,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 86, 138, 88),
                                          shape: BoxShape.circle),
                                    ),
                                    Positioned(
                                      height: 75,
                                      bottom: 5,
                                      left: 0,
                                      right: 0,
                                      child: Image.asset('assets/plant1.png'),
                                    ),
                                    Positioned(
                                      bottom: 5,
                                      left: 80,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot
                                                .data[index].myPlantNickname,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color.fromARGB(
                                                    255, 57, 56, 56),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              // ignore: prefer_interpolation_to_compose_strings
                                              Text('습도: ' +
                                                  snapshot.data[index].humi),
                                              Container(
                                                width: 10,
                                              ),
                                              // ignore: prefer_interpolation_to_compose_strings
                                              Text('조도: ' +
                                                  snapshot.data[index].lumi)
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      );
                    },
                  ),
                ),
              ]);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}에러!!");
        }
        return const CircularProgressIndicator();
      },
    ),
  );
}

//                           IconButton(
//                                               icon: Icon(Icons.delete),
//                                               iconSize: 30.0,
//                                               onPressed: () => deletePlant(
//                                                   context,
//                                                   snapshot
//                                                       .data[index].myPlantId),
//                                             ),
//                                             IconButton(
//                                                 icon:
//                                                     Icon(Icons.settings_remote),
//                                                 iconSize: 30.0,
//                                                 onPressed: () => {}),