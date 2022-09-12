import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';
import 'community.dart';
import 'community_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WritePage extends StatefulWidget {
  static const routeName = '/write_page.dart';

  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  String baseUrl = dotenv.env['BASE_URL'];

  var _cData;
  List _cImageData=[];
  @override
  void initState(){
    super.initState();
    Future.delayed(Duration.zero, () {
      final arguments = (ModalRoute.of(context).settings.arguments ?? <String, dynamic>{}) as Map;
      _cData = arguments['data'];

      if (_cData!=null){
        _title.text = _cData.title;
        _content.text = _cData.content;
        _selectedCategoryIndex = _cData.categoryId;
        _selectedValue = _categoryValueList[_cData.categoryId];
        _cImageData = arguments['image'];
        showImageByNetwork();
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
  List<XFile> _selectedFiles=[];

  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(
        source: imageSource,
        maxWidth:200,
        maxHeight:200,
        imageQuality: 10);

    if(image?.path!=null) {
      setState(() {
        _image = File(image.path); // 가져온 이미지를 _image에 저장
      });
    }
  }
  Future sendImages(String communityId)async{
    var uri = baseUrl+"/community/flutter_upload_image/create.php";
    var request = http.MultipartRequest('POST', Uri.parse(uri));

    try{
      if (_selectedFiles.isNotEmpty){
        for (int i = 0; i < _selectedFiles.length; i++) {
          var pic = await http.MultipartFile.fromPath(
              "image[]", _selectedFiles[i].path);
          print("pick${i}: ${_selectedFiles[i].path}");
          request.files.add(pic);
          request.fields["communityId"] = communityId;
        }

        await request.send().then((result) {
          http.Response.fromStream(result).then((response) {

            if(response.body.isNotEmpty) {
              var message = json.decode(response.body);

              // show snackbar if input data successfully
              final snackBar = SnackBar(content: Text(message['message']));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          });

        }).catchError((e) {
          print(e);
        });
      }else{
        print("image is not selected!");
      }

    }catch(e){
      print(e);
    }
    print("image list length:${_selectedFiles.length.toString()}");

  }
  Future pickImages() async {
    final List<XFile> selectedImages = await picker.pickMultiImage();

    if (_selectedFiles != null) {
      _selectedFiles.clear();
    }
    if (selectedImages.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(selectedImages);
      });
    }
  }
  Future _create() async{
    var url = baseUrl+"/community/c_create.php";

    var response = await http.post(Uri.parse(url), body: {
      "categoryId": _selectedCategoryIndex.toString(),
      "userId": "admin",
      "title": _title.text,
      "content": _content.text
    });

    if(response.body.isNotEmpty) {
      var message = json.decode(response.body);

      String id = message["communityId"].toString();
      print("!!!!${id}");
      sendImages(id);
      }

    Navigator.of(context).pop();

  }
  Future _update() async{
  var url = baseUrl+"/community/c_update.php";

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
        child:  ListView.builder(
            itemCount: _selectedFiles.length,
            itemBuilder: (context, i) {
              return ListTile(
                  subtitle: Image.file(File(_selectedFiles[i].path)));
            })
        // Center(
        //     child: _image == null
        //         ? Text('No image selected.')
        //         : Image.file(File(_image.path)))
    );
  }
  Widget showImageByNetwork(){
  return Container(
  // color: const Color(0xffd0cece),
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child:  ListView.builder(
      itemCount: _cImageData.length,
      itemBuilder: (context, i) {
      return ListTile(
      subtitle: Image.network(baseUrl+"/community/flutter_upload_image/images/"+_cImageData[i]['url']));
      })
  );
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
                    _cImageData == null?
                    showImage(): showImageByNetwork(),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        pickImages();
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
