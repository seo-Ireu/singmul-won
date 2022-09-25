class BoastPlantModel{
  final int myPlantId;
  final String userId;
  final String plantName;
  final String image;
  final int likes;

  BoastPlantModel(
      {this.myPlantId, this.userId, this.plantName, this.image, this.likes}
      );

  static BoastPlantModel fromJson(json) => BoastPlantModel(
    myPlantId: json['myPlantId'] as int,
    userId: json['userId'],
    plantName: json['plantName'],
    image: json['image'],
    likes: json['likes'] as int,
  );


}