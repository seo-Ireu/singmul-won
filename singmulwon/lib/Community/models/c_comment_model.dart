class cCommentModel {
  final int ccId;
  final int communityId;
  final String userId;
  final String comment;
  final String createAt;

  cCommentModel(
      {this.ccId, this.communityId, this.userId, this.comment, this.createAt});

  static cCommentModel fromJson(json) => cCommentModel(
      ccId: json['ccId'] as int,
      communityId: json['communityId'] as int,
      userId: json['userId'],
      comment: json['comment'],
      createAt: json['createAt']);
// CommunityModel.fromJson(Map<String,dynamic> json){
//   title=json['title'];
//   content=json['content'];
// }
}
