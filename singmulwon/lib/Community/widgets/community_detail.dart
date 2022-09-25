import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_singmulwon_app/Community/screens/community_write_screen.dart';
import '../core/color.dart';
import 'package:http/http.dart' as http;
import '../models/c_comment_model.dart';
import '../models/community_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class CommunityDetail extends StatefulWidget {
  @override
  State<CommunityDetail> createState() => _CommunityDetailState();
}

class _CommunityDetailState extends State<CommunityDetail> {
  var _cIdx;
  String baseUrl = dotenv.env['BASE_URL'];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _cIdx = ModalRoute.of(context).settings.arguments as int;
      _readComment(_cIdx);
    });
  }

  TextEditingController _commentController = TextEditingController();

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
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yy-MM-dd').format(now);

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
      margin: EdgeInsets.only(
        right: 10.0,
        left: 20.0,
        top: 8.0,
        bottom: 8.0,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.lightGreen[100],
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                message.userId,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[400]),
                ),
                onPressed: () {
                  _deleteComment(message.ccId);
                },
                child: Text('삭제',
                 style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                message.comment,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                message.createAt,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
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

  @override
  Widget build(BuildContext context) {
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
                                              color: black.withOpacity(0.8),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: snapshot.data.title,
                                            style: TextStyle(
                                              color: black.withOpacity(0.8),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '    ${snapshot.data.userId}',
                                            style: TextStyle(
                                              color: black.withOpacity(0.5),
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // //좋아요 이미지
                                    // Container(
                                    //   height: 30.0,
                                    //   width: 30.0,
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   decoration: BoxDecoration(
                                    //     color: green,
                                    //     boxShadow: [
                                    //       BoxShadow(
                                    //         color: green.withOpacity(0.2),
                                    //         blurRadius: 15,
                                    //         offset: const Offset(0, 5),
                                    //       ),
                                    //     ],
                                    //     borderRadius:
                                    //         BorderRadius.circular(8.0),
                                    //   ),
                                    //   child: Image.asset(
                                    //     'assets/icons/heart.png',
                                    //     color: white,
                                    //   ),
                                    // ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                RichText(
                                  text: TextSpan(
                                    text: snapshot.data.content,
                                    style: TextStyle(
                                      color: black.withOpacity(0.5),
                                      fontSize: 20.0,
                                      height: 1.4,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.update),
                                        iconSize: 30.0,
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              CommunityWriteScreen.routeName,
                                              arguments: {
                                                "data": snapshot.data,
                                                "image": _imagesForParam
                                              });
                                        }),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      iconSize: 30.0,
                                      onPressed: () =>
                                          _delete(snapshot.data.communityId),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width * 0.3,
                            child: ListView.builder(
                              reverse: true,
                              padding: EdgeInsets.only(top: 15.0),
                              itemCount: _comments.length,
                              itemBuilder: (BuildContext context, int index) {
                                final cCommentModel comment = _comments[index];
                                return _buildMessage(comment);
                              },
                            ),
                          ),
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
