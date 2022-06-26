import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Feed/insta_list.dart';
import './insta_body.dart';
import 'insta_create.dart';
import 'dart:developer';

class InstaHome extends StatelessWidget {
  static const routeName = '/inst_home';
  @override
  Widget build(BuildContext context) {
    log("Insta Home");
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CreatePage.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: InstaList(),
    );
  }
}
