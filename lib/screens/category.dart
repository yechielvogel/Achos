import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart';

import '../widgets/hachlata_category_widget.dart';
import '../widgets/pop_up_name_hachloto_category.dart';

class MySettings extends StatefulWidget {
  const MySettings({super.key});

  @override
  State<MySettings> createState() => MySettingsState();
}

class MySettingsState extends State<MySettings> {
  Future<void> addHachlataCategoryTile() async {
    HachlataCategoryWidgetList.add(HachlataCategoryTileWidget(
      categoryName: '',
    ));
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () async {
                setState(() {});
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
        child: ListView(children: HachlataCategoryWidgetList),
      ),
    );
  }
}
