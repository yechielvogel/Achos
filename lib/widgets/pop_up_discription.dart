import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;
import '../models/add_hachlata.dart';
import '../screens/category_admin.dart';
import '../services/database.dart';
import '../shared/globals.dart';
import 'hachlata_tile_widget_add_admin.dart.dart';

class PopUpDiscription extends StatefulWidget {
  final String hachlataName;
  const PopUpDiscription({Key? key, required this.hachlataName})
      : super(key: key);

  @override
  State<PopUpDiscription> createState() => PopUpDiscriptionState();
}

class PopUpDiscriptionState extends State<PopUpDiscription> {
  @override
  Widget build(BuildContext context) {
    String discription = '';
    final hachlatacatagory = Provider.of<List<AddHachlata?>?>(context);

    // Check if hachlatacatagory is not null
    if (hachlatacatagory != null) {
      for (final item in hachlatacatagory) {
        if (item?.name == widget.hachlataName) {
          discription = item?.discription ?? '';
          break; // Stop searching once a match is found
        }
      }
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Set the border radius here
      ),
      backgroundColor: globals.bage,
      title: Center(
        child: Text(
          'Description',
          style: TextStyle(color: globals.newpink),
        ),
      ),
      content: Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            discription,
            style: TextStyle(color: globals.bage, fontSize: 15),
          ),
        ),
        decoration: BoxDecoration(
          color: lightGreen,
          borderRadius: const BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
