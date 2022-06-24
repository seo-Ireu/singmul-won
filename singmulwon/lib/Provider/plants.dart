import 'package:flutter/material.dart';

import './plant.dart';

class Plants with ChangeNotifier {
  List<Plant> _plants = [];
  //수정 임시로 데이터 2개 넣어놈
  List<Plant> get plants {
    _plants.add(Plant(
        id: "00",
        name: "plant1",
        sort: "0",
        image: "imageUrl1",
        water: 20.0,
        light: 50.0,
        favorite: 90.0,
        isFavorite: 0));
    _plants.add(Plant(
        id: "01",
        name: "plant2",
        sort: "0",
        image: "imageUrl2",
        water: 45.0,
        light: 78.0,
        favorite: 90.0,
        isFavorite: 0));
    return [..._plants];
  }

  // List<Plant> get favoriteItems {
  //   return _plants.where((prodPlant) => prodPlant.isFavorite).toList();
  // }

  Plant findById(String id) {
    return _plants.firstWhere((prod) => prod.id == id);
  }

  void addPlant(Plant plant) {
    final newProduct = Plant(
      name: plant.name,
      sort: plant.sort,
      image: plant.image,
      water: plant.water,
      light: plant.light,
      favorite: plant.favorite,
      id: DateTime.now().toString(),
    );
    _plants.add(newProduct);
    // _plants.insert(0, newProduct); // at the start of the list
    notifyListeners();
  }

  void updatePlant(String id, Plant newProduct) {
    final prodIndex = _plants.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _plants[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deletePlant(String id) {
    _plants.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
