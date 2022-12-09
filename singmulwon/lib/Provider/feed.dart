import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Feed with ChangeNotifier {
  final String id;
  final String userId;
  final String content;
  final String imageUrl;
  final String profileImageurl;
  final String date;

  Feed({
    @required this.id,
    @required this.userId,
    @required this.content,
    @required this.imageUrl,
    @required this.date,
    @required this.profileImageurl,
  });
  //수정sql Helper를 위한 toMap()생성함
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "content": content,
      "imageUrl": imageUrl,
      "date": date,
      "profileImageurl": profileImageurl
    };
  }

  @override
  String toString() {
    return "Feed(id:$id, userId:$userId, content:$content, imageUrl:$imageUrl, Date:$date, profileImageurl:$profileImageurl)";
  }
}
