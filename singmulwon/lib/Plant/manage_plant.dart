// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names
import 'package:flutter/material.dart';

import './edit_plant.dart';
import './insert_plant.dart';
import './future_plant.dart';
import './bluetooth_plant.dart';
import './Test1.dart';

class ManagePlant extends StatefulWidget {
  static const routeName = '/manage-plant';
  @override
  State<ManagePlant> createState() => _ManagePlantState();
}

class _ManagePlantState extends State<ManagePlant> {
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
            // MaterialPageRoute(builder: (context) => Bluetooth()),
            MaterialPageRoute(builder: (context) => Test1()),
          );
        },
        child: Icon(Icons.search),
      ),
    );
  }
}

Card MyPlantView(BuildContext context, user) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  return Card(
    child: FutureBuilder(
      future: myPlantList(user),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // buildColumn(snapshot);
          return ListView.builder(
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
                    height: height * 0.2,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(6),
                    color: Color(0xffD9F8C4),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: SizedBox(
                            width: width * 0.20,
                            child: Image.network(snapshot.data[index].image),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              "별명 :  " + snapshot.data[index].myPlantNickname,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 0.3,
                                  child: Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    "     종류 :  " +
                                        snapshot.data[index].plantName,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: width * 0.3,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        iconSize: 30.0,
                                        onPressed: () => deletePlant(context,
                                            snapshot.data[index].myPlantId),
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.settings_remote),
                                          iconSize: 30.0,
                                          onPressed: () => {}),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}에러!!");
        }
        return const CircularProgressIndicator();
      },
    ),
  );
}
