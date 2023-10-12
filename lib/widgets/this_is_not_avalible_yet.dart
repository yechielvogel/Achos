import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;

class ThisIsNotAvailableYet extends StatefulWidget {
  const ThisIsNotAvailableYet({super.key});

  @override
  State<ThisIsNotAvailableYet> createState() => _ThisIsNotAvailableYetState();
}

class _ThisIsNotAvailableYetState extends State<ThisIsNotAvailableYet> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Set the border radius here
      ),
      backgroundColor: globals.bage,
      title: Center(
        child: Text(
          'This is not available yet',
          style: TextStyle(color: globals.newpink),
        ),
      ),
    );
  }
}
