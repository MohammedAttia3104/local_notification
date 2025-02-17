import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationServices {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static StreamController<NotificationResponse> notificationStreamController =
      StreamController();

  static void onTap(NotificationResponse notificationResponse) {
    notificationStreamController.add(notificationResponse);
  }

  static Future<void> initialize() async {
    InitializationSettings initializeSettings = const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );
    tz.initializeTimeZones();

    flutterLocalNotificationsPlugin.initialize(
      initializeSettings,
      onDidReceiveBackgroundNotificationResponse: onTap,
      onDidReceiveNotificationResponse: onTap,
    );
  }

  static Future<void> showSimpleNotification() async {
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "0",
        "Simple Notification",
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        sound: RawResourceAndroidNotificationSound(
          "simple.wav".split(".").first,
        ),
      ),
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      "Simple Notification",
      "This is a simple notification",
      notificationDetails,
      payload: "Simple Notification",
    );
  }

  static Future<void> showRepeatedNotification() async {
    NotificationDetails repeatedNotificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "1",
        "Repeated Notification",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(
          "repeated.wav".split(".").first,
        ),
      ),
    );

    await flutterLocalNotificationsPlugin.periodicallyShow(
      1,
      "Repeated Notification",
      "This is a repeated notification",
      RepeatInterval.everyMinute,
      repeatedNotificationDetails,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  static Future<void> showScheduledNotification() async {
    NotificationDetails scheduledNotificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "2",
        "Scheduled Notification",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(
          "scheduled.wav".split(".").first,
        ),
      ),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      "Scheduled Notification",
      "This is a scheduled notification",
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
      scheduledNotificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  static Future<void> cancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
