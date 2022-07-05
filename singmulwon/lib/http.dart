import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Info> fetchInfo() async {
  var url = 'http://54.177.126.159/test.json';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    //만약 서버가 ok응답을 반환하면, json을 파싱합니다
    return Info.fromJson(json.decode(response.body));
  } else {
    //만약 응답이 ok가 아니면 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

class Info {
  final String userId;
  final String nickname;

  Info({
    @required this.userId,
    @required this.nickname,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      userId: json["userId"],
      nickname: json["nickname"],
    );
  }
}

class InfoPage extends StatefulWidget {
  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  Future<Info> info;

  @override
  void initState() {
    super.initState();
    info = fetchInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Test', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Center(
          child: FutureBuilder<Info>(
            //통신데이터 가져오기
            future: info,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return buildColumn(snapshot);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Widget buildColumn(snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('userId:${snapshot.data.userId}',
            style: const TextStyle(fontSize: 20)),
        Text('nickname:${snapshot.data.nickname}',
            style: const TextStyle(fontSize: 20)),
      ],
    );
  }
}
