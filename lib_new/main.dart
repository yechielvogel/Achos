// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tzivos_hashem_milwaukee/services/notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'services/wrapper.dart';
import 'shared/helpers/error_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting();
  // this should be fixed
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/New_York'));
  bool scheduleNotification = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  scheduleNotification = prefs.getBool('scheduleNotificationNew') ?? false;
  final notificationsService = NotificationService();
  await notificationsService.initialize();
  // this needs to be fixed
  if (!scheduleNotification) {
    print('firsttime openening app');
    await notificationsService.scheduleNotification(
      title: 'Achos',
    );
    prefs.setBool('scheduleNotificationNewTest', true);
  }

  try {
    await Supabase.initialize(
        url: 'https://bnulkbhekxssnnjbwcnn.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJudWxrYmhla3hzc25uamJ3Y25uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkzMDI0NDMsImV4cCI6MjA3NDg3ODQ0M30.B92iCvOp3P-p07NMED9io9zJKNIFbOY7aPhpT9k4CsA');

    // await checkIfFirstRun();
    // await appOpenedLogs();
  } catch (e) {
    print("Error ${e}");
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          Wrapper(),
          const ErrorSnackbar(),
        ],
      ),
    );
  }
}
