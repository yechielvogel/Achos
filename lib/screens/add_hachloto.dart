import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tzivos_hashem_milwaukee/widgets/pop_up_name_hachloto.dart';

import '../shared/globals.dart';
import '../widgets/hachlata_tile_widget.dart';
import '../widgets/pop_up_name_hachloto_category.dart';

class AddHachloto extends StatefulWidget {
  const AddHachloto({super.key});

  @override
  State<AddHachloto> createState() => AddHachlotoState();
}

class AddHachlotoState extends State<AddHachloto> {
  // Future<void> addHachlataTile() async {
  //   AddHachlataWidgetList.add(HachlataTileWidget());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: lightPink,
        ),
        elevation: 0.0,
        backgroundColor: bage,
        title: Text(
          "Hachloto's",
          style: TextStyle(color: lightPink),
        ),
      ),
      backgroundColor: bage,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: AddHachlataWidgetList.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 1,
                childAspectRatio: 2.5,
              ),
              // physics: NeverScrollableScrollPhysics(), // Disable grid scroll
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 0),
                  child: AddHachlataWidgetList[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
