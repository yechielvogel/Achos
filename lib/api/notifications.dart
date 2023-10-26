import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class Notifications extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Notifications(
      {required Key key, required this.flutterLocalNotificationsPlugin})
      : super(key: key);

  Future<void> scheduleDailyNotifications() async {
    final notifications = [
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // Add more NotificationDetails as needed
    ];

    for (int i = 0; i < notifications.length; i++) {
      // Calculate the scheduled time for 10 AM local time
      var scheduledTime = _nextInstanceOfTenAM().add(Duration(days: i));

      await flutterLocalNotificationsPlugin.zonedSchedule(
        i, // Notification ID
        'Daily Notification',
        'Your notification content here',
        scheduledTime,
        notifications[i],
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 16, 00, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
