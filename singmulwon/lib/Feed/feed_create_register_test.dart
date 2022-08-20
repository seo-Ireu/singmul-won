import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Feed/feed_create_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'feed_create_last_test.dart';
import 'feed_test.dart';
import 'my_feed_test.dart';

// void main() => runApp(MaterialApp(
//   home: FeedCreateImage(),
//   initialRoute: '/',
//   routes: {
//     // When we navigate to the "/" route, build the FirstScreen Widget
//     // "/" Route로 이동하면, FirstScreen 위젯을 생성합니다.
//     // "/second" route로 이동하면, SecondScreen 위젯을 생성합니다.
//     '/feed': (context) => FeedPage(),
//     '/feed_create': (context) => FeedCreate(),
//     '/feed_create_register': (context) => FeedCreateImage(),
//     '/myfeed': (context) => MyFeedPage(),
//   },
// ));

class FeedCreateImage extends StatefulWidget {
  final String userId;
  final String feedContent;

  const FeedCreateImage(
      {Key key, @required this.userId, @required this.feedContent})
      : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState(userId, feedContent);
}

class _FeedPageState extends State<FeedCreateImage> {
  Future feeds;
  String userId;
  String feedContent;

  _FeedPageState(this.userId, this.feedContent);

  XFile image;
  //불러온 image list
  List _images = [];
  //저장할 image list
  List<XFile> _selectedFiles = [];
  final ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  Future sendImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    var uri = "http://54.177.126.159/ubuntu/flutter/feed/create.php";
    var request = http.MultipartRequest('POST', Uri.parse(uri));

    if (img != null) {
      var pic = await http.MultipartFile.fromPath("image", img.path);
      print("pic: ${img.path}");
      request.files.add(pic);
      await request.send().then((result) {
        http.Response.fromStream(result).then((response) {
          if (response.body.isNotEmpty) {
            var message = json.decode(response.body);

            print("!!!${message}");
            // show snackbar if input data successfully
            final snackBar = SnackBar(content: Text(message['message']));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          //get new list images
          getImageServer();
        });
      }).catchError((e) {
        print(e);
      });
    }
  }

  Future sendImages() async {
    var uri = "http://54.177.126.159/ubuntu/flutter/feed/create.php";
    var request = http.MultipartRequest('POST', Uri.parse(uri));

    try {
      if (_selectedFiles.isNotEmpty) {
        for (int i = 0; i < _selectedFiles.length; i++) {
          var pic = await http.MultipartFile.fromPath(
              "image[]", _selectedFiles[i].path);
          print("pick${i}: ${_selectedFiles[i].path}");
          request.files.add(pic);
        }

        await request.send().then((result) {
          http.Response.fromStream(result).then((response) {
            if (response.body.isNotEmpty) {
              var message = json.decode(response.body);

              print(message);
              // show snackbar if input data successfully
              final snackBar = SnackBar(content: Text(message['message']));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            //get new list images
            getImageServer();
          });
        }).catchError((e) {
          print(e);
        });
      } else {
        print("image is not selected!");
      }
    } catch (e) {
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

      sendImages();
    }
  }

  Future getImageServer() async {
    try {
      final response = await http
          .get(Uri.parse('http://54.177.126.159/ubuntu/flutter/feed/list.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //print(data);
        setState(() {
          _images = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getImageServer();
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            content: Container(
                height: MediaQuery.of(context).size.height / 6,
                child: Text('Please upload image!!')),
          );
        });
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
    ));
  }

  Widget buildColumn(snapshot) {
    List<Widget> lists = [
      Center(
          child: Column(
        children: <Widget>[
          ElevatedButton(
            //if user click this button, user can upload image from gallery
            onPressed: () {
              Navigator.pop(context);
              pickImages();
              sendImages();
            },
            child: Row(
              children: [
                Icon(Icons.image),
                Text('From Gallery'),
              ],
            ),
          ),
          ElevatedButton(
            //if user click this button. user can upload image from camera
            onPressed: () {
              Navigator.pop(context);
              sendImages();
            },
            child: Row(
              children: [
                Icon(Icons.camera),
                Text('From Camera'),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              if (_images.length != 0) {
                for (int i = 0; i < _images.length; i++)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FeedCreateRegister(
                              userId: userId,
                              feedContent: feedContent,
                              feedUrl:
                                  'http://54.177.126.159/ubuntu/flutter/feed/image/' +
                                      _images[i]['url'])));
              } else {
                myAlert();
              }
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 150)),
            ),
            child: Text('게시하기'),
          )
        ],
      )),
    ];
    //Navigator.push(context, MaterialPageRoute(builder: (context) => MyFeedPage()));
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          padding: const EdgeInsets.all(3),
          children: lists,
        ),
      ),
    );
  }
}
