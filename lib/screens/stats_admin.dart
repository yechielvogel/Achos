import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;
import '../models/add_hachlata_home.dart';
import '../widgets/stats_admin_indivisual_name.dart';

class StatsAdmin extends StatefulWidget {
  const StatsAdmin({super.key});

  @override
  State<StatsAdmin> createState() => _StatsAdminState();
}

class _StatsAdminState extends State<StatsAdmin> {
  @override
  Widget build(BuildContext context) {
    List<AddHachlataHome?> hachlataItemsEveryone = [];

    final hachlatahome = Provider.of<List<AddHachlataHome?>?>(context);

 
if (hachlatahome != null) {
  Set<String> namesofusers = Set<String>();

  List<AddHachlataHome?> Items = [];

  for (AddHachlataHome? item in hachlatahome) {
    if (item != null && item.date != 'N/A' && !namesofusers.contains(item.uid)) {
      namesofusers.add(item.uid); 
      Items.add(item); 
    }
  }

  hachlataItemsEveryone = Items;
} else {
  hachlataItemsEveryone = []; 
}

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: globals.lightPink,
        ),
        title: Text(
          "Stats",
          style: TextStyle(color: globals.lightPink),
        ),
        elevation: 0.0,
        backgroundColor: globals.bage,
      ),
      body: Container(
          color: globals.bage,
          child: ListView.builder(
              itemCount: hachlataItemsEveryone?.length ??
                  0, // Use the number of categories
              itemBuilder: (context, index) {
                if (hachlataItemsEveryone != null &&
                    hachlataItemsEveryone.length > index) {
                  final tileName = hachlataItemsEveryone[index]!.uid ??
                      ''; // Get the category name
                  return StatsAdminIndivisualName(
                      tileName: tileName); // Pass the name
                }
                // Create a tile widget for each category's name
                // return HachlataCategoryTileWidget();
              })),
    );
  }
}



    // hachlataItemsEveryone = hachlatahome
    //         ?.where((item) => item != null && item.date != 'N/A')
    //         .toSet()
    //         .toList() ??
    //     [];