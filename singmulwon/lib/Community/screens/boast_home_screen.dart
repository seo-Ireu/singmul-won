import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/boast.dart';

class BoastHomeScreen extends StatefulWidget {
  static const routeName = '/boast_home_screen.dart';

  @override
  State<BoastHomeScreen> createState() => _BoastHomeScreenState();
}

class _BoastHomeScreenState extends State<BoastHomeScreen> {
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
      body: Boast(),
    );
  }
}
