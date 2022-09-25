import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Feed/profile_edit_register.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'feed_comment_create_test.dart';
import 'feed_comment_test.dart';
import 'feed_delete_test.dart';
import 'my_feed_test.dart';
import 'feed_test.dart';
import 'feed_detail_test.dart';

import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'feed_create_last_test.dart';

String baseUri = "http://13.209.68.93/ubuntu/flutter/feed/profile_edit_img.php?userId=";

final _nameController = new TextEditingController();
final _IntroController = new TextEditingController();
final _IdController = new TextEditingController();

String before_username = "";
String before_userintro = "";
String before_userid = "";
String images ="";

Future fetchFeed(String userId) async {
  var url =
      'http://13.209.68.93/ubuntu/flutter/feed/profile_edit.php?userId=' +
          userId;
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    //만약 서버가 ok응답을 반환하면, json을 파싱합니다
    print('응답했다');
    var tmp = json.decode(utf8.decode(response.bodyBytes));
    print(tmp);
    return tmp;
  } else {
    //만약 응답이 ok가 아니면 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

class ProfileEdit extends StatefulWidget {
  static const routeName = '/image_test';
  final String title;
  final String userId;

  const ProfileEdit({
    Key key,
    this.title,
    this.userId,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState("프로필 편집", userId);
}

class _HomePageState extends State<ProfileEdit> {
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
        body: Center(
          child: FutureBuilder(
            //통신데이터 가져오기
            future: feeds,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return buildColumn(snapshot);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}에러!!");
              }
              return const CircularProgressIndicator();
            },
          ),
        )
    );
  }

  @override
  Widget buildColumn(snapshot) {
    _nameController.text = snapshot.data["name"];
    _IntroController.text = snapshot.data["profile_intro"];
    _IdController.text = snapshot.data["userId"];
    before_username = snapshot.data["name"];
    before_userintro = snapshot.data["profile_intro"];
    before_userid = snapshot.data["userId"];
    images = snapshot.data["image_id"];

    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(title: Text(title)),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _body()),
        ],
      ),
    );
  }

  Widget _body() {
    if (_croppedFile != null || _pickedFile != null) {
      return _imageCard();
    } else {
      return _uploaderCard();
    }
  }

  Widget _imageCard() {
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
                labelText: '닉네임',
              ),
              controller: _nameController,
            ),
          ),
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'ID',
              ),
              controller: _IdController,
            ),
          ),
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: '소개글',
              ),
              controller: _IntroController,
            ),
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
    return SizedBox(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: FloatingActionButton(
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
              onPressed: () {
                _clear();
              },
              backgroundColor: Colors.redAccent,
              tooltip: 'Delete',
              child: const Icon(Icons.delete),
            ),
          ),
          if (_croppedFile == null)
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: FloatingActionButton(
                onPressed: () {
                  _cropImage();
                },
                backgroundColor: const Color(0xFFBC764A),
                tooltip: 'Crop',
                child: const Icon(Icons.crop),
              ),
            )
        ],
      ),
    );
  }

  Widget _uploaderCard() {
    return Center(
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(
                                'http://13.209.68.93/ubuntu/flutter/account/image/${images}'),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: '닉네임',
                              ),
                              controller: _nameController,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'ID',
                              ),
                              controller: _IdController,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: '소개글',
                              ),
                              controller: _IntroController,
                            ),
                          ),
                        ],
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
                  child: const Text('프로필 사진 및 정보 변경하기'),
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
    var formData = FormData.fromMap({'image': await MultipartFile.fromFile(_pickedFile.path)});
    print("formData");
    print(formData);
    var dio = new Dio();
    var response = await dio.post(baseUri+userId, data: formData);
    print(response.data);

    if (_IdController.text != null && _IntroController.text != null && _nameController.text != null){

    }
    Navigator.push(
        context, MaterialPageRoute(
          builder: (context) =>
              ProfileEditRegister(
                userBeforeId: userId,
                userAfterId: _IdController.text,
                ImageUrl: response.data,
                userIntro: _IntroController.text,
                userName: _nameController.text,
              )
        )
    );
  }
}



// void main() => runApp(MaterialApp(
//   home: ProfileEdit(),
//   initialRoute: '/',
//   routes: {
//     // When we navigate to the "/" route, build the FirstScreen Widget
//     // "/" Route로 이동하면, FirstScreen 위젯을 생성합니다.
//     '/myfeed': (context) => MyFeedPage(),
//     // "/second" route로 이동하면, SecondScreen 위젯을 생성합니다.
//     '/feed': (context) => FeedPage(),
//     '/feed_create': (context) => FeedCreate(),
//     '/feed_detail': (context) => FeedDetail(),
//   },
// ));
