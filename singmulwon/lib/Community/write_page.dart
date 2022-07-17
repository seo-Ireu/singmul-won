import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WritePage extends StatefulWidget {
  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  String title = ' '; //제목
  String content = ' '; //내용
  final List<String> _valueList = ['꿀팁', '질문', '나눔'];
  String _selectedValue = '꿀팁';

  final picker = ImagePicker();
  File _image;

  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _image = File(image.path); // 가져온 이미지를 _image에 저장
    });
  }

  Widget showImage() {
    return Container(
        // color: const Color(0xffd0cece),
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: _image == null
                ? Text('No image selected.')
                : Image.file(File(_image.path))));
  }

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
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text('카테고리: '),
                    SizedBox(
                      width: 20,
                    ),
                    DropdownButton(
                      value: _selectedValue,
                      items: _valueList.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    showImage(),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                      child: Text('식물 사진 편집'),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: TextField(
                    onChanged: (String text) {
                      content = text;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: 16,
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
                    color: Colors.green,
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
