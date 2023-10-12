import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/add_hachloto_admin.dart';
import '../screens/category_admin.dart';
import '../services/database.dart';
import '../shared/globals.dart' as globals;

class PopUpNameHachloto extends StatefulWidget {
  const PopUpNameHachloto({super.key});

  @override
  State<PopUpNameHachloto> createState() => PopUpNameHachlotoState();
}

class PopUpNameHachlotoState extends State<PopUpNameHachloto> {
  MySettingsAdminState hachlataCategoryTileWidget = MySettingsAdminState();
  AddHachlotoAdminState hachlataTileWidget = AddHachlotoAdminState();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nameController2 = TextEditingController();

  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> updateVariable() async {
    final enteredName = _nameController2.text;
    final description = _nameController.text;
    setState(() {
      globals.hachlata_name_for_widget = enteredName;
      globals.hachlata_description_for_widget = description;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Set the border radius here
      ),
      backgroundColor: globals.bage,
      title: Center(
        child: Text(
          'New Hachlata',
          style: TextStyle(color: globals.newpink),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              cursorColor: globals.doneHachlata,
              decoration: InputDecoration(
                hintText: 'Name',
                hintStyle: TextStyle(color: globals.bage),
                fillColor: globals.lightGreen,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        BorderSide(color: globals.lightGreen, width: 3.0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        BorderSide(color: globals.lightGreen, width: 3.0)),
              ),
              controller: _nameController2,
              style: TextStyle(color: globals.bage),
            ),
          ),
          TextFormField(
            cursorColor: globals.doneHachlata,
            decoration: InputDecoration(
              hintText: 'Description',
              hintStyle: TextStyle(color: globals.bage),
              fillColor: globals.lightGreen,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(color: globals.lightGreen, width: 3.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(color: globals.lightGreen, width: 3.0)),
            ),
            controller: _nameController,
            style: TextStyle(color: globals.bage),
          ),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: globals.newpink,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0), // Set the border radius here
              ),
            ),
            onPressed: () async {
              HapticFeedback.heavyImpact();
              Navigator.of(context).pop();
              await updateVariable();
              await DatabaseService(Uid: 'test').updateHachlataCategory(
                  _nameController2.text,
                  globals.current_category,
                  _nameController.text,
                  false); // await hachlataCategoryTileWidget.addHachlataCategoryTile();

              // hachlataTileWidget.addHachlataTile();
              // change this to hachlataTileWidgetAdd.addHachlataTileAdd();
              ;

              // Close the dialog
              // Navigator.of(context).pop();
            },
            child: Text(
              'Save',
              style: TextStyle(color: globals.bage),
            ),
          ),
        ),
      ],
    );
  }
}
