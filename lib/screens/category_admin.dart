import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/screens/stats_admin.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart';
import 'package:tzivos_hashem_milwaukee/services/database.dart';
import '../models/category.dart';
import '../widgets/hachlata_category_widget_admin.dart.dart';
import '../widgets/pop_up_name_hachloto_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MySettingsAdmin extends StatefulWidget {
  const MySettingsAdmin({super.key});

  @override
  State<MySettingsAdmin> createState() => MySettingsAdminState();
}

class MySettingsAdminState extends State<MySettingsAdmin> {
  Future<void> addHachlataCategoryTile() async {
    HachlataCategoryWidgetList.add(HachlataCategoryTileWidgetAdmin(
      categoryName: '',
    ));
  }

  @override
  Widget build(BuildContext context) {
    final catagory = Provider.of<List<Category?>?>(context);
    // print(catagory);
    catagory?.forEach((catagory) {
      print(catagory!.name);
    });

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                CupertinoIcons.chart_bar,
              ),
              color: lightPink,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => StatsAdmin()));
              })
        ],
        iconTheme: IconThemeData(
          color: lightPink,
        ),
        title: Text(
          "Category's",
          style: TextStyle(color: lightPink),
        ),
        elevation: 0.0,
        backgroundColor: bage,
      ),
      body: Container(
          color: bage,
          child: ListView.builder(
              itemCount: catagory?.length ?? 0, // Use the number of categories
              itemBuilder: (context, index) {
                if (catagory != null && catagory.length > index) {
                  final categoryName =
                      catagory[index]!.name ?? ''; // Get the category name
                  return HachlataCategoryTileWidgetAdmin(
                      categoryName: categoryName); // Pass the name
                }
                // Create a tile widget for each category's name
                // return HachlataCategoryTileWidget();
              })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: lightPink,
        foregroundColor: bage,
        child: const Icon(CupertinoIcons.add),
        onPressed: () async {
          HapticFeedback.heavyImpact();

          await showDialog(
            context: context,
            builder: (BuildContext context) {
              // Define the content of your dialog here
              return PopUpChooseName();
            },
          );
          // setState(() {
          //   // fix doesnt update straight away
          //   // addHachlataCategoryTile();
          // });
        },
      ),
    );
  }
}
