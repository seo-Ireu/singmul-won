import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './feed.dart';

class Feeds with ChangeNotifier {
  List<Feed> _feeds = [];
  List<Feed> get feeds {
    _feeds.add(Feed(
        id: "1",
        userId: "lshhhhh",
        content: "제가 키운 다육이에요.",
        imageUrl: "assets/plant_1.jfif",
        date: DateFormat.MEd().format(DateTime.now()),
        profileImageurl: "assets/human_1.jfif"));
    _feeds.add(Feed(
        id: "2",
        userId: "lyhwaniiiii",
        content: "첫 피드",
        imageUrl: "assets/plant_2.jfif",
        date: DateFormat.MEd().format(DateTime.now()),
        profileImageurl: "assets/human_2.jfif"));
    _feeds.add(Feed(
        id: "3",
        userId: "joookh123",
        content: "장미가 다 자랐어요. 2개월 걸렸습니다.",
        imageUrl: "assets/plant_3.jfif",
        date: DateFormat.MEd().format(DateTime.now()),
        profileImageurl: "assets/human_4.jfif"));
    _feeds.add(Feed(
        id: "4",
        userId: "jmj1004",
        content: "선물 받은 선인장..",
        imageUrl: "assets/plant_4.jfif",
        date: DateFormat.MEd().format(DateTime.now()),
        profileImageurl: "assets/human_3.jfif"));
    _feeds.add(Feed(
        id: "5",
        userId: "jmj1004",
        content: "평소에 키우던 유칼립투스...애정 가득",
        imageUrl: "assets/plant_5.jfif",
        date: DateFormat.MEd().format(DateTime.now()),
        profileImageurl: "assets/human_3.jfif"));
    _feeds.add(Feed(
        id: "6",
        userId: "joookh123",
        content: "아침에 찍은 오렌지 자스민",
        imageUrl: "assets/plant_6.jfif",
        date: DateFormat.MEd().format(DateTime.now()),
        profileImageurl: "assets/human_4.jfif"));
    _feeds.add(Feed(
        id: "7",
        userId: "jmj1004",
        content: "행잉식물 피쉬본 에어 플랜트 키운지 30일차",
        imageUrl: "assets/plant_7.jfif",
        date: DateFormat.MEd().format(DateTime.now()),
        profileImageurl: "assets/human_3.jfif"));
    _feeds.add(Feed(
        id: "8",
        userId: "lyhwaniiiii",
        content: "키우기 쉬운 아비스 식물",
        imageUrl: "assets/plant_8.jfif",
        date: DateFormat.MEd().format(DateTime.now()),
        profileImageurl: "assets/human_2.jfif"));
    _feeds.add(Feed(
        id: "9",
        userId: "lshhhhh",
        content: "스칸디아모스 이쁘당",
        imageUrl: "assets/plant_9.jfif",
        date: DateFormat.MEd().format(DateTime.now()),
        profileImageurl: "assets/human_1.jfif"));
    _feeds.add(Feed(
        id: "10",
        userId: "lshhhhh",
        content: "으라차차차 10번째 마지막 피드 ",
        imageUrl: "assets/plant_1.jfif",
        date: DateFormat.MEd().format(DateTime.now()),
        profileImageurl: "assets/human_1.jfif"));
    return _feeds;
  }
}
