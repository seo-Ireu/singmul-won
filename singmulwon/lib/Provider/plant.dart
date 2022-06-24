import 'package:flutter/foundation.dart';

class Plant with ChangeNotifier {
  final String id;
  final String name;
  final String sort;
  final String image;
  final double water;
  final double light;
  final double favorite;
  int isFavorite;

  Plant({
    @required this.id,
    @required this.name,
    @required this.sort,
    @required this.image,
    @required this.water,
    @required this.light,
    @required this.favorite,
    this.isFavorite = 0,
  });
  //수정sql Helper를 위한 toMap()생성함
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "sort": sort,
      "image": image,
      "water": water,
      "light": light,
      "favorite": favorite,
      "isFavorite": isFavorite
    };
  }

  void toggleFavoriteStatus() {
    if (isFavorite == 0)
      isFavorite = 1;
    else
      isFavorite = 0;
    notifyListeners();
  }

  @override
  String toString() {
    return "Plant(id:$id, name:$name, water:$water, light:$light)";
  }
}
