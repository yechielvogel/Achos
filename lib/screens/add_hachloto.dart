import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/models/add_hachlata.dart';
import 'package:tzivos_hashem_milwaukee/widgets/pop_up_name_hachloto.dart';
import '../models/add_hachlata_home.dart';
import '../models/ueser.dart';
import '../shared/globals.dart' as globals;
import '../widgets/hachlata_tile_widget_add.dart';
import '../widgets/hachlata_tile_widget_add_admin.dart.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AddHachloto extends StatefulWidget {
  const AddHachloto({super.key});

  @override
  State<AddHachloto> createState() => AddHachlotoState();
}

class AddHachlotoState extends State<AddHachloto> {


  @override
  Widget build(BuildContext context) {

DocumentReference uerIdRef = FirebaseFirestore.instance.collection('addHachlataHomeNew').doc(globals.displayusernameinaccount);

// Reference to a subcollection within the document. change to hebrew focused day month and year 
CollectionReference selectedhebrewmonthRef = uerIdRef.collection(globals.hebrew_focused_day);

// Reference to a specific document in the subcolection 
DocumentReference doneHachlataRef = FirebaseFirestore.instance.collection('addHachlataHomeNew').doc(globals.displayusernameinaccount);



    List<AddHachlata?> hachlataItemsForCurrentCategory = [];

    final user = Provider.of<Ueser?>(context);

    final hachlatacatagory = Provider.of<List<AddHachlata?>?>(context);
    final hachlatahome = Provider.of<List<AddHachlataHome?>?>(context);

// Filter items for the current category
    hachlataItemsForCurrentCategory = hachlatacatagory
            ?.where((item) =>
                item != null && item.category == globals.current_category)
            .toList() ??
        [];

// Set tile colors based on the condition
    List<Color> tileColors = List<Color>.generate(
      hachlataItemsForCurrentCategory.length,
      (index) {
        final categoryItem = hachlataItemsForCurrentCategory[index];
        if (categoryItem != null && user?.uesname != null) {
          final homeItem = hachlatahome!.firstWhere(
            (item) =>
                item != null &&
                item.name ==
                    categoryItem?.name && // Check for null categoryItem
                user != null &&
                user.uesname! + categoryItem.name == item.uid + item.name &&
                item.date == 'N/A',
            orElse: () => AddHachlataHome(
                name: '',
                color: '',
                date: '',
                hebrewdate: '',
                uid: ''), // Return an AddHachlataHome object instead of null
          );

          if (homeItem ==
              AddHachlataHome(
                  name: '', color: '', date: '', hebrewdate: '', uid: '')) {
            return Color(0xFFCBBD7F); // Light green
          }

          return Color(0xFFC16C9E); // Dark green
        }
        return Color(0xFFCBBD7F);
      },
    );

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: globals.newpink,
        ),
        elevation: 0.0,
        backgroundColor: globals.bage,
        title: Text(
          "Hachlata's",
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
                      print(tileColors);
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
                          child: AddHachlataTileWidget(
                            hachlataName: hachlataName,
                            isclicked: tileColors[index],
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
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: globals.lightPink,
      //   foregroundColor: globals.bage,
      //   child: const Icon(CupertinoIcons.add),
      //   onPressed: () async {
      //     await showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         // Define the content of your dialog here
      //         return PopUpNameHachloto();
      //       },
      //     );
      //     // setState(() {
      //     //   // fix doesnt update straight away
      //     //   // addHachlataCategoryTile();
      //     // });
      //   },
      // ),
    );
  }
}


// // Reference to a specific document in the 'testMonthlyCollection' collection
// DocumentReference uerIdRef = FirebaseFirestore.instance.collection('addHachlataHomeNew').doc(globals.displayusernameinaccount);

// // Reference to a subcollection within the document. change to hebrew focused day month and year 
// CollectionReference selectedhebrewmonthRef = uerIdRef.collection(globals.hebrew_focused_day);

// // Reference to a specific document in the subcolection 
// DocumentReference doneHachlataRef = FirebaseFirestore.instance.collection('addHachlataHomeNew').doc(globals.displayusernameinaccount);



// // C-addHachlataHomeNew - D-userid S-C - globals.selectedhebrewmonth - D-hachlata


