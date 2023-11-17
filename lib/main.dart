import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:tzivos_hashem_milwaukee/models/add_hachlata.dart';
import 'package:tzivos_hashem_milwaukee/models/add_hachlata_home.dart';
import 'package:tzivos_hashem_milwaukee/models/add_hachlata_home_new.dart';
import 'package:tzivos_hashem_milwaukee/screens/home/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tzivos_hashem_milwaukee/services/auth.dart';
import 'package:tzivos_hashem_milwaukee/services/database.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart';
import 'package:tzivos_hashem_milwaukee/shared/waiting.dart';
import 'api/firebase_api.dart';
import 'services/notifications.dart';
import 'models/admins.dart';
import 'models/category.dart';
import 'models/change_settings_switch.dart';
import 'models/ueser.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/ueser.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  await initializeDateFormatting();
  tz.setLocalLocation(tz.getLocation('America/New_York'));
  final notificationsService = NotificationService();
  await notificationsService.initialize();
  await notificationsService.scheduleNotification(
    title: 'Achos',
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String hebrew_focused_day = JewishDate().toString();
    globals.hebrew_focused_month =
        hebrew_focused_day.replaceAll(RegExp(r'[0-9\s]+'), '');
    // if (user != null && user.uesname != null) {
    //   globals.current_user = user.uesname!;
    // } else {
    //   // Handle the case where user or uesname is null
    // }
    Waiting();
    return MultiProvider(
      providers: [
        StreamProvider<Ueser?>.value(
          value: AuthService().user,
          initialData: null,
        ),
        StreamProvider<List<Category?>?>.value(
          value: DatabaseService(Uid: 'test').catagory,
          initialData: null,
        ),
        StreamProvider<List<AddHachlata?>?>.value(
          value: DatabaseService(Uid: 'test').hachlatacategory,
          initialData: null,
        ),
        StreamProvider<List<AddHachlataHome?>?>.value(
          value: DatabaseService(Uid: 'test').hachlatahome,
          initialData: null,
        ),
        StreamProvider<List<Admins?>?>.value(
          value: DatabaseService(Uid: 'test').admin,
          catchError: (context, error) {
            print("Error in stream: $error");
            // You can return a default value or handle the error in some way
            return null;
          },
          initialData: null,
        ),
        StreamProvider<List<ChangeSettingsSwitch?>?>.value(
          value: DatabaseService(Uid: 'test').changesettingsswitch,
          catchError: (context, error) {
            print("Error in stream: $error");
            // You can return a default value or handle the error in some way
            return null;
          },
          initialData: null,
        ),

      ],
      child: const MaterialApp(
        home: Wrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
// rules_version = '2';

// service cloud.firestore {
//   match /databases/{database}/documents {

//     // This rule allows anyone with your Firestore database reference to view, edit,
//     // and delete all data in your Firestore database. It is useful for getting
//     // started, but it is configured to expire after 30 days because it
//     // leaves your app open to attackers. At that time, all client
//     // requests to your Firestore database will be denied.
//     //
//     // Make sure to write security rules for your app before that time, or else
//     // all client requests to your Firestore database will be denied until you Update
//     // your rules
//     match /{document=**} {
//       allow read, write: if request.time < timestamp.date(2024, 10, 7);
//     }
//   }
// }
//
//
//
// {
//   "rules": {
//     ".read": "now < 1700542800000",  // 2025-12-22
//     ".write": "now < 1700542800000",  // 2025-12-22
//   }
// }