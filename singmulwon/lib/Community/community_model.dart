class CommunityModel{
  int communityId;
  int categoryId;
  String userId;
  String title;
  String content;

  CommunityModel(
  {this.communityId,this.categoryId,this.userId,this.title,this.content}
      );

  static CommunityModel fromJson(json) => CommunityModel(
    communityId: json['communityId'] as int,
    categoryId: json['categoryId'] as int,
    userId: json['userId'],
    title: json['title'],
    content: json['content'],
  );
  // CommunityModel.fromJson(Map<String,dynamic> json){
  //   title=json['title'];
  //   content=json['content'];
  // }
}