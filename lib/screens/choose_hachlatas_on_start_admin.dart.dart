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

class ChooseHachlataOnStartAdmin extends StatefulWidget {
  const ChooseHachlataOnStartAdmin({super.key});

  @override
  State<ChooseHachlataOnStartAdmin> createState() =>
      _ChooseHachlataOnStartAdminState();
}

List<AddHachlata?> hachlataItemsForCurrentCategory = [];

class _ChooseHachlataOnStartAdminState
    extends State<ChooseHachlataOnStartAdmin> {
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
    if (globals.current_category_choose_int >= 0 &&
        globals.current_category_choose_int < categories!.length) {
      globals.current_category_choose =
          categories[globals.current_category_choose_int]?.name ?? '';
    } else {
      print('returning home');
      return HomeAdmin();
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
            color: globals.newpink,
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
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 12),
                        // child: Slidable(
                        //   endActionPane:
                        //       ActionPane(motion: StretchMotion(), children: [
                        //     SlidableAction(
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(20.0)),
                        //       backgroundColor: globals.lightPink,
                        //       foregroundColor: globals.bage,
                        //       icon: CupertinoIcons.delete,
                        //       onPressed: (context) => Container(),
                        //       spacing: 0,
                        //     )
                        //   ]),
                        child: Container(
                          child: AddHachlataTileWidgetAdmin(
                            hachlataName: hachlataName,
                            isclicked: globals.lightGreen,
                            rebuildCallback: rebuildOtherFile,
                          ),
                        ),
                        // ),
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
