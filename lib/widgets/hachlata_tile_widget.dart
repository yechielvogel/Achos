import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;

import '../models/ueser.dart';
import '../services/database.dart';
import '../shared/globals.dart';
import 'hachlata_category_widget_admin.dart.dart';

class HachlataTileWidget extends StatefulWidget {
  final String hachlataName;
  final isclicked;
  HachlataTileWidget(
      {super.key, required this.hachlataName, required this.isclicked});

  @override
  _HachlataTileWidgetState createState() => _HachlataTileWidgetState();
}

class _HachlataTileWidgetState extends State<HachlataTileWidget> {
  // bool isClicked = false;

  void toggleColor() {
    setState(() {
      isClicked = !isClicked;
      HapticFeedback.heavyImpact();
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now().toLocal();
    final dateOnly = DateTime(today.year, today.month, today.day);

    // DateTime dateOnly = DateTime(today.year, today.month, today.day);
    final user = Provider.of<Ueser?>(context);
    // Color? tileColor = widget.isclicked ? darkGreen : lightGreen;

    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        toggleColor();
        globals.done_hachlata_doc_name =
            (user!.uesname! + widget.hachlataName + globals.focused_day);
        // dateOnly.toString()
        if (widget.isclicked == Color(0xFFCBBD7F)) {
          DatabaseService(Uid: 'test').updateDoneHachlata(
              user!.uesname.toString(),
              widget.hachlataName,
              globals.focused_day,
              'Color(0xFF063C3C);');
        } else
          DatabaseService(Uid: 'test').delteDoneHachlata();
      },
      child: Padding(
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
            // SizedBox(
            //   height: 15,
            // ),
          ],
        ),
      ),
    );
  }
}
