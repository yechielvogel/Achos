import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;

class SettingsOffWidget extends StatefulWidget {
  const SettingsOffWidget({super.key});

  @override
  State<SettingsOffWidget> createState() => _SettingsOffWidgetState();
}

class _SettingsOffWidgetState extends State<SettingsOffWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Set the border radius here
      ),
      backgroundColor: globals.bage,
      title: Center(
        child: Text(
          'Settings have been turned off by the admins',
          style: TextStyle(color: globals.newpink),
        ),
      ),
    );
  }
}
