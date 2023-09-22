import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;

import '../models/ueser.dart';
import '../services/database.dart';
import '../shared/globals.dart';
import 'hachlata_category_widget.dart';

class StatsHachlataTileWidget extends StatefulWidget {
  final String hachlataName;
  final isclicked;
  StatsHachlataTileWidget(
      {super.key, required this.hachlataName, required this.isclicked});

  @override
  StatsHachlataTileWidgetState createState() => StatsHachlataTileWidgetState();
}

class StatsHachlataTileWidgetState extends State<StatsHachlataTileWidget> {
  // bool isClicked = false;

  void toggleColor() {
    setState(() {
      isClicked = !isClicked;
      HapticFeedback.heavyImpact();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.isclicked,
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            height: 59,
            // width: 195,
            child: Center(
              child: Text(
                widget.hachlataName,
                style: TextStyle(
                    color: bage, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}