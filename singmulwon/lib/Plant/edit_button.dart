// ignore_for_file: non_constant_identifier_names, deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';

Expanded WaterValue(value) {
  return Expanded(
    child: FlatButton(
      color: Color.fromARGB(255, 209, 226, 210),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      height: 100,
      onPressed: () {},
      child: Text(
        'water\n${value}',
        style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 23, 75, 25)),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Expanded LightValue(value) {
  return Expanded(
    child: FlatButton(
      color: Color.fromARGB(255, 209, 226, 210),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      height: 100,
      onPressed: () {},
      child: Text(
        'light\n${value}',
        style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 23, 75, 25)),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Expanded FavoriteValue(value) {
  return Expanded(
    child: FlatButton(
      color: Color.fromARGB(255, 209, 226, 210),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      height: 100,
      onPressed: () {},
      child: Column(
        children: [
          Icon(Icons.favorite),
          Text(
            value.toInt().toString(),
            style:
                TextStyle(fontSize: 20, color: Color.fromARGB(255, 23, 75, 25)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
