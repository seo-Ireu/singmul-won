import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Community/screens/community_write_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import '../models/c_comment_model.dart';
import '../models/community_model.dart';

import '../widgets/community_comment.dart';
import '../widgets/community_detail.dart';
import 'boast_home_screen.dart';

class CommunityDetailScreen extends StatefulWidget {
  static const routeName = '/community_detail_screen.dart';

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // var _cIdx = ModalRoute.of(context).settings.arguments as int;

    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: CommunityDetail(),
      // bottomNavigationBar: CommunityComment(),
    );
  }
}
