import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart';

class EmptyListWidget extends StatefulWidget {
  const EmptyListWidget({super.key});

  @override
  State<EmptyListWidget> createState() => _EmptyListWidgetState();
}

class _EmptyListWidgetState extends State<EmptyListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: lightGreen,
          borderRadius: const BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        height: 30,
        // width: 195,
        child: Center(
          child: Text(
            'Press the settings button to add hachlatas',
            style: TextStyle(
              color: bage,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
