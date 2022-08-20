import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Feed/feed_create_last_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

<<<<<<< HEAD
final _textController = new TextEditingController();

void main() => runApp(MaterialApp(
  home: FeedCreate(),
  debugShowCheckedModeBanner: false,
));
=======
// void main() => runApp(MaterialApp(
//   home: Home(),
//   debugShowCheckedModeBanner: false,
// ));
>>>>>>> 5a9245d45166bd7a1eabc689e3c6412b756aaf80

class FeedCreate extends StatefulWidget {
  static const routeName = '/image_upload.dart';
  final String userId;
  final String feedId;

  const FeedCreate({Key key, @required this.userId, @required this.feedId}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(userId, feedId);
}

<<<<<<< HEAD
class _HomeState extends State<FeedCreate> {
  Future feeds;
  String userId;
  String feedId;

=======
class _HomeState extends State<Home> {
>>>>>>> 5a9245d45166bd7a1eabc689e3c6412b756aaf80
  XFile image;
  //불러온 image list
  //저장할 image list
  List<XFile> _selectedFiles = [];
  final ImagePicker picker = ImagePicker();

<<<<<<< HEAD
  _HomeState(this. userId, this. feedId);

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
    var uri =
        "http://54.177.126.159/ubuntu/flutter/community/flutter_upload_image/create.php";
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
>>>>>>> 5a9245d45166bd7a1eabc689e3c6412b756aaf80

  Future pickImages() async {
    final List<XFile> selectedImages = await picker.pickMultiImage();

    if (_selectedFiles.isNotEmpty) {
      setState(() {
        _selectedFiles.clear();
      });
    }
    if (selectedImages.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(selectedImages);
      });

<<<<<<< HEAD
=======
      sendImages();
    }
  } //------------------------------------------

  Future getImageServer() async {
    try {
      final response = await http.get(Uri.parse(
          'http://54.177.126.159/ubuntu/flutter/community/flutter_upload_image/list.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          _images = data;
        });
      }
    } catch (e) {
      print(e);
>>>>>>> 5a9245d45166bd7a1eabc689e3c6412b756aaf80
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      pickImages();
                      // sendImage(ImageSource.gallery);
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
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Upload Image'),
          actions: [
            IconButton(
              onPressed: () => myAlert(),
              icon: Icon(Icons.upload),
            )
          ],
        ),
<<<<<<< HEAD
        body:
        Row(
          children: <Widget>[
            SizedBox(height: 50.0,),
            Expanded(
              child:
              TextField(
                controller: _textController,
              ),
            ),
            (_selectedFiles.length != 0) ? TextButton(child:Text("피드 업로드"),
                onPressed: ()=>FeedCreateRegister(userId: userId, images: _selectedFiles, feedContent: _textController.text))
                : TextButton(child: Text("이미지 업로드"), onPressed: () => pickImages()),
          ],
        ),
    );
=======
        body: _images.length != 0
            ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: _images.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Image(
                      image: NetworkImage(
                          'http://54.177.126.159/ubuntu/flutter/community/flutter_upload_image/images/' +
                              _images[index]['url']),
                      fit: BoxFit.cover,
                    ),
                  );
                })
            : Center(
                child: Text("No Image"),
              ));
>>>>>>> 5a9245d45166bd7a1eabc689e3c6412b756aaf80
  }
}
