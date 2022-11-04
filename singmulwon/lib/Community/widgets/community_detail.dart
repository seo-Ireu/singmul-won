import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Community/screens/community_write_screen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/c_comment_model.dart';
import '../models/community_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../provider/Users.dart';
class CommunityDetail extends StatefulWidget {
  @override
  State<CommunityDetail> createState() => _CommunityDetailState();
}

class _CommunityDetailState extends State<CommunityDetail> {
  var _cIdx;
  var _userid;

  String baseUrl = dotenv.env['BASE_URL'];
  final TextEditingController _commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _cIdx = ModalRoute.of(context).settings.arguments as int;
      _readComment(_cIdx);
    });
  }


  List<cCommentModel> _comments = [];
  List<NetworkImage> _images = <NetworkImage>[];
  List _imagesForParam= [];
  final List<String> _categoryValueList = ['꿀팁', '질문', '나눔'];

  Future _deleteComment(int communityCommentId) async{
    var url = baseUrl+"/community/c_delete_comment.php";

    var response = await http.post(Uri.parse(url), body: {
      "ccId": communityCommentId.toString(),
    });
  }
  Future _readComment(int communityId) async {
    var url =
        baseUrl+"/community/c_read_comment.php";

    var response = await http.post(Uri.parse(url), body: {
      "communityId": communityId.toString(),
    });
    String jsonData = response.body;
    var myJson = await jsonDecode(utf8.decode(response.bodyBytes))['cComment'];

    for (var c in myJson) {
      DateTime date = DateTime.tryParse(c['createAt']);
      String formattedDate = DateFormat('yy-MM-dd').format(date);

      cCommentModel cData = cCommentModel(
          ccId: int.parse(c['ccId']),
          communityId: int.parse(c['communityId']),
          userId: c['userId'],
          comment: c['comment'],
          createAt: formattedDate);

      print("comment: ${cData.comment}, userId: ${cData.userId}");
      _comments.add(cData);
    }
  }
  Future _read(BuildContext context, int communityIdx) async {
    var url =
        baseUrl+"/community/c_read_detail.php";

    var response = await http.post(Uri.parse(url), body: {
      "communityId": communityIdx.toString(),
    });
    var myJson = await jsonDecode(utf8.decode(response.bodyBytes))['community'];
    final temp = await jsonDecode(utf8.decode(response.bodyBytes))['communityImage'];

    List<NetworkImage> images = <NetworkImage>[];
    if (temp.length != 0) {
      _imagesForParam = temp;
      for (var i = 0; i < temp.length; i++) {
        images.add(NetworkImage(
            baseUrl+"/community/flutter_upload_image/images/" +
                temp[i]['url']));
      }
    } else {
      images.add(NetworkImage(
          baseUrl+"/community/flutter_upload_image/images/image_picker4617457671962363705.jpg"));
    }

    setState(() {
      _images = images;
    });

    CommunityModel cm;
    for (var c in myJson) {
      cm = CommunityModel(
          communityId: int.parse(c['communityId']),
          categoryId: int.parse(c['categoryId']),
          userId: c['userId'],
          title: c['title'],
          content: c['content']);
    }

    return cm;
  }
  Future _delete(int delCId) async {
    var url = baseUrl+"/community/c_delete.php";

    var response = await http.post(Uri.parse(url), body: {
      "communityId": delCId.toString(),
    });
    Navigator.of(context).pop();
  }

  _buildMessage(cCommentModel message) {
    var isMe = false;
    final Container msg = Container(
      margin: EdgeInsets.symmetric(horizontal:5.0,vertical: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        color:Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.userId,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                message.comment,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                message.createAt,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12.0,
                ),
              ),
              TextButton(
                onPressed: () {
                  _deleteComment(message.ccId);
                },
                child: Text('삭제',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return Row(
      children: <Widget>[
        msg,
      ],
    );
  }

  _buildMessageComposer(int communityId) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          SizedBox(width:10),
          Expanded(
            child: TextField(
              controller: _commentController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            onPressed: () {
              _createComment(communityId);
            },
          ),
        ],
      ),
    );
  }

  Future _createComment(int communityIdx) async{

    var url = baseUrl+"/community/c_create_comment.php";

    var response = await http.post(Uri.parse(url), body: {
      "communityId": communityIdx.toString(),
      "userId":_userid,
      "comment":_commentController.text,
    });
    _commentController.text="";
    if(response.body.isNotEmpty) {
      var message = json.decode(response.body);

      String id = message["ccId"].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    _userid = context.watch<Users>().userId.toString();

    return FutureBuilder(
        future: _read(context, _cIdx),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              ),
            );
          } else {
            return CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //이미지
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0)),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 2,
                              child: SizedBox(
                                  child: Carousel(
                                boxFit: BoxFit.cover,
                                autoplay: false,
                                dotSize: 3.0,
                                images: _images,
                              )),
                            ),
                          ),
                          //글 내용
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                "[${_categoryValueList[snapshot.data.categoryId]}] ",
                                            style: TextStyle(
                                              color:Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: snapshot.data.title,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '    ${snapshot.data.userId}',
                                            style: TextStyle(
                                              color:Colors.black,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton(
                                        itemBuilder: (context){
                                          return [
                                            PopupMenuItem<int>(
                                              value: 0,
                                              child: Text("수정"),
                                            ),

                                            PopupMenuItem<int>(
                                              value: 1,
                                              child: Text("삭제"),
                                            ),
                                          ];
                                        },
                                        onSelected:(value){
                                          if(value == 0){
                                            Navigator.of(context).pushNamed(
                                                CommunityWriteScreen.routeName,
                                                arguments: {
                                                  "data": snapshot.data,
                                                  "image": _imagesForParam
                                                }).then((value) => {setState(() {})});
                                          }else if(value == 1){
                                            _delete(snapshot.data.communityId);
                                          }
                                        }
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                RichText(
                                  text: TextSpan(
                                    text: snapshot.data.content,
                                    style: TextStyle(
                                      color:Colors.blueGrey,
                                      fontSize: 20.0,
                                      height: 1.4,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.width * 0.55,
                              child: ListView.builder(

                                reverse: true,
                                itemCount: _comments.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final cCommentModel comment = _comments[index];
                                  return _buildMessage(comment);
                                },
                              ),
                            ),
                          ),
                          _buildMessageComposer(snapshot.data.communityId),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        });
  }
}
