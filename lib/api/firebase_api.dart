import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  // create a instant of messaging
  final _firebaseMessaging = FirebaseMessaging.instance;
  // initialize
  Future<Container> initNotifications() async {
    // request permission from user
    await _firebaseMessaging.requestPermission();
    // get firebase messaging token for this device
    final fCMToken = await _firebaseMessaging.getToken();
    // print the token
    print('token $fCMToken');
    return Container();
  }
  // handle recieved messages
}
