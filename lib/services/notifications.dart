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

import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<String> notifications = [
    'Did you grow with the flow today? 💐💐',
    'ACHOS REMINDER 💗',
    "Don't forget to fill out your checklist on time today⏳",
    'Run 🏃 Achos is waiting',
    'You know what time it is…💐💐💐',
    "Don't lose your streak 🌊",
  ];

  int currentNotificationIndex = 0;

  Future<void> initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the saved current index from shared preferences
    currentNotificationIndex = prefs.getInt('currentNotificationIndex') ?? 0;
  }

  Future<void> initNotification() async {
    // Your initialization code...
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNextRandomNotification() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the last shown notification date from shared preferences
    final String lastShownDate = prefs.getString('lastShownDate') ?? '';

    // Get today's date
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Check if the last shown notification was not today
    if (lastShownDate != today) {
      // Show the notification for today
      await showNotification(
        title: 'Achos',
        body: notifications[currentNotificationIndex],
      );

      // Increment the current index
      currentNotificationIndex++;

      // If we have reached the end of the list
      if (currentNotificationIndex >= notifications.length) {
        // Shuffle the list
        notifications.shuffle();
        currentNotificationIndex = 0;
      }

      // Save today's date and the current index
      await prefs.setString('lastShownDate', today);
      await prefs.setInt('currentNotificationIndex', currentNotificationIndex);
    }
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    // Your notification code...
  }

  Future<void> scheduleNotification({
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
