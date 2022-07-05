// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import './write_page.dart';
import './category.dart';
import '../http.dart';

class Community extends StatefulWidget {
  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  void _incrementCounter() {
    //쓰기로 이동
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WritePage()),
      );
    });
  }

  onMove(String title, String content) {
    //해당 게시글로 이동
    data d = new data();
    d.setTitle(title, content);
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Category()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("커뮤니티"),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfoPage(),
                    ));
              },
            ),
            Card(
              child: Column(
                children: <Widget>[
                  // new Swiper(
                  //   autoplay: true,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return new Image.network(
                  //       ImagesList[index],
                  //       fit: BoxFit.fill,
                  //     );
                  //   },
                  //   itemCount: ImagesList.length,
                  //   itemWidth: 300.0,
                  //   itemHeight: 200.0,
                  //   layout: SwiperLayout.STACK,
                  // ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: '글쓰기',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget Content(BuildContext context) {
    return Scaffold();
  }
}
