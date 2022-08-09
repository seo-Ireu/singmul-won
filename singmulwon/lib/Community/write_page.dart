import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../home_page.dart';
import 'community.dart';
import 'community_model.dart';

class WritePage extends StatefulWidget {
  static const routeName = '/write_page.dart';

  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  var _cData;
  @override
  void initState(){
    super.initState();
    Future.delayed(Duration.zero, () {
      _cData = ModalRoute.of(context).settings.arguments as CommunityModel;
      if (_cData!=null){
        _title.text = _cData.title;
        _content.text = _cData.content;
        _selectedCategoryIndex = _cData.categoryId;
        _selectedValue = _categoryValueList[_cData.categoryId];
      }
    });
  }

  TextEditingController _title = TextEditingController();
  TextEditingController _content = TextEditingController();

  final List<String> _categoryValueList = ['','꿀팁', '질문', '나눔'];
  String _selectedValue = '꿀팁';
  int _selectedCategoryIndex =1;

  final picker = ImagePicker();
  File _image;

  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _image = File(image.path); // 가져온 이미지를 _image에 저장
    });
  }

  Future _create() async{
    print(_selectedCategoryIndex);
    var url = "http://54.177.126.159/ubuntu/flutter/community/c_create.php";

    var response = await http.post(Uri.parse(url), body: {
      "categoryId": _selectedCategoryIndex.toString(),
      "userId": "admin",
      "title": _title.text,
      "content": _content.text,
    });
    Navigator.of(context).pop();
  }

  Future _update() async{
    print(_title.text);
    print(_content.text);
  var url = "http://54.177.126.159/ubuntu/flutter/community/c_update.php";

  var response = await http.post(Uri.parse(url), body: {
    "communityId": _cData.communityId.toString(),
    "categoryId": _selectedCategoryIndex.toString(),
    "userId": "admin",
    "title": _title.text,
    "content": _content.text,
  });
  Navigator.of(context).pop();
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
                      controller:_title,
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
                      items: _categoryValueList.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          var index = _categoryValueList.indexOf(value);
                          _selectedValue = value;
                          _selectedCategoryIndex = index;
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
                    controller:_content,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
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
                      if(_cData != null){
                        _update();
                      }else{
                        _create();
                      }
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
