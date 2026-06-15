import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// ✨Initialize the local notification plugin.⭐
  /// Called once when the app starts to initialize the local notification
  /// plugin. This sets up the plugin to work on both Android and iOS and
  /// sets up the callbacks for when the user taps on a notification.
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

/*    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        selectNotificationStream.add(notificationResponse.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );*/
  }

  /// ✨Shows a notification using the provided [RemoteMessage].⭐
  static Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            message.messageId ?? Random().nextInt(99999).toString(),
            message.messageId ?? Random().nextInt(99999).toString(),
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            icon: "@mipmap/launcher_icon");

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: "default",
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      // Random().nextInt(9999),
      0,
      Get.deviceLocale!.languageCode == "ar"
          ? message.data['Arabic_Title']
          : message.data['English_Title'],
      Get.deviceLocale!.languageCode == "ar"
          ? message.data['Arabic_Body']
          : message.data['English_Body'],
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }
}
