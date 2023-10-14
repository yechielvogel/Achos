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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: newpink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Set the border radius here
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
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: newpink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Set the border radius here
                    ),
                  ),
                  onPressed: () async {
                    HapticFeedback.heavyImpact();
                    Navigator.of(context).pop();
                    ;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: bage,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          title: const Text(
                            'Delete your Account?',
                            style: TextStyle(color: Color(0xFFC16C9E)),
                          ),
                          content: const Text(
                            '''If you select Delete we will delete your account on our server.

Your app data will also be deleted and you won't be able to retrieve it.

Since this is a security-sensitive operation, you eventually are asked to login before your account can be deleted.''',
                            style: TextStyle(color: Color(0xFFC16C9E)),
                          ),
                          actions: [
                            Container(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: newpink,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                onPressed: () async {
                                  HapticFeedback.heavyImpact();
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: bage),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: newpink,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () async {
                                HapticFeedback.heavyImpact();
                                _auth.deleteUserAccount();
                                Navigator.of(context).pop();
                                // Call the delete account function
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(color: bage),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    // Navigator.of(context).pop();
                  },
                  child: Text(
                    'Delete Account',
                    style: TextStyle(color: bage),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
