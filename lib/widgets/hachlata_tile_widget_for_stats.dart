import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/models/add_hachlata_home_new.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;
import 'package:tzivos_hashem_milwaukee/widgets/pop_up_discription.dart';

import '../models/add_hachlata_home.dart';
import '../models/ueser.dart';
import '../services/database.dart';
import '../shared/globals.dart';
import 'hachlata_category_widget_admin.dart.dart';

class HachlataTileWidgetForStats extends StatefulWidget {
  final String hachlataName;
  final isclicked;
  HachlataTileWidgetForStats({
    super.key,
    required this.hachlataName,
    required this.isclicked,
  });

  @override
  _HachlataTileWidgetForStatsState createState() =>
      _HachlataTileWidgetForStatsState();
}

class _HachlataTileWidgetForStatsState
    extends State<HachlataTileWidgetForStats> {
  // bool isClicked = false;

  void toggleColor() {
    setState(() {
      isClicked = !isClicked;
      HapticFeedback.heavyImpact();
    });
  }

  bool isDateInCurrentWeek() {
    // Parse the date string into a DateTime object
    DateTime date = globals.today;
    DateTime now = DateTime.now();
    // Get the current date and time
    DateTime todaysdate = DateTime(now.year, now.month, now.day);
    DateTime sevenDaysAgo = now.subtract(Duration(days: 7));
    // Check if the dates are in the same week
    if (date.isAfter(sevenDaysAgo) &&
        date.isBefore(todaysdate) &&
        !date.isAfter(todaysdate)) {
      // Check if the date is within 7 days ago
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    DateTime todaysdatefull = DateTime.now();
    DateTime todaysdate =
        DateTime(todaysdatefull.year, todaysdatefull.month, todaysdatefull.day);
    globals.hebrew_focused_month =
        globals.hebrew_focused_day.replaceAll(RegExp(r'[0-9\s]+'), '');
    JewishDate jewishDate = JewishDate();
    HebrewDateFormatter hebrewDateFormatter = HebrewDateFormatter();
    String hebrewDate = hebrewDateFormatter.format(jewishDate);
    DateTime today = DateTime.now().toLocal();
    final dateOnly = DateTime(today.year, today.month, today.day);
    String dateOnlytostring = dateOnly.toString();
    // DateTime dateOnly = DateTime(today.year, today.month, today.day);
    final user = Provider.of<Ueser?>(context);
    // Color? tileColor = widget.isclicked ? darkGreen : lightGreen;
    final hachlataHome = Provider.of<List<AddHachlataHome?>?>(context);

    Future<void> updateHachlataForUser(
        List<AddHachlataHome?>? hachlataHome, String username) async {
      if (hachlataHome != null) {
        hachlataHome.forEach((hachlata) {
          if (hachlata != null &&
              hachlata.uid == username &&
              hachlata.date != 'N/A') {
            String hachlatadocname =
                hachlata.uid + hachlata.name + hachlata.date;

            DatabaseService(Uid: 'test').updateDoneHachlataNew(
              hachlata.uid.toString(),
              hachlata.name,
              hachlata.date,
              hachlata.hebrewdate,
              hachlata.color,
              username,
              'Cheshvan',
              hachlatadocname,
            );
            DatabaseService(Uid: 'test')
                .delteHachlataHomeForUpdate(hachlatadocname);
          }
        });
      }
    }

    if (user?.uesname == null) {
      displayusernameinaccount = tempuesname;
    } else
      displayusernameinaccount = user!.uesname!;
    print('displayusername ${displayusernameinaccount}');
    print(globals.hebrew_focused_month);
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.isclicked,
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            height: 58,
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
    );
  }
}
