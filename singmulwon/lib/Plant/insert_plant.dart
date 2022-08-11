// ignore_for_file: prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, missing_required_param, deprecated_member_use, prefer_const_constructors, non_constant_identifier_names, unused_local_variable, use_key_in_widget_constructors, use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './edit_button.dart';
import './user_plant.dart';

class InsertPlant extends StatefulWidget {
  static const routeName = '/insert-plant';
  @override
  State<InsertPlant> createState() => _InsertPlantState();
}

double _currentWaterValue = 0;
double _currentLightValue = 0;

class _InsertPlantState extends State<InsertPlant> {
  final plantidController = TextEditingController();
  final List<String> _sortValueList = ['', '수선화', '민들레', '선인장'];
  String _selectedValue = '수선화';
  int _selectedSortIndex = 1;
  // Notifications Plugin 생성
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // 알림 초기화
    init();
  }

  void init() async {
    // 알림용 ICON 설정
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // 알림 초기화
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      //onSelectNotification은 알림을 선택했을때 발생
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
    });
  }

  // 알림 더미 타이틀
  List pushTitleList = ['식물 등록 완료'];
  // 알림 그룹 ID 카운트용, 알림이 올때마다 이 값을 1씩 증가 시킨다.
  int groupedNotificationCounter = 1;

  // 알림 발생 함수!!
  Future<void> _showGroupedNotifications() async {
    // 알림 그룹 키
    const String groupKey = 'com.android.example.WORK_EMAIL';
    // 알림 채널
    const String groupChannelId = 'grouped channel id';
    // 채널 이름
    const String groupChannelName = 'grouped channel name';

    // 안드로이드 알림 설정
    const AndroidNotificationDetails notificationAndroidSpecifics =
        AndroidNotificationDetails(groupChannelId, groupChannelName,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: groupKey);

    // 플랫폼별 설정 - 현재 안드로이드만 적용됨
    const NotificationDetails notificationPlatformSpecifics =
        NotificationDetails(android: notificationAndroidSpecifics);

    // 알림 발생!
    await flutterLocalNotificationsPlugin.show(
        groupedNotificationCounter,
        pushTitleList[0],
        '식물이 정상적으로 등록되었습니다.- ${pushTitleList[0]}',
        notificationPlatformSpecifics);
    // 알림 그룹 ID를 1씩 증가 시킨다.
    groupedNotificationCounter++;

    // 그룹용 알림 설정
    // 특징 setAsGroupSummary 가 true 이다.
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(groupChannelId, groupChannelName,
            onlyAlertOnce: true, groupKey: groupKey, setAsGroupSummary: true);

    // 플랫폼별 설정 - 현재 안드로이드만 적용됨
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    // 그룹용 알림 출력
    // 이때는 ID를 0으로 고정시켜 새로 생성되지 않게 한다.
    await flutterLocalNotificationsPlugin.show(
        0, '', '', platformChannelSpecifics);
  }

  Future insertPlant(
      BuildContext context, userid, name, humi, lumi, image) async {
    var url = "http://54.177.126.159/ubuntu/flutter/plant/insert_plant.php";
    var response = await http.post(Uri.parse(url), body: {
      "userid": userid,
      "sort": _selectedSortIndex.toString(),
      "name": name,
      "humi": humi,
      "lumi": lumi,
      "image": image
    });
    _showGroupedNotifications();
    Navigator.of(context).pop();
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (BuildContext context) => ManagePlant()),
    //     (route) => false);
  }

  Future AutoSetting() async {
    var url = "http://54.177.126.159/ubuntu/flutter/plant/auto_setting.php";
    var response = await http.post(Uri.parse(url), body: {
      "plantInfoId": _selectedSortIndex,
    });
    String jsonData = utf8.decode(response.bodyBytes);
    var vld = await json.decode(jsonData)['setting']; //List<dynamic>

    AiSetting setting_plant;
    for (var item in vld) {
      setting_plant = AiSetting(
          plantInfoId: item['plantInfoId'],
          humi: item['humi'],
          lumi: item['lumi']);
    }
    return [setting_plant.humidity(), setting_plant.luminance()];
  }

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context).settings.arguments;
    double waterValue = _currentWaterValue;
    double lightValue = _currentLightValue;
    final picker = ImagePicker();
    File _image;

    Future getImage(ImageSource imageSource) async {
      final image = await picker.pickImage(source: imageSource);

      setState(() {
        _image = File(image.path); // 가져온 이미지를 _image에 저장
      });
    }

    Widget showImage() {
      return SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.height * 0.2,
          child: Center(
              child: _image == null
                  ? Text('Picture')
                  : Image.file(File(_image.path))));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('식물 등록'),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      showImage(),
                      ElevatedButton(
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        child: Text('식물 사진 편집'),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 140,
                        child: TextField(
                          // ignore: prefer_const_constructors
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '식물 이름',
                            hintText: '별명 입력',
                          ),
                          controller: plantidController,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 180,
                        child: Row(
                          children: [
                            SizedBox(width: 100, child: Text("식물 종류")),
                            DropdownButton(
                              value: _selectedValue,
                              items: _sortValueList.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  var index = _sortValueList.indexOf(value);
                                  _selectedValue = value;
                                  _selectedSortIndex = index;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  WaterValue(waterValue.toInt()),
                  LightValue(lightValue.toInt()),
                  FavoriteValue(0),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Icon(Icons.water_drop_outlined),
                  ),
                  Expanded(
                    flex: 7,
                    child: Slider(
                      value: _currentWaterValue,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label:
                          _currentWaterValue //double.parse(snapshot.data.humi)
                              .round()
                              .toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentWaterValue = value;
                          waterValue = _currentWaterValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Icon(Icons.sunny),
                  ),
                  Expanded(
                    flex: 7,
                    child: Slider(
                      value: _currentLightValue,
                      max: 100,
                      divisions: 100,
                      label: _currentLightValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentLightValue = value;
                          lightValue = _currentLightValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 110,
                    height: 40,
                    child: FlatButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text(
                        "자동설정",
                        style: TextStyle(fontSize: 20),
                      ),
                      //수정
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  SizedBox(
                    width: 110,
                    height: 40,
                    child: FlatButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text(
                        "식물등록",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        insertPlant(
                            context,
                            userId,
                            // _selectedSortIndex.toString(),
                            plantidController.text,
                            waterValue.toString(),
                            lightValue.toString(),
                            'https://search.pstatic.net/sunny/?src=https%3A%2F%2Fmedia.istockphoto.com%2Fvectors%2Fecology-logo-green-design-vector-id862500344%3Fk%3D20%26m%3D862500344%26s%3D170667a%26w%3D0%26h%3D9B59bc6G5oyJ5aLBUi909Xkmxp8JB52r_aRvlZT8QwE%3D&type=sc960_832');
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}

double changeWater(BuildContext context, snapshot) {
  return double.parse(snapshot.data.humi);
}

double changeLight(BuildContext context, snapshot) {
  return double.parse(snapshot.data.lumi);
}
