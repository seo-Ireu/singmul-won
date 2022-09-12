import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Community/write_page.dart';
import 'package:http/http.dart' as http;

import 'c_comment_model.dart';
import 'community_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class CommunityDetail extends StatefulWidget {
  static const routeName = '/community_detail.dart';

  @override
  State<CommunityDetail> createState() => _CommunityDetailState();

}

class _CommunityDetailState extends State<CommunityDetail> {
  String baseUrl = dotenv.env['BASE_URL'];
  TextEditingController _comment = TextEditingController();

  List<cCommentModel> _comments = [];
  final List<String> _categoryValueList = ['','꿀팁', '질문', '나눔'];
  String _selectedValue = '꿀팁';
  int _selectedCategoryIndex =1;
  List _images=[];

  Future _read(BuildContext context, int communityIdx) async{
    var url = baseUrl+"/community/c_read_detail.php";

    var response = await http.post(Uri.parse(url), body: {
      "communityId": communityIdx.toString(),
    });
    String jsonData = response.body;
    var myJson = await jsonDecode(jsonData)['community'];
    final temp =await jsonDecode(jsonData)['communityImage'];

    setState(() {
      _images = temp;
    });
    CommunityModel cm;
    for (var c in myJson){
      cm = CommunityModel(communityId:int.parse(c['communityId']), categoryId:int.parse(c['categoryId']),userId: c['userId'],title: c['title'],content: c['content']);
    }
    _readComment(communityIdx);
    return cm;
  }
  Future _delete(int delCId) async{
    var url = "http://54.177.126.159/ubuntu/flutter/community/c_delete.php";

    var response = await http.post(Uri.parse(url), body: {
      "communityId":delCId.toString(),
    });
    Navigator.of(context).pop();
  }
  Future _createComment(int communityIdx) async{
    var url = "http://54.177.126.159/ubuntu/flutter/community/c_create_comment.php";

    var response = await http.post(Uri.parse(url), body: {
      "communityId": communityIdx.toString(),
      "userId":"admin",
      "comment":_comment.text,
    });
  }
  Future _readComment(int communityId) async{
    var url = "http://54.177.126.159/ubuntu/flutter/community/c_read_comment.php";

    var response = await http.post(Uri.parse(url), body: {
      "communityId": communityId.toString(),
    });
    String jsonData = response.body;
    var myJson = await jsonDecode(jsonData)['cComment'];
    for (var c in myJson) {
      cCommentModel cData = cCommentModel(
          communityId: int.parse(c['communityId']),
          userId: c['userId'],
          comment: c['comment']);
      print("comment: ${cData.comment}, userId: ${cData.userId}");
      _comments.add(cData);
    }
  }
  Widget _buildComment() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: CircleAvatar(
            child: ClipOval(
              child: Image(
                height: 50.0,
                width: 50.0,
                image: AssetImage("assets/plant_1.jfif"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          "comments[index].authorName",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text("comments[index].text"),
        trailing: IconButton(
          icon: Icon(
            Icons.favorite_border,
          ),
          color: Colors.grey,
          onPressed: () => print('Like comment'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _cIdx = ModalRoute.of(context).settings.arguments as int;

    return Scaffold(
      backgroundColor: Color(0xFFEDF0F6),
      body: FutureBuilder(
        future:_read(context, _cIdx),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData ==false){
            return CircularProgressIndicator();

          }else if(snapshot.hasError){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              ),
            );
          }else{
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 40.0),
                    width: double.infinity,
                    height:600.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    iconSize: 30.0,
                                    color: Colors.black,
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: ListTile(
                                      title: Text(
                                        snapshot.data.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(snapshot.data.userId),
                                      trailing: IconButton(
                                        icon: Icon(Icons.more_horiz),
                                        color: Colors.black,
                                        onPressed: () => print('More'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onDoubleTap: () => print('Like post'),
                                child: Container(
                                  // color: const Color(0xffd0cece),
                                    width: MediaQuery.of(context).size.width * 0.3,
                                    height: MediaQuery.of(context).size.width * 0.3,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                    child:  ListView.builder(
                                        itemCount: _images.length,
                                        itemBuilder: (context, i) {
                                          return ListTile(
                                              subtitle: Image.network('http://54.177.126.159/ubuntu/flutter/community/flutter_upload_image/images/'+_images[i]['url']));
                                        })
                                  // Center(
                                  //     child: _image == null
                                  //         ? Text('No image selected.')
                                  //         : Image.file(File(_image.path)))
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.favorite_border),
                                              iconSize: 30.0,
                                              onPressed: () => print('Like post'),
                                            ),
                                            Text(
                                              '2,515',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              iconSize: 30.0,
                                              onPressed: () => _delete(snapshot.data.communityId),
                                            ),
                                            Text(
                                              'Delete',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.update),
                                              iconSize: 30.0,
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    WritePage.routeName,
                                                    arguments: {"data":snapshot.data,"image":_images});
                                              }
                                            ),
                                            Text(
                                              'update',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child:Row(
                                  children: <Widget>[
                                    Text(snapshot.data.content, style:TextStyle(
                                      fontSize: 24.0,
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                      children: <Widget>[
                        _buildComment(),
                        _buildComment(),
                        _buildComment(),
                      ],
                    ),

                ],
              ),
            );
          }
        }
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -2),
                blurRadius: 6.0,
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              controller: _comment,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.all(20.0),
                hintText: 'Add a comment',

                suffixIcon: Container(
                  margin: EdgeInsets.only(right: 4.0),
                  width: 70.0,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Color(0xFF23B66F),
                    onPressed: () => {_createComment(_cIdx)},
                    child: Icon(
                      Icons.send,
                      size: 25.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}