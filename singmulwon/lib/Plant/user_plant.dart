class UserPlant {
  final String myPlantId;
  final String myPlantNickname;
  final String plantName;
  final String plantImage;
  final String image;
  final String humi;
  final String lumi;

  UserPlant(
      {this.myPlantId,
      this.myPlantNickname,
      this.plantName,
      this.plantImage,
      this.humi,
      this.lumi,
      this.image});

  static UserPlant fromJson(json) => UserPlant(
        myPlantId: json['myPlantId'],
        myPlantNickname: json['myPlantNickname'],
        plantName: json['plantName'],
        plantImage: json['plantImage'],
        humi: json['humi'],
        lumi: json['lumi'],
        image: json['image'],
      );
}

class SinglePlant {
  final String myPlantId;
  final String myPlantNickname;
  final String plantInfoId;
  final String humi;
  final String lumi;
  final String humidity;
  final String luminance;
  final String likes;

  SinglePlant(
      {this.myPlantId,
      this.myPlantNickname,
      this.plantInfoId,
      this.humi,
      this.lumi,
      this.humidity,
      this.luminance,
      this.likes});

  static SinglePlant fromJson(json) => SinglePlant(
      myPlantId: json['myPlantId'],
      myPlantNickname: json['myPlantNickname'],
      plantInfoId: json['plantInfoId'],
      humi: json['humi'],
      lumi: json['lumi'],
      humidity: json['humidity'],
      luminance: json['luminance'],
      likes: json['likes']);
}

class SuitableData {
  final String plantInfoId;
  final String humidity;
  final String luminance;

  SuitableData({this.plantInfoId, this.humidity, this.luminance});

  static SuitableData fromJson(json) => SuitableData(
      plantInfoId: json['plantInfoId'],
      humidity: json['humi'],
      luminance: json['lumi']);
}
