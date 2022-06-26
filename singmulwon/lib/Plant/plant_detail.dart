import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlantDetail extends StatefulWidget {
  static const routeName = '/plant-detail';

  @override
  State<PlantDetail> createState() => _PlantDetailState();
}

class _PlantDetailState extends State<PlantDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("식물 편집"),
      ),
    );
  }
}
