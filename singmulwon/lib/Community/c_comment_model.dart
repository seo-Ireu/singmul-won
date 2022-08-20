class cCommentModel{
  final int communityId;
  final String userId;
  final String comment;

  cCommentModel(
      {this.communityId,this.userId,this.comment}
      );

  static cCommentModel fromJson(json) => cCommentModel(
    communityId: json['communityId'] as int,
    userId: json['userId'],
    comment: json['comment'],
  );
// CommunityModel.fromJson(Map<String,dynamic> json){
//   title=json['title'];
//   content=json['content'];
// }
}