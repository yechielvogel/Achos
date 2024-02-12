import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;
import '../models/add_hachlata.dart';
import '../models/add_hachlata_home.dart';
import '../models/category.dart';
import '../models/ueser.dart';
import '../widgets/hachlata_tile_widget_add_admin.dart.dart';
import 'home/admin_home.dart';
import 'home/home.dart';

class ChooseHachlataOnStart extends StatefulWidget {
  const ChooseHachlataOnStart({
    Key? key,
  }) : super(key: key);

  @override
  State<ChooseHachlataOnStart> createState() => _ChooseHachlataOnStartState();
}

List<AddHachlata?> hachlataItemsForCurrentCategory = [];

class _ChooseHachlataOnStartState extends State<ChooseHachlataOnStart> {
  @override
  Widget build(BuildContext context) {
    void rebuildOtherFile() {
      setState(() {
        // globals.current_category_choose_int += 1;
      }); // Trigger a rebuild in the other file
    }

    List<AddHachlata?> hachlataItemsForCurrentCategory = [];

    final user = Provider.of<Ueser?>(context);

    final hachlatacatagory = Provider.of<List<AddHachlata?>?>(context);
    final hachlatahome = Provider.of<List<AddHachlataHome?>?>(context);
    final categories = Provider.of<List<Category?>?>(context);
    print('check if it went through the category list${categories!.length}');
    print('globals.currentcategoryint ${globals.current_category_choose_int}');
    // widget.rebuildCallback();
    if (globals.current_category_choose_int >= 0 &&
        globals.current_category_choose_int < categories!.length) {
      globals.current_category_choose =
          categories[globals.current_category_choose_int]?.name ?? '';
    } else {
      print('returning home');
      print(user!.uesname);
      print(globals.tempuesname);
      // widget.rebuildCallback();
      return Home();
    }

// Filter items for the current category
    hachlataItemsForCurrentCategory = hachlatacatagory
            ?.where((item) =>
                item != null &&
                item.category == globals.current_category_choose)
            .toList() ??
        [];
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: globals.newpink,
        ),
        elevation: 0.0,
        backgroundColor: globals.bage,
        title: Text(
          "Choose ${globals.current_category_choose} החלטות",
          style: TextStyle(
            color: globals.lightPink,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: globals.bage,
      body: Column(
        children: [
          Expanded(
              child: GridView.builder(
                  itemCount: hachlataItemsForCurrentCategory.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1,
                    childAspectRatio: 2.5,
                  ), // Use the number of categories
                  itemBuilder: (context, index) {
                    if (hachlataItemsForCurrentCategory != null &&
                        hachlataItemsForCurrentCategory.length > index) {
                      final hachlataName =
                          hachlataItemsForCurrentCategory[index]!.name ?? '';
                      return Column(
                        children: [
                          AddHachlataTileWidgetAdmin(
                            hachlataName: hachlataName,
                            isclicked: globals.lightGreen,
                            rebuildCallback: rebuildOtherFile,
                          ),
                        ],
                      );
                      // Pass the name
                    }
                    // Create a tile widget for each category's name
                    return Container();
                    // return HachlataTileWidget();
                  })),
        ],
      ),
    );
  }
}




//  await DatabaseService(Uid: 'test').updateHachlataHome(
//               displayusernameinaccount.toString(),
//               widget.hachlataName,
//               'N/A',
//               'N/A',
//               'Color(0xFFCBBD7F);');

          // "Choose ${globals.current_category_choose} החלטות",
