import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tzivos_hashem_milwaukee/services/database.dart';
import '../screens/category_admin.dart';
import '../shared/globals.dart' as globals;

class PopUpChooseName extends StatefulWidget {
  const PopUpChooseName({super.key});

  @override
  State<PopUpChooseName> createState() => PopUpChooseNameState();
}

class PopUpChooseNameState extends State<PopUpChooseName> {
  MySettingsAdminState hachlataCategoryTileWidget = MySettingsAdminState();
  final TextEditingController _nameController = TextEditingController();
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> updateVariable() async {
    final enteredName = _nameController.text;

    setState(() {
      globals.hachlata_name_for_category_widget = enteredName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: globals.bage,
      title: Center(
        child: Text(
          'New category',
          style: TextStyle(color: globals.newpink),
        ),
        
      ),
      content: TextFormField(
        cursorColor: globals.doneHachlata,
        decoration: InputDecoration(
          hintText: 'Name',
          hintStyle: TextStyle(color: globals.bage),
          fillColor: globals.lightGreen,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: globals.lightGreen, width: 3.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: globals.lightGreen, width: 3.0)),
        ),
        controller: _nameController,
        style: TextStyle(color: globals.bage),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: globals.newpink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () async {
              HapticFeedback.heavyImpact();
              Navigator.of(context).pop();
              await updateVariable();
              await DatabaseService(Uid: 'test')
                  .updateCategory(globals.hachlata_name_for_category_widget);
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
