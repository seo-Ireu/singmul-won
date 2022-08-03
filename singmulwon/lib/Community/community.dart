// ignore_for_file: deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Community/community_model.dart';
import 'package:number_pagination/number_pagination.dart';

import './write_page.dart';
import './boast.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Community extends StatefulWidget {
  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  Future<List<CommunityModel>> cmDataFuture = getCmData();

  static Future <List<CommunityModel>> getCmData() async{
    var url = "http://54.177.126.159/ubuntu/flutter/community/c_read.php";
    var response = await http.get(Uri.parse(url));

    String jsonData = response.body;
    var myJson = await jsonDecode(jsonData)['community'];

    return myJson.map<CommunityModel>(CommunityModel.fromJson).toList();


  }
  var selectedPageNumber = 1;
  var color_category1;
  var color_category1_bg;
  var color_category2;
  var color_category2_bg;
  var color_category3;
  var color_category3_bg;

  Widget category_board;

  Container boast_board() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.green),
          top: BorderSide(color: Colors.green),
          left: BorderSide(color: Colors.green),
          right: BorderSide(color: Colors.green),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 60,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.8,
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Boast(),
              ),
            );
          },
          child: Text(
            "<< 뽐내기 게시판 >>",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }

  Container category() =>
      Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                primary: color_category1,
                backgroundColor: color_category1_bg,
                side: BorderSide(color: Colors.green),
              ),
              onPressed: () {
                setState(() {
                  category_board = Content1(context);
                  color_category1 = Colors.white;
                  color_category2 = Colors.green;
                  color_category3 = Colors.green;
                  color_category1_bg = Colors.green;
                  color_category2_bg = Colors.white;
                  color_category3_bg = Colors.white;
                });
              },
              child: Text('꿀팁'),
            ),
            SizedBox(
              width: 40,
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: color_category2,
                backgroundColor: color_category2_bg,
                side: BorderSide(color: Colors.green),
              ),
              onPressed: () {
                setState(() {
                  category_board = Content2(context);
                  color_category1 = Colors.green;
                  color_category2 = Colors.white;
                  color_category3 = Colors.green;
                  color_category1_bg = Colors.white;
                  color_category2_bg = Colors.green;
                  color_category3_bg = Colors.white;
                });
              },
              child: Text('질문'),
            ),
            SizedBox(
              width: 40,
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: color_category3,
                backgroundColor: color_category3_bg,
                side: BorderSide(color: Colors.green),
              ),
              onPressed: () {
                setState(() {
                  category_board = Content3(context);
                  color_category1 = Colors.green;
                  color_category2 = Colors.green;
                  color_category3 = Colors.white;
                  color_category1_bg = Colors.white;
                  color_category2_bg = Colors.white;
                  color_category3_bg = Colors.green;
                });
              },
              child: Text('나눔'),
            ),
          ],
        ),
      );

  Container community_edit() =>
      Container(
        margin: EdgeInsets.fromLTRB(240, 10, 30, 0),
        child: TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => WritePage()));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Icon(Icons.edit), Text(" 글쓰기")],
          ),
        ),
      );

  Expanded pagination() =>
      Expanded(
        child: NumberPagination(
          onPageChanged: (int pageNumber) {
            //do somthing for selected page
            setState(
                  () {
                selectedPageNumber = pageNumber;
              },
            );
          },
          threshold: 4,
          pageTotal: 100,
          pageInit: selectedPageNumber,
          // picked number when init page
          colorPrimary: Colors.white,
          colorSub: Colors.green,
        ),
      );

  @override
  Widget build(BuildContext context) {
    Widget show_board = category_board;
    return Scaffold(
      appBar: AppBar(
        title: Text("데일리데일리"),
        // title: Text("DailyDaily"),

        elevation: 0,
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          boast_board(), //뽐내기 게시판
          category(), //카테고리
          Expanded(
            flex: 6,
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Card(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              height: 450.0,
                              child: show_board,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 120,
          // ),
          community_edit(), //글쓰기 버튼
          pagination(), //하단 페이지바
        ],
      ),
    );
  }

  Widget Content1(BuildContext context) {
    return Card(
      child: Column(children: <Widget>[
        FutureBuilder<String>(
            future: _read(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
              if (snapshot.hasData == false) {
                return CircularProgressIndicator();
              }
              //error가 발생하게 될 경우 반환하게 되는 부분
              else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 15),
                  ),
                );
              }
              // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
              else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    snapshot.data.toString(),
                    style: TextStyle(fontSize: 15),
                  ),
                );
              }
            })
        ],
      ),
    );
  }

  Widget Content2(BuildContext context) {
    return Card(
      child: Column(children: [
        Container(
          padding:
          const EdgeInsets.only(top: 10, left: 16, right: 10, bottom: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '다육이 Plant Care 꿀조합 찾았음2',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        Divider(),

      ]),
    );
  }

  Widget Content3(BuildContext context) {
    return Card(
      child: Column(children: [
        Container(
          padding:
          const EdgeInsets.only(top: 10, left: 16, right: 10, bottom: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '다육이 Plant Care 꿀조합 찾았음3',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        Divider(),
        Container(
          padding:
          const EdgeInsets.only(top: 10, left: 16, right: 10, bottom: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '강낭콩 키우는 꿀팁3',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        Divider(),
        Container(
          padding:
          const EdgeInsets.only(top: 10, left: 16, right: 10, bottom: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '선인장 키울 때 세팅할 습도3',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        Divider(),
        Container(
          padding:
          const EdgeInsets.only(top: 10, left: 16, right: 10, bottom: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '<종합> 식물별 적정 습도. 조도3',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        Divider(),
      ]),
    );
  }

  Future<String> _read() async{
    var url = "http://54.177.126.159/ubuntu/flutter/community/c_read.php";
    var response = await http.get(Uri.parse(url));
    String jsonData = response.body;
    var myJson = await jsonDecode(jsonData)['community'];

    // var vld = await json.decode(json.encode(response.body));
    // CommunityModel cm = CommunityModel.fromJson(jsonDecode(myJson[0]));
    print(myJson[0]);
    return myJson.toString();
  }



}