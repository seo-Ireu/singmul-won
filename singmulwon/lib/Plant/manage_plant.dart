// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names, unnecessary_string_interpolations, avoid_print, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';
import 'dart:developer';

import './edit_plant.dart';
import './insert_plant.dart';
import './future_plant.dart';
import './device_screen.dart';

class ManagePlant extends StatefulWidget {
  static const routeName = '/manage-plant';
  @override
  State<ManagePlant> createState() => _ManagePlantState();
}

class _ManagePlantState extends State<ManagePlant> {
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  final String targetDeviceName = 'HC-06';
  final _wifiSsidController = TextEditingController();
  final _wifiPwController = TextEditingController();
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    initBle();
    if (mounted) {
      setState(() {});
    }
  }

  void initBle() {
    // BLE 스캔 상태 얻기 위한 리스너
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  /*
  스캔 시작/정지 함수
  */
  scan(setState) async {
    if (!_isScanning) {
      // 스캔 중이 아니라면
      // 기존에 스캔된 리스트 삭제
      scanResultList.clear();
      // 스캔 시작, 제한 시간 4초
      flutterBlue.startScan(timeout: Duration(seconds: 4));
      // 스캔 결과 리스너
      flutterBlue.scanResults.listen((results) {
        results.forEach((element) {
          //찾는 장치명인지 확인
          if (element.device.name == targetDeviceName) {
            // 장치의 ID를 비교해 이미 등록된 장치인지 확인
            if (scanResultList
                    .indexWhere((e) => e.device.id == element.device.id) <
                0) {
              // 찾는 장치명이고 scanResultList에 등록된적이 없는 장치라면 리스트에 추가
              scanResultList.add(element);
            }
          }
        });

        // UI 갱신
        setState(() {});
      });
    } else {
      // 스캔 중이라면 스캔 정지
      flutterBlue.stopScan();
    }
  }

  /*
  여기서부터는 장치별 출력용 함수들
  */
  /*  장치의 신호값 위젯  */
  Widget deviceSignal(ScanResult r) {
    return Text(r.rssi.toString());
  }

  /* 장치의 MAC 주소 위젯  */
  Widget deviceMacAddress(ScanResult r) {
    return Text(r.device.id.id);
  }

  /* 장치의 명 위젯  */
  Widget deviceName(ScanResult r) {
    String name = '';

    if (r.device.name.isNotEmpty) {
      // device.name에 값이 있다면
      name = r.device.name;
    } else if (r.advertisementData.localName.isNotEmpty) {
      // advertisementData.localName에 값이 있다면
      name = r.advertisementData.localName;
    } else {
      // 둘다 없다면 이름 알 수 없음...
      name = 'N/A';
    }
    return Text(name);
  }

  /* BLE 아이콘 위젯 */
  Widget leading(ScanResult r) {
    return CircleAvatar(
      // ignore: sort_child_properties_last
      child: Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
      backgroundColor: Colors.cyan,
    );
  }

  /* 장치 아이템을 탭 했을때 호출 되는 함수 */
  void onTap(ScanResult r, snapshot) async {
    // 단순히 이름만 출력
    print('${r.device.name}');
    log(snapshot);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              DeviceScreen(device: r.device, snaps: snapshot)),
    );
    /*
    connect(r.device);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Write"),
            content: Column(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _wifiSsidController,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _wifiPwController,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Send"),
                onPressed: () {
                  //  characteristic.write(utf8
                  //      .encode(_wifiSsidController.value.text+_wifiPwController.value.text));
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
        */
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => DeviceScreen(device: r.device)),
    // );
  }

  Future<bool> connect(device) async {
    Future<bool> returnValue;
    setState(() {});
    /* 
      타임아웃을 10초(10000ms)로 설정 및 autoconnect 해제
      참고로 autoconnect가 true되어있으면 연결이 지연되는 경우가 있음.
     */
    await device
        .connect(autoConnect: false)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      //타임아웃 발생
      //returnValue를 false로 설정
      returnValue = Future.value(false);
      debugPrint('timeout failed');
    }).then((data) {
      if (returnValue == null) {
        //returnValue가 null이면 timeout이 발생한 것이 아니므로 연결 성공
        debugPrint('connection successful');
        returnValue = Future.value(true);
      }
    });
    return returnValue ?? Future.value(false);
  }

  /* 장치 아이템 위젯 */
  Widget listItem(ScanResult r, snapshot) {
    return ListTile(
      onTap: () => onTap(r, snapshot),
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMacAddress(r),
      trailing: deviceSignal(r),
    );
  }

  void showPopup(context, snapshot) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: StatefulBuilder(builder: (context, StateSetter setState) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 380,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Scaffold(
                body: Center(
                  /* 장치 리스트 출력 */
                  child: ListView.separated(
                    itemCount: scanResultList.length,
                    itemBuilder: (context, index) {
                      return listItem(scanResultList[index], snapshot);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => scan(setState),
                  child: Icon(_isScanning ? Icons.stop : Icons.search),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final arguments = (ModalRoute.of(context).settings.arguments ??
        <String, String>{}) as Map;
    String user = arguments['userid'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '내 식물관리',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(InsertPlant.routeName, arguments: user)
                  .then((value) => {setState(() {})});
            },
            icon: const Icon(Icons.add),
          ),
        ],
        elevation: 0,
      ),
      body:
          // MyPlantView(context, user),
          SingleChildScrollView(
        child: FutureBuilder(
          future: myPlantList(user),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 12,
                        bottom: 16,
                        top: 24,
                      ),
                      child: const Text(
                        'My Plants',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.4,
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(
                                      EditPlant.routeName,
                                      arguments:
                                          (snapshot.data[index].myPlantId),
                                    )
                                    .then((value) => {setState(() {})});
                              },
                              child: Container(
                                width: 270,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                // ignore: sort_child_properties_last
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 70,
                                      right: 50,
                                      top: 50,
                                      bottom: 50,
                                      child: Image.asset(
                                          snapshot.data[index].plantImage),
                                    ),
                                    Positioned(
                                      bottom: 15,
                                      left: 20,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          Text(
                                            snapshot
                                                .data[index].myPlantNickname,
                                            style: const TextStyle(
                                              color:
                                                  // Colors.white70,
                                                  Color.fromARGB(
                                                      255, 86, 138, 88),
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            height: 2,
                                          ),
                                          Text(
                                            snapshot.data[index].plantName,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 86, 138, 88),
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 197, 215, 198),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            );
                          }),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        bottom: 10,
                        top: 30,
                      ),
                      child: const Text(
                        'Simply',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: size.height * 0.22,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 189, 200, 189),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 80,
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              margin:
                                  const EdgeInsets.only(bottom: 10, top: 10),
                              width: size.width,
                              child: Row(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 86, 138, 88),
                                                  shape: BoxShape.circle),
                                            ),
                                            Positioned(
                                              height: 75,
                                              bottom: 5,
                                              left: 0,
                                              right: 0,
                                              child: Image.asset(snapshot
                                                  .data[index].plantImage),
                                            ),
                                            Positioned(
                                              bottom: 5,
                                              left: 80,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data[index]
                                                        .myPlantNickname,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Color.fromARGB(
                                                            255, 57, 56, 56),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Row(
                                                    children: [
                                                      // ignore: prefer_interpolation_to_compose_strings
                                                      Text('습도: ' +
                                                          snapshot.data[index]
                                                              .humi),
                                                      Container(
                                                        width: 10,
                                                      ),
                                                      // ignore: prefer_interpolation_to_compose_strings
                                                      Text('조도: ' +
                                                          snapshot
                                                              .data[index].lumi)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 150, bottom: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.white),
                                          child: IconButton(
                                            onPressed: () {
                                              showPopup(
                                                  context,
                                                  snapshot
                                                      .data[index].myPlantId);
                                            },
                                            icon: Icon(Icons.bluetooth),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, bottom: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.white),
                                          child: IconButton(
                                              icon: Icon(Icons.delete),
                                              iconSize: 30.0,
                                              onPressed: () {
                                                setState(() {
                                                  deletePlant(
                                                      context,
                                                      snapshot.data[index]
                                                          .myPlantId);
                                                });
                                              }),
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ]);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}에러!!");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
