import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/boast_result.dart';

class BoastResultScreen extends StatefulWidget {
  static const routeName = '/boast_result_screen.dart';

  @override
  State<BoastResultScreen> createState() => _BoastResultScreenState();
}

class _BoastResultScreenState extends State<BoastResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            )
        ),

      ),
      body: BoastResult(),
    );
  }
}
