import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/services/notifications.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart';

import '../models/ueser.dart';
import '../services/auth.dart';

class AccountPage extends StatefulWidget {
  @override
  AccountPageState createState() => AccountPageState();
}

final AuthService _auth = AuthService();

class AccountPageState extends State<AccountPage> {
  @override
  late final Notifications service;

  void initState() {
    service = Notifications();
    service.initialize();
    super.initState();
  }

  Widget build(BuildContext context) {
    final user = Provider.of<Ueser?>(context);
    if (user?.uesname == null) {
      displayusernameinaccount = tempuesname;
    } else
      displayusernameinaccount = user!.uesname!;
    return Container(
      decoration: BoxDecoration(
          color: bage,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 30, bottom: 40, right: 30, left: 30),
            child: Container(
                child: Text(
              'Welcome ${displayusernameinaccount}',
              style: TextStyle(
                color: newpink,
                fontSize: 20,
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30, right: 30, left: 30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: newpink,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Set the border radius here
                ),
              ),
              onPressed: () async {
                // await service.ScheduledNotification(
                //     id: 0,
                //     title: 'GrowWithTheFlow',
                //     body: 'Remember to do your Hachlatas',
                //     seconds: 4);
                HapticFeedback.heavyImpact();
                _auth.signOut();

                Navigator.of(context).pop();
              },
              child: Text(
                'Sign Out',
                style: TextStyle(color: bage),
              ),
            ),
          )
        ],
      ),
    );
  }
}
