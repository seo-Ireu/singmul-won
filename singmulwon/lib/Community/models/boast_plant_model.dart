class BoastPlantModel{
  final int myPlantId;
  final String plantName;
  final String image;
  final int likes;

  BoastPlantModel(
      {this.myPlantId, this.plantName, this.image, this.likes}
      );

  static BoastPlantModel fromJson(json) => BoastPlantModel(
    myPlantId: json['myPlantId'] as int,
    plantName: json['plantName'],
    image: json['image'],
    likes: json['likes'] as int,
  );


}