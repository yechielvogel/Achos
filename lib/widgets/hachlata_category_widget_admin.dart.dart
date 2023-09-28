import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;

import '../models/category.dart';
import '../screens/add_hachloto_admin.dart';
import '../shared/globals.dart';

class HachlataCategoryTileWidgetAdmin extends StatefulWidget {
  final String categoryName;

  const HachlataCategoryTileWidgetAdmin({super.key, required this.categoryName});

  @override
  HachlataCategoryTileWidgetAdminState createState() =>
      HachlataCategoryTileWidgetAdminState();
}

class HachlataCategoryTileWidgetAdminState
    extends State<HachlataCategoryTileWidgetAdmin> {
  bool isClicked = false;

  void toggleColor() {
    setState(() {
      isClicked = !isClicked;
      HapticFeedback.heavyImpact();
    });
  }

  @override
  Widget build(BuildContext context) {
    final catagory = Provider.of<List<Category?>?>(context);

    // Color? tileColor = isClicked ? darkGreen : lightGreen;

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddHachlotoAdmin()));
        setState(() {
          globals.current_category = widget.categoryName;
        });
        print(globals.current_category);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              height: 59,
              // width: 195,
              child: Center(
                child: Text(
                  widget.categoryName,
                  style: TextStyle(
                      color: bage, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // SizedBox(
            //   height: 15,
            // ),
          ],
        ),
      ),
    );
  }
}





// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:provider/provider.dart';
// import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;

// import '../models/category.dart';
// import '../screens/add_hachloto_admin.dart';
// import '../services/database.dart';
// import '../shared/globals.dart';

// class HachlataCategoryTileWidget extends StatefulWidget {
//   final String categoryName;

//   const HachlataCategoryTileWidget({super.key, required this.categoryName});

//   @override
//   HachlataCategoryTileWidgetState createState() =>
//       HachlataCategoryTileWidgetState();
// }

// class HachlataCategoryTileWidgetState
//     extends State<HachlataCategoryTileWidget> {
//   bool isClicked = false;

//   void toggleColor() {
//     setState(() {
//       isClicked = !isClicked;
//       HapticFeedback.heavyImpact();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final catagory = Provider.of<List<Category?>?>(context);

//     // Color? tileColor = isClicked ? darkGreen : lightGreen;

//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => AddHachlotoAdmin()));
//         setState(() {
//           globals.current_category = widget.categoryName;
//         });
//         print(globals.current_category);
//       },
//       child: Padding(
//         padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
//         child: Column(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: Dismissible(
//                 direction: DismissDirection.endToStart,
//                 key: Key(widget.categoryName),
//                 onDismissed: (direction) async {
//                   if (direction == DismissDirection.endToStart) {
//                     // globals.hachlata_name_for_widget = widget.categoryName;
//                     // await DatabaseService(Uid: 'test').delteHachlataCategory();
//                   }
//                 },
//                 background: Container(
//                   alignment: Alignment.centerRight,
//                   decoration: BoxDecoration(
//                     color: globals.lightPink,
//                     // borderRadius: const BorderRadius.all(
//                     //   Radius.circular(20.0),
//                     // ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.only(right: 20),
//                     child: Icon(
//                       Icons.delete,
//                       color: bage,
//                     ),
//                   ),
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: lightGreen,
//                     // borderRadius: const BorderRadius.all(
//                     //   Radius.circular(20.0),
//                     // ),
//                   ),
//                   height: 59,
//                   // width: 195,
//                   child: Center(
//                     child: Text(
//                       widget.categoryName,
//                       style: TextStyle(
//                           color: bage,
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             // SizedBox(
//             //   height: 15,
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
