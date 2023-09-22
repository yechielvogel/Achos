import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;

import '../screens/stats_admin_individual.dart';

class StatsAdminIndivisualName extends StatefulWidget {
  final tileName;
  const StatsAdminIndivisualName({super.key, required this.tileName});

  @override
  State<StatsAdminIndivisualName> createState() =>
      _StatsAdminIndivisualNameState();
}

class _StatsAdminIndivisualNameState extends State<StatsAdminIndivisualName> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => StatsAdminIndividual()));
        globals.current_namesofuser = widget.tileName;
        print(globals.current_namesofuser);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: globals.lightGreen,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              height: 59,
              // width: 195,
              child: Center(
                child: Text(
                  widget.tileName,
                  style: TextStyle(
                      color: globals.bage,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
