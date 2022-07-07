// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_plant.dart';
import '../Provider/plants.dart';

class UserPlant extends StatelessWidget {
  final String id;
  final String name;
  final String sort;
  final String image;

  UserPlant(this.id, this.name, this.sort, this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 100,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(image),
          ),
          Column(
            children: [
              Text(name),
              Text(sort),
            ],
          ),
          Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditPlant.routeName, arguments: id);
                  },
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                ),
                IconButton(
                  onPressed: () {
                    Provider.of<Plants>(context, listen: false).deletePlant(id);
                  },
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
