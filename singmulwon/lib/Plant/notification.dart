import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './insert_plant.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// 알림 더미 타이틀
List pushTitleList = ['식물 등록 완료'];
// 알림 그룹 ID 카운트용, 알림이 올때마다 이 값을 1씩 증가 시킨다.
int groupedNotificationCounter = 1;

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

// 알림 발생 함수!!
Future<void> showGroupedNotifications() async {
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
