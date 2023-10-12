import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;
import 'package:tzivos_hashem_milwaukee/screens/add_hachloto_admin.dart';
import 'package:tzivos_hashem_milwaukee/widgets/pop_up_discription.dart';
import '../models/category.dart';
import '../models/ueser.dart';
import '../screens/home/admin_home.dart';
import '../services/auth.dart';
import '../services/database.dart';
import '../shared/globals.dart';
import 'hachlata_category_widget_admin.dart.dart';

class AddHachlataTileWidget extends StatefulWidget {
  final String hachlataName;
  final Color isclicked;

  const AddHachlataTileWidget(
      {super.key, required this.hachlataName, required this.isclicked});

  @override
  _AddHachlataTileWidgetState createState() => _AddHachlataTileWidgetState();
}

class _AddHachlataTileWidgetState extends State<AddHachlataTileWidget> {
  // bool isClicked = false;

  // void toggleColor() {
  //   setState(() {
  //     isClicked = !isClicked;
  //     HapticFeedback.heavyImpact();
  //   });
  // }

  // Future<void> HachlataTile() async {
  //   HachlataWidgetList.add(HachlataTileWidget(hachlataName: '',));
  // }
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Ueser?>(context);
    Color? tileColor = isClicked ? doneHachlata : lightGreen;
    final categories = Provider.of<List<Category?>?>(context);

    return GestureDetector(
      onTap: () async {
        HapticFeedback.heavyImpact();
        globals.hachlata_home_doc_name = (user!.uesname! + widget.hachlataName);
        setState(() {
          globals.current_category_choose_int += 1;

          if (globals.current_category_choose_int < categories!.length) {
            globals.current_category_choose =
                categories[globals.current_category_choose_int]?.name ?? '';
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeAdmin(),
              ),
            );
          }
        });
        if (widget.isclicked == Color(0xFFCBBD7F)) {
          await DatabaseService(Uid: 'test').updateHachlataHome(
              user!.uesname.toString(),
              widget.hachlataName,
              'N/A',
              'N/A',
              'Color(0xFFCBBD7F);');
        } else
          await DatabaseService(Uid: 'test').delteHachlataHome();
      },
      onLongPress: () async {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              HapticFeedback.heavyImpact();
              return PopUpDiscription(
                hachlataName: widget.hachlataName,
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: widget.isclicked,
              ),
              height: 58,
              child: Center(
                child: Text(
                  widget.hachlataName,
                  style: TextStyle(
                      color: bage, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
