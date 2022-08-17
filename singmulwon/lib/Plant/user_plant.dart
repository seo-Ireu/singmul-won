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

  SinglePlant(
      {this.myPlantId,
      this.myPlantNickname,
      this.plantInfoId,
      this.humi,
      this.lumi});

  static SinglePlant fromJson(json) => SinglePlant(
      myPlantId: json['myPlantId'],
      myPlantNickname: json['myPlantNickname'],
      plantInfoId: json['plantInfoId'],
      humi: json['humi'],
      lumi: json['lumi']);
}

class AiSetting {
  final String plantInfoId;
  final String humi;
  final String lumi;

  AiSetting({this.plantInfoId, this.humi, this.lumi});

  static AiSetting fromJson(json) => AiSetting(
      plantInfoId: json['plantInfoId'], humi: json['humi'], lumi: json['lumi']);

  String humidity() {
    return humi;
  }

  String luminance() {
    return lumi;
  }
}
