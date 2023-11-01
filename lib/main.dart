import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  
    globals.hebrew_focused_month =
        globals.hebrew_focused_day.replaceAll(RegExp(r'[0-9\s]+'), '');
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
        // StreamProvider<List<AddHachlataHomeNew>?>.value(
        //   value: DatabaseService(Uid: 'test')
        //       .getSubCollectionStream('Yechiel Vogel', 'Cheshvan'),
        //   catchError: (context, error) {
        //     print("Error in stream: $error");
        //     return null;
        //   },
        //   initialData: null,
        // ),
      ],
      child: const MaterialApp(
        home: Wrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
