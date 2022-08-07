// ignore_for_file: non_constant_identifier_names, deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';

Expanded WaterValue(value) {
  return Expanded(
    child: FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      height: 100,
      onPressed: () {},
      child: Text(
        'water\n${value.toInt().toString()}%',
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Expanded LightValue(value) {
  return Expanded(
    child: FlatButton(
      height: 100,
      onPressed: () {},
      child: Text(
        'light\n${value.toInt().toString()}',
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Expanded FavoriteValue(value) {
  return Expanded(
    child: FlatButton(
      height: 100,
      onPressed: () {},
      child: Column(
        children: [
          Icon(Icons.favorite),
          Text(
            value.toInt().toString(),
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
