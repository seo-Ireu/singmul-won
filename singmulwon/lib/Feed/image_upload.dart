import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Feed/feed_create_last_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

final _textController = new TextEditingController();

void main() => runApp(MaterialApp(
  home: FeedCreate(),
  debugShowCheckedModeBanner: false,
));

class FeedCreate extends StatefulWidget {
  static const routeName = '/image_upload.dart';
  final String userId;
  final String feedId;

  const FeedCreate({Key key, @required this.userId, @required this.feedId}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(userId, feedId);
}

class _HomeState extends State<FeedCreate> {
  Future feeds;
  String userId;
  String feedId;

  XFile image;
  //불러온 image list
  //저장할 image list
  List<XFile> _selectedFiles = [];
  final ImagePicker picker = ImagePicker();

  _HomeState(this. userId, this. feedId);


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
  }
}
