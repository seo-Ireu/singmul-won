// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:number_pagination/number_pagination.dart';

import './write_page.dart';

class Community extends StatefulWidget {
  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    var selectedPageNumber = 1;
    return Scaffold(
      appBar: AppBar(
        title: Text("커뮤니티"),
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('정보'),
                ),
                SizedBox(
                  width: 40,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('질문'),
                ),
                SizedBox(
                  width: 40,
                ),
                TextButton(
                  style: ButtonStyle(),
                  onPressed: () {},
                  child: Text('나눔'),
                ),
              ],
            ),
          ),
          Flexible(
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
                              height: 800.0,
                              child: Content(context),
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
          SizedBox(
            height: 320,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(240, 10, 30, 0),
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WritePage()));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Icon(Icons.edit), Text(" 글쓰기")],
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
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
              pageInit: selectedPageNumber, // picked number when init page
              colorPrimary: Colors.white,
              colorSub: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget Content(BuildContext context) {
    return Scaffold();
  }
}
