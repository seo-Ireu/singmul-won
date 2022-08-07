class UserPlant {
  final String myPlantId;
  final String myPlantNickname;
  final String plantName;
  final String image;
  final String humi;
  final String lumi;

  UserPlant(
      {this.myPlantId,
      this.myPlantNickname,
      this.plantName,
      this.humi,
      this.lumi,
      this.image});

  static UserPlant fromJson(json) => UserPlant(
        myPlantId: json['myPlantId'],
        myPlantNickname: json['myPlantNickname'],
        plantName: json['plantName'],
        humi: json['humi'],
        lumi: json['lumi'],
        image: json['image'],
      );
}
