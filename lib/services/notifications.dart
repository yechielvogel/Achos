import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const String customAppIconFilePath =
    '/Users/Yechiel/Code/tzivos_hashem_milwaukee/android/app/src/main/res/mipmap-hdpi/ic_launcher_monochrome.png';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<String> notifications = [
    'Did you grow with the flow today? 💐💐',
    'ACHOS REMINDER 💗',
    "don't forget to fill out your checklist on time today⏳",
    'run 🏃 achos is waiting',
    'you know what time it is…💐💐💐',
    'dont lose your streak 🌊',
  ];

  final Random random = Random();
  int currentNotificationIndex = 0;

  Future<void> showNextRandomNotification() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (currentNotificationIndex >= notifications.length) {
      // Shuffle the list if all notifications have been shown
      notifications.shuffle();
      currentNotificationIndex = 0;
    }

    final String randomMessage = notifications[currentNotificationIndex];

    // Save the current index to shared preferences before updating it
    await prefs.setInt('currentNotificationIndex', currentNotificationIndex);

    currentNotificationIndex++; // Move this line here
    await prefs.setInt('currentNotificationIndex', currentNotificationIndex);
    print('Updated currentNotificationIndex: $currentNotificationIndex');
  }

  Future<void> initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the saved current index from shared preferences
    currentNotificationIndex = prefs.getInt('currentNotificationIndex') ?? 0;
  }

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('file://${customAppIconFilePath}');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future scheduleNotification({
    int id = 0,
    String? title = 'Achos',
  }) async {
    // Select a random message from the list
    if (currentNotificationIndex >= notifications.length) {
      // Shuffle the list if all notifications have been shown
      notifications.shuffle();
      currentNotificationIndex = 0;
    }
    final String randomMessage = notifications[currentNotificationIndex];

    // Increment the current index for the next random message
    showNextRandomNotification();

    // Schedule the notification for 8:30 AM
    final scheduledTime = tz.TZDateTime(
      tz.local,
      DateTime.now().year, // Use the current year
      DateTime.now().month, // Use the current month
      DateTime.now().day, // Use the current day
      21, // Hour (24-hour format)
      00, // Minute
    );
    print('Scheduled Time: $scheduledTime');

    return notificationsPlugin.zonedSchedule(
      id,
      title,
      randomMessage, // Use the randomly selected message
      scheduledTime,
      notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}





// ..
// ..
// ..
// class Notifications {
//   Notifications();
//   final _notifications = FlutterLocalNotificationsPlugin();

//   Future<void> initialize() async {
//     tz.initializeTimeZones();
//     const AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings('@drawable/launch_background');
//     DarwinInitializationSettings iosInitializationSettings =
//         DarwinInitializationSettings(
//             requestAlertPermission: true,
//             requestBadgePermission: true,
//             requestSoundPermission: true,
//             onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
//     final InitializationSettings settings = InitializationSettings(
//         android: androidInitializationSettings, iOS: iosInitializationSettings);
//     await _notifications.initialize(settings);
//   }

//   Future<NotificationDetails> _notificationsDetails() async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('chanel id', 'chanel name',
//             channelDescription: 'description',
//             importance: Importance.max,
//             priority: Priority.max);
//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails();
//     return const NotificationDetails(
//         android: androidNotificationDetails, iOS: darwinNotificationDetails);
//   }

//   Future<void> scheduleDailyNotifications() async {
//     final detais = await _notificationsDetails();

//     // Calculate the time for 7:00 PM
//     tz.TZDateTime scheduledTime = nextInstanceOfSevenPM();

//     await _notifications.zonedSchedule(
//       0, // Notification ID
//       'Daily Notification',
//       'Your notification content here',
//       scheduledTime,
//       detais,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

//   tz.TZDateTime nextInstanceOfSevenPM() {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate =
//         tz.TZDateTime(tz.local, now.year, now.month, now.day, 16, 14, 0);
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//     return scheduledDate;
//   }

//   void _onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) {
//     print('id $id');
//   }
// }
