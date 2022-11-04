import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import 'feed_create_last_test.dart';

String baseUri = "http://13.209.68.93/ubuntu/flutter/feed/feed_upload.php?userId=";
final _textController = new TextEditingController();
var s_first;
String _selectedValue = '';
List<String> _plantSelect = [];

Future fetchFeed(String userId) async {
  var url = 'http://13.209.68.93/ubuntu/flutter/feed/feed_plant_select.php?userId='+userId;
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    //만약 서버가 ok응답을 반환하면, json을 파싱합니다
    print('응답했다');
    var tmp = json.decode(utf8.decode(response.bodyBytes));
    print(tmp["nickname"]);
    _selectedValue = tmp["nickname"][0];
    for(int i=0; i<tmp["count"]; i++){
      _plantSelect.add(tmp["nickname"][i]);
    }
    return tmp;
  } else {
    //만약 응답이 ok가 아니면 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

class FeedCreate extends StatefulWidget {
  static const routeName = '/image_test';
  final String title;
  final String userId;

  const FeedCreate({
    Key key,
    this.title,
    this.userId,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState("feed Create", userId);
}

class _HomePageState extends State<FeedCreate> {
  XFile _pickedFile;
  CroppedFile _croppedFile;
  String title;
  String userId;
  Future feeds;

  _HomePageState(this.title, this.userId);

  @override
  void initState() {
    super.initState();
    feeds = fetchFeed(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: !kIsWeb ? AppBar(title: Text(title)) : null,
      body: Center(
        child: FutureBuilder(
          //통신데이터 가져오기
          future: feeds,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (kIsWeb)
                    Padding(
                      padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
                      child: Text(
                        widget.title,
                      ),
                    ),
                    Expanded(child: _body(snapshot)),
                  ],
              );
              //buildColumn(snapshot, arguments['userid']);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}에러!!");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _body(snapshot) {
    if (_croppedFile != null || _pickedFile != null) {
      return _imageCard(snapshot);
    } else {
      return _uploaderCard(snapshot);
    }
  }

  Widget _imageCard(snapshot) {


    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
                child: _image(),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: '피드 내용',
              ),
              controller: _textController,
            ),
          ),
          DropdownButton(
            items: _plantSelect.map((String items) {
              //print(items);
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (String items) => setState(() {
                //print("dd:"+_selectedValue);
                //print(items);
                _selectedValue = items ?? "";
              }),
            value: _selectedValue,
          ),
          _menu(),
        ],
      ),
    );
  }

  Widget _image() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (_croppedFile != null) {
      final path = _croppedFile.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else if (_pickedFile != null) {
      final path = _pickedFile.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _menu() {
    return SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: FloatingActionButton(
                    heroTag: 'Upload',
                    onPressed: () {
                      patchUserProfileImage();
                    },
                    backgroundColor: Colors.blue,
                    tooltip: 'Upload',
                    child: const Icon(Icons.upload),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: FloatingActionButton(
                      heroTag: 'Delete',
                      onPressed: () {
                        _clear();
                      },
                      backgroundColor: Colors.redAccent,
                      tooltip: 'Delete',
                      child: const Icon(Icons.delete),
                    ),
                ),
                //if (_croppedFile == null)
                  //Padding(
                    //padding: const EdgeInsets.only(left: 12.0),
                    //child: FloatingActionButton(
                      //heroTag: 'Crop',
                      //onPressed: () {
                        //_cropImage();
                      //},
                      //backgroundColor: const Color(0xFFBC764A),
                      //tooltip: 'Crop',
                      //child: const Icon(Icons.crop),
                    //),
                  //)
          ],
        ),
    );
  }

  Widget _uploaderCard(snapshot) {
    return Center(
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SizedBox(
          width: kIsWeb ? 380.0 : 320.0,
          height: 300.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DottedBorder(
                    radius: const Radius.circular(12.0),
                    borderType: BorderType.RRect,
                    dashPattern: const [8, 4],
                    color: Theme.of(context).highlightColor.withOpacity(0.4),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            color: Theme.of(context).highlightColor,
                            size: 80.0,
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Upload an image to start',
                            style: kIsWeb
                                ? Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                color: Theme.of(context).highlightColor)
                                : Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                color:
                                Theme.of(context).highlightColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    _uploadImage();
                  },
                  child: const Text('Upload'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
            const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        print("_pick");
        print(_pickedFile.path);
      });
    }
  }

  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
  }

  Future<void> patchUserProfileImage() async {
    var formData = (_croppedFile == null) ? FormData.fromMap({'image': await MultipartFile.fromFile(_pickedFile.path)}) : FormData.fromMap({'image': await MultipartFile.fromFile(_croppedFile.path)});
    print("formData");
    print(formData);
    var dio = new Dio();
    var response = await dio.post(baseUri+userId, data: formData);
    print(response.data);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FeedCreateRegister(userId: userId, feedContent: _textController.text, feedUrl: response.data,))
    );
  }
}