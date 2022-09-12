import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../models/c_comment_model.dart';
import '../models/community_model.dart';
import '../widgets/community_detail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CommunityComment extends StatefulWidget {
  @override
  State<CommunityComment> createState() => _CommunityCommentState();
}

class _CommunityCommentState extends State<CommunityComment> {
  var _cIdx;
  String baseUrl = dotenv.env['BASE_URL'];
  @override
  void initState(){
    super.initState();
    Future.delayed(Duration.zero, () {
      _cIdx = ModalRoute.of(context).settings.arguments as int;
      print("_cIdx = ${_cIdx}");
    });
  }
  TextEditingController _commentController = TextEditingController();

  Future _createComment(int communityIdx) async{
    var url = baseUrl+"/community/c_create_comment.php";

    var response = await http.post(Uri.parse(url), body: {
      "communityId": communityIdx.toString(),
      "userId":"admin",
      "comment":_commentController.text,
    });
    _commentController.text="";
    if(response.body.isNotEmpty) {
      var message = json.decode(response.body);

      String id = message["ccId"].toString();
      print("!!!!${id}");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
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
            controller: _commentController,
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
                  onPressed: () => {
                    _createComment(_cIdx),
                  },
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
    );
  }
}
