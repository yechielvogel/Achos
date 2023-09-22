import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({super.key});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightGreen,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
    );
  }
}
