import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workmanager/workmanager.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  // create a instant of messaging
  final _firebaseMessaging = FirebaseMessaging.instance;
  // initialize
  Future<void> initNotifications() async {
    // request permission from user
    await _firebaseMessaging.requestPermission();
    // get firebase messaging token for this device
    final fCMToken = await _firebaseMessaging.getToken();
    // print the token
    print('token $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    // return Container();
  }
  Future<void> updateTokenInFirebase() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userUid = user.uid;
    final fCMToken = await FirebaseMessaging.instance.getToken();

    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('users').doc(userUid);

    await userRef.set({'fcmToken': fCMToken}, SetOptions(merge: true));
  }
}

}


