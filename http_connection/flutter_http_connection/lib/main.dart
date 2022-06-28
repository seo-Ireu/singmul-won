import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<Info> fetchInfo() async {
  var url = 'https://jsonplaceholder.typicode.com/posts/1';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    //만약 서버가 ok응답을 반환하면, json을 파싱합니다
    print('응답했다');
    print(json.decode(response.body));
    return Info.fromJson(json.decode(response.body));
  } else {
    //만약 응답이 ok가 아니면 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

class Info {
  final int userId;
  final int id;
  final String title;
  final String body;

  Info(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      userId: json["userId"],
      id: json["id"],
      title: json["title"],
      body: json["body"],
    );
  }
}

void main() => runApp(const InfoPage());

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  Future<Info>? info;

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
              title: const Text('info', style: TextStyle(color: Colors.white)),
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
                    return Text("${snapshot.error}에러!!");
                  }
                  return const CircularProgressIndicator();
                },
              ),
            )));
  }

  Widget buildColumn(snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('userId:${snapshot.data!.userId}',
            style: const TextStyle(fontSize: 20)),
        Text('id:${snapshot.data!.id}', style: const TextStyle(fontSize: 20)),
        Text('title:${snapshot.data!.title}',
            style: const TextStyle(fontSize: 20)),
        Text('body:${snapshot.data!.body}추가 문자도 가능',
            style: const TextStyle(fontSize: 20)),
      ],
    );
  }
}
