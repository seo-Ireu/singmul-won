import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Feed/feed_create_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'feed_test.dart';
import 'image_upload.dart';
import 'my_feed_test.dart';

<<<<<<< HEAD
Future fetchFeed(String userId, List images, String feedContent) async {
  print("userId: ${userId}, feedContent: ${feedContent}");
  var url = 'http://54.177.126.159/ubuntu/flutter/feed/feed_create.php?userId='+userId+'&feedContent='+feedContent;
=======
Future fetchFeed(String userId, String feedContent, String feedUrl) async {
  var url =
      'http://54.177.126.159/ubuntu/flutter/feed/feed_create.php?userId=' +
          userId +
          '&feedContent=' +
          feedContent +
          '&feedUrl=' +
          feedUrl;
>>>>>>> 5a9245d45166bd7a1eabc689e3c6412b756aaf80
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    if(response.body.isNotEmpty) {
      var message = json.decode(response.body);

      String id = message["feedId"].toString();
      print("!!!!${id}");
      sendImages(id, images);
    }
  } else {
    //만약 응답이 ok가 아니면 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}
Future sendImages(String feedId, List images)async{
  var uri = "http://54.177.126.159/ubuntu/flutter/feed/create.php";
  var request = http.MultipartRequest('POST', Uri.parse(uri));

<<<<<<< HEAD
  try{
    if (images.isNotEmpty){
      for (int i = 0; i < images.length; i++) {
        var pic = await http.MultipartFile.fromPath(
            "image[]", images[i].path);
        print("pick${i}: ${images[i].path}");
        request.files.add(pic);
      }
      request.fields["feedId"] = feedId;

      await request.send().then((result) {
        http.Response.fromStream(result).then((response) {

          if(response.body.isNotEmpty) {
            var message = json.decode(response.body);
            print("!!!${message['message']}");
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
  print("image list length:${images.length.toString()}");

}
void main() => runApp(MaterialApp(
  home: FeedCreateRegister(),
  initialRoute: '/',
  routes: {
    // When we navigate to the "/" route, build the FirstScreen Widget
    // "/" Route로 이동하면, FirstScreen 위젯을 생성합니다.
    // "/second" route로 이동하면, SecondScreen 위젯을 생성합니다.
    '/feed': (context) => FeedPage(),
    '/feed_create': (context) => FeedCreate(),
    '/feed_create_register': (context) => FeedCreateRegister(),
    '/myfeed': (context) => MyFeedPage(),
  },
));
=======
// void main() => runApp(MaterialApp(
//   home: FeedCreateRegister(),
//   initialRoute: '/',
//   routes: {
//     // When we navigate to the "/" route, build the FirstScreen Widget
//     // "/" Route로 이동하면, FirstScreen 위젯을 생성합니다.
//     // "/second" route로 이동하면, SecondScreen 위젯을 생성합니다.
//     '/feed': (context) => FeedPage(),
//     '/feed_create': (context) => FeedCreate(),
//     '/feed_create_register': (context) => FeedCreateRegister(),
//     '/myfeed': (context) => MyFeedPage(),
//   },
// ));
>>>>>>> 5a9245d45166bd7a1eabc689e3c6412b756aaf80

class FeedCreateRegister extends StatefulWidget {
  final String userId;
  final List images;
  final String feedContent;
<<<<<<< HEAD

  FeedCreateRegister({Key key, @required this.userId, @required this.feedContent, @required this.images}) : super(key: key);
=======
  final String feedUrl;
  FeedCreateRegister(
      {Key key,
      @required this.userId,
      @required this.feedContent,
      @required this.feedUrl})
      : super(key: key);
>>>>>>> 5a9245d45166bd7a1eabc689e3c6412b756aaf80

  @override
  _FeedPageState createState() => _FeedPageState(userId, feedContent, images);
}

class _FeedPageState extends State<FeedCreateRegister> {
  Future feeds;
  String userId;
  String feedContent;
  List images;
  static const routeName = '/inst_home';

<<<<<<< HEAD
  _FeedPageState(this. userId, this. feedContent, this. images);

=======
  _FeedPageState(this.userId, this.feedContent, this.feedUrl);
>>>>>>> 5a9245d45166bd7a1eabc689e3c6412b756aaf80

  XFile image;
  //불러온 image list
  List _images = [];
  //저장할 image list
  List<XFile> _selectedFiles = [];
  final ImagePicker picker = ImagePicker();

<<<<<<< HEAD

  Future sendImages()async{
=======
  //we can upload image from camera or from gallery based on parameter
  Future sendImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    var uri =
        "http://54.177.126.159/ubuntu/flutter/community/flutter_upload_image/create.php";
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
>>>>>>> 5a9245d45166bd7a1eabc689e3c6412b756aaf80
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
        print(data);
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
    feeds = fetchFeed(userId, images, feedContent);
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
          Text("게시가 완료되었습니다!"),
          OutlinedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyFeedPage()));
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 150)),
            ),
            child: Text('돌아가기'),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyFeedPage()));
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
