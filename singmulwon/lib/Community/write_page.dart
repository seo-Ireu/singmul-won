import 'package:flutter/material.dart';

class WritePage extends StatefulWidget {
  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  String title = ' '; //제목
  String content = ' '; //내용

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("글쓰기"),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                  child: TextField(
                    onChanged: (String text) {
                      title = text;
                    },
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: '제목을 적어주세요',
                      border: OutlineInputBorder(),
                      labelText: "제목을 입력하세요.",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                  child: TextField(
                    onChanged: (String text) {
                      content = text;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: 20,
                    decoration: InputDecoration(
                      hintText: '내용을 적어주세요',
                      border: OutlineInputBorder(),
                      labelText: "내용을 입력하세요.",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    child: Text(
                      '글쓰기',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    height: 50,
                    minWidth: 400,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
