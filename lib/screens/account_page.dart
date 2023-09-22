import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
  Widget build(BuildContext context) {
    final user = Provider.of<Ueser?>(context);

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
              'Welcome ${user?.uesname}',
              style: TextStyle(
                color: lightPink,
                fontSize: 20,
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30, right: 30, left: 30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: lightPink,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Set the border radius here
                ),
              ),
              onPressed: () async {
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
