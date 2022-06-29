// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class PlantDetail extends StatefulWidget {
  static const routeName = '/plant-detail';

  @override
  State<PlantDetail> createState() => _PlantDetailState();
}

class _PlantDetailState extends State<PlantDetail> {
  final plantidController = TextEditingController();
  final plantSortController = TextEditingController();
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
        color: const Color(0xffd0cece),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Center(
            child: _image == null
                ? Text('No image selected.')
                : Image.file(File(_image.path))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("식물 편집"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 360,
              child: TextFormField(
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: '식물 이름',
                ),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return 'Id is required';
                  } else {
                    return null;
                  }
                },
                controller: plantidController,
              ),
            ),
            Divider(),
            SizedBox(
              width: 360,
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: '식물 종류',
                ),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return 'Password is required';
                  } else {
                    return null;
                  }
                },
                controller: plantSortController,
              ),
            ),
            Divider(),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: AssetImage('assets/plant_1.jfif'),
                ),
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
            showImage(),
          ],
        ),
      ),
    );
  }
}


                    // Navigator.of(context).pop(context, plantid, sort, image);