// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Boast extends StatefulWidget {
  @override
  State<Boast> createState() => _BoastState();
}

class _BoastState extends State<Boast> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("뽐내기"),
          elevation: 0,
        ),
        body: Center(
          child: Column(children: [
            SizedBox(
              height: 200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(3),
                  width: 20,
                  height: 10,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                ),
                Container(
                  margin: EdgeInsets.all(3),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                ),
                Container(
                  margin: EdgeInsets.all(3),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                ),
                Container(
                  margin: EdgeInsets.all(3),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                ),
                Container(
                  margin: EdgeInsets.all(3),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  'assets/plant_1.jfif',
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "별명: 새싹이",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "종류: 수선화",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.5,
                  20,
                  MediaQuery.of(context).size.width * 0.18,
                  0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.green),
                  top: BorderSide(color: Colors.green),
                  left: BorderSide(color: Colors.green),
                  right: BorderSide(color: Colors.green),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {},
                child: Row(children: [
                  Icon(Icons.favorite, color: Colors.green[700]),
                  Text(
                    ' 좋아요',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.green[700],
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ));
  }
}
