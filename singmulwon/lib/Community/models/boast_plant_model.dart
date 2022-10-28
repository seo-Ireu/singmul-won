class BoastPlantModel{
  final int feedId;
  final int myPlantId;
  final String userId;
  final String urls;


  BoastPlantModel(
      {this.feedId,this.myPlantId, this.userId, this.urls}
      );

  static BoastPlantModel fromJson(json) => BoastPlantModel(
    feedId: json['feedId'] as int,
    myPlantId: json['myPlantId'] as int,
    userId: json['userId'],
    urls: json['urls'],
  );


}
