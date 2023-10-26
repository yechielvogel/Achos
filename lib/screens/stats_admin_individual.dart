import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tzivos_hashem_milwaukee/models/add_hachlata_home.dart';
import 'package:tzivos_hashem_milwaukee/screens/account_page.dart';
// import 'package:tzivos_hashem_milwaukee/services/auth.dart';
import 'package:tzivos_hashem_milwaukee/widgets/hachlata_tile_widget.dart';
import 'package:tzivos_hashem_milwaukee/screens/category_admin.dart';
// import '../../services/auth.dart';
import '../../shared/globals.dart' as globals;
import '../../models/ueser.dart';
import '../models/change_settings_switch.dart';
import '../widgets/calendar.dart';
import '../widgets/new_admin_stats.dart';
import '../widgets/new_user_stats.dart';
import '../widgets/stats_hachlata_tile_widget.dart';

// class StatsAdminIndividual extends StatefulWidget {
//   @override
//   StatsAdminIndividualState createState() => StatsAdminIndividualState();
// }

// class StatsAdminIndividualState extends State<StatsAdminIndividual> {
//   // final AuthService _auth = AuthService();

//   bool isPressed = false;
//   // bool isHachlataListEmpty() {
//   //   return HachlataWidgetList.isEmpty;
//   // }
//   // // List<Widget> HachlataWidgetList = [];

//   // void addHachlataTile() {
//   //   setState(() {
//   //     HachlataWidgetList.add(HachlataTileWidget());
//   //   });
//   // }

//   DateTime today = DateTime.now();
//   void _onDaySelected(DateTime day, DateTime focusedDay) {
//     setState(() {
//       today = day;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<AddHachlataHome?> hachlataItemsForHome = [];

//     final hachlataHome = Provider.of<List<AddHachlataHome?>?>(context);
//     final focusedDate = DateTime(today.year, today.month, today.day);
//     globals.focused_day = focusedDate.toString();
//     final user = Provider.of<Ueser?>(context);

//     hachlataItemsForHome = hachlataHome?.where((item) {
//           if (item != null) {
//             if (item.uid == globals.current_namesofuser) {
//               if (item.date == 'N/A') {
//                 return true; // Include items with 'N/A' dates
//               }

//               // Parse the date from item.date
//               final itemDate = DateTime.parse(item.date);

//               // Compare the year, month, and day of itemDate with focusedDate
//               bool dateComparison = itemDate.year == focusedDate.year &&
//                   itemDate.month == focusedDate.month &&
//                   itemDate.day == focusedDate.day;

//               // Print both dates
//               print('itemDate: $itemDate, focusedDate: $focusedDate');

//               return dateComparison; // Include items where the date comparison is true
//             }
//           }

//           return false;
//         }).toList() ??
//         [];
//     List<AddHachlataHome?> filterHachlataList(
//         List<AddHachlataHome?> inputList) {
//       Map<String, AddHachlataHome?> itemsMap = {};

//       // Get today's date year, month, and day
//       DateTime focusedDate = DateTime(today.year, today.month, today.day);

//       for (AddHachlataHome? item in inputList) {
//         if (item != null) {
//           String itemKey = '${item.name}_${item.uid}';

//           if (item.date == 'N/A') {
//             // If an item with the same key already exists and has a matching date, add the other one
//             if (itemsMap.containsKey(itemKey) &&
//                 itemsMap[itemKey]?.date == focusedDate.toString()) {
//               itemsMap.remove(itemKey);
//             }
//             itemsMap[itemKey] = item;
//           } else {
//             // Parse the date from item.date
//             DateTime itemDate;
//             try {
//               itemDate = DateTime.parse(item.date);
//             } catch (e) {
//               // Handle parsing error, set a default date
//               itemDate = DateTime(0);
//             }

//             // If an item with the same key already exists and has a matching date, add the other one
//             if (itemsMap.containsKey(itemKey) &&
//                 itemsMap[itemKey]?.date == focusedDate.toString()) {
//               itemsMap.remove(itemKey);
//             }

//             // If an item with the same key already exists but has an 'N/A' date, replace it with this item
//             if (itemsMap.containsKey(itemKey) &&
//                 itemsMap[itemKey]?.date == 'N/A') {
//               itemsMap.remove(itemKey);
//               itemsMap[itemKey] = item;
//             }

//             // Otherwise, include items where the date comparison is true
//             bool dateComparisonResult = itemDate.year == focusedDate.year &&
//                 itemDate.month == focusedDate.month &&
//                 itemDate.day == focusedDate.day;

//             if (dateComparisonResult) {
//               itemsMap[itemKey] = item;
//             }
//           }
//         }
//       }

//       return itemsMap.values.toList();
//     }

//     hachlataItemsForHome = filterHachlataList(hachlataItemsForHome);

//     return Scaffold(
//       backgroundColor: globals.bage,
//       appBar: AppBar(
//         title: Text(
//           globals.current_namesofuser,
//           style: TextStyle(color: globals.newpink),
//         ),
//         centerTitle: true,
//         backgroundColor: globals.bage,
//         elevation: 0,
//         iconTheme: IconThemeData(
//           color: globals.newpink,
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(
//               top: 8,
//               right: 8,
//               left: 8,
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: globals.newpink,
//                 borderRadius: const BorderRadius.all(
//                   Radius.circular(20.0),
//                 ),
//               ),
//               child: TableCalendar(
//                 rowHeight: 60,
//                 daysOfWeekStyle: DaysOfWeekStyle(
//                     weekendStyle: TextStyle(color: globals.bage),
//                     weekdayStyle: TextStyle(color: globals.bage)),
//                 headerStyle: HeaderStyle(
//                   formatButtonVisible: false,
//                   titleCentered: true,
//                   titleTextStyle: TextStyle(
//                       color: globals.bage,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold),
//                   leftChevronIcon: Icon(Icons.arrow_back_ios,
//                       color: globals.bage), // Change the color here
//                   rightChevronIcon: Icon(Icons.arrow_forward_ios,
//                       color: globals.bage), // Change the color here
//                 ),
//                 availableGestures: AvailableGestures.all,
//                 selectedDayPredicate: (day) => isSameDay(day, today),
//                 focusedDay: today,
//                 calendarStyle: CalendarStyle(
//                     weekendTextStyle: TextStyle(color: globals.bage),
//                     outsideDaysVisible: false,
//                     defaultTextStyle: TextStyle(
//                       fontSize: 16.0, // Change the font size
//                       color: globals.bage, // Change the text color
//                     ),
//                     todayDecoration: BoxDecoration(
//                       color: Colors
//                           .white, // Customize the background color for today
//                       shape: BoxShape.circle,
//                     ),
//                     todayTextStyle: TextStyle(color: globals.newpink),
//                     selectedDecoration: BoxDecoration(
//                       color: globals
//                           .bage, // Customize the background color for selected days
//                       shape: BoxShape.circle,
//                     ),
//                     selectedTextStyle: TextStyle(color: globals.newpink)),
//                 firstDay: DateTime.utc(2023, 07, 7),
//                 lastDay: DateTime.utc(2033, 07, 7),
//                 onDaySelected: _onDaySelected,
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 15,
//           ),
//           Expanded(
//             child: GridView.builder(
//               itemCount: hachlataItemsForHome.length,
//               shrinkWrap: true,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 1,
//                 childAspectRatio: 2.5,
//               ),
//               // physics: NeverScrollableScrollPhysics(), // Disable grid scroll
//               itemBuilder: (context, index) {
//                 if (hachlataItemsForHome != null &&
//                     hachlataItemsForHome.length > index) {
//                   final hachlataName = hachlataItemsForHome[index]!.name ?? '';
//                   var tilecolor = hachlataItemsForHome[index]!.color ?? '';
//                   Color finaltilecolor;
//                   if (tilecolor == 'Color(0xFFCBBD7F);') {
//                     finaltilecolor = globals.lightGreen;
//                   } else {
//                     finaltilecolor = globals.doneHachlata;
//                   }
//                   filterHachlataList(hachlataItemsForHome);

//                   return StatsHachlataTileWidget(
//                       hachlataName: hachlataName, isclicked: finaltilecolor);
//                   // Pass the name
//                 }
//                 // Create a tile widget for each category's name
//                 return Container();
//                 // return HachlataTileWidget();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

///
///
///
///
class StatsAdminIndividual extends StatefulWidget {
  @override
  StatsAdminIndividualState createState() => StatsAdminIndividualState();
}

class StatsAdminIndividualState extends State<StatsAdminIndividual> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Account',
      style: optionStyle,
    ),
    Text(
      'Index 1: Calendar',
      style: optionStyle,
    ),
    Text(
      'Index 2: Stats',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool isPressed = false;
  bool isSettingsOn = false;

  @override
  Widget build(BuildContext context) {
    void updateGlobalsToday(DateTime newToday) {
      setState(() {
        globals.today = newToday;
      });
    }

    List<AddHachlataHome?> hachlataItemsForHome = [];

    final hachlataHome = Provider.of<List<AddHachlataHome?>?>(context);
    final focusedDate =
        DateTime(globals.today.year, globals.today.month, globals.today.day);
    globals.focused_day = focusedDate.toString();
    final user = Provider.of<Ueser?>(context);

    // for (var item in hachlataHome!)
    //   if (item!.date.contains('2023')) {
    //     globals.global_hachlata_number += 1;

    // }
    if (user?.uesname == null) {
      globals.displayusernameinaccount = globals.tempuesname;
    } else
      globals.displayusernameinaccount = user!.uesname!;
    hachlataItemsForHome = hachlataHome?.where((item) {
          if (item != null) {
            print('got here1');
            print(user!.uesname);
            if (item.uid == globals.current_namesofuser) {
              print('got here');
              if (item.date == 'N/A') {
                return true; // Include items with 'N/A' dates
              }

              // Parse the date from item.date
              final itemDate = DateTime.parse(item.date);

              // Compare the year, month, and day of itemDate with focusedDate
              bool dateComparison = itemDate.year == focusedDate.year &&
                  itemDate.month == focusedDate.month &&
                  itemDate.day == focusedDate.day;

              // Print both dates
              print('itemDate: $itemDate, focusedDate: $focusedDate');

              return dateComparison; // Include items where the date comparison is true
            }
          }

          return false;
        }).toList() ??
        [];
    List<AddHachlataHome?> filterHachlataList(
        List<AddHachlataHome?> inputList) {
      Map<String, AddHachlataHome?> itemsMap = {};

      // Get today's date year, month, and day
      DateTime focusedDate =
          DateTime(globals.today.year, globals.today.month, globals.today.day);

      for (AddHachlataHome? item in inputList) {
        if (item != null) {
          String itemKey = '${item.name}_${item.uid}';

          if (item.date == 'N/A') {
            // If an item with the same key already exists and has a matching date, add the other one
            if (itemsMap.containsKey(itemKey) &&
                itemsMap[itemKey]?.date == focusedDate.toString()) {
              itemsMap.remove(itemKey);
            }
            itemsMap[itemKey] = item;
          } else {
            // Parse the date from item.date
            DateTime itemDate;
            try {
              itemDate = DateTime.parse(item.date);
            } catch (e) {
              // Handle parsing error, set a default date
              itemDate = DateTime(0);
            }

            // If an item with the same key already exists and has a matching date, add the other one
            if (itemsMap.containsKey(itemKey) &&
                itemsMap[itemKey]?.date == focusedDate.toString()) {
              itemsMap.remove(itemKey);
            }

            // If an item with the same key already exists but has an 'N/A' date, replace it with this item
            if (itemsMap.containsKey(itemKey) &&
                itemsMap[itemKey]?.date == 'N/A') {
              itemsMap.remove(itemKey);
              itemsMap[itemKey] = item;
            }

            // Otherwise, include items where the date comparison is true
            bool dateComparisonResult = itemDate.year == focusedDate.year &&
                itemDate.month == focusedDate.month &&
                itemDate.day == focusedDate.day;

            if (dateComparisonResult) {
              itemsMap[itemKey] = item;
            }
          }
        }
      }

      return itemsMap.values.toList();
    }

    hachlataItemsForHome = filterHachlataList(hachlataItemsForHome);

    final changesettingsswitch =
        Provider.of<List<ChangeSettingsSwitch?>?>(context);

    // Check if changesettingsswitch is not null and not empty
    if (changesettingsswitch != null &&
        changesettingsswitch.isNotEmpty &&
        changesettingsswitch.any((element) => element?.off == true)) {
      isSettingsOn = true;
    } else {
      isSettingsOn = false;
    }
    return Scaffold(
      backgroundColor: globals.bage,
      appBar: AppBar(
        title: Text(
          globals.current_namesofuser,
          style: TextStyle(color: globals.newpink),
        ),
        centerTitle: true,
        backgroundColor: globals.bage,
        elevation: 0,
        iconTheme: IconThemeData(
          color: globals.newpink,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(children: [
          Expanded(
            child: GridView.builder(
              itemCount: hachlataItemsForHome.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 1,
                childAspectRatio: 2.5,
              ),
              itemBuilder: (context, index) {
                if (hachlataItemsForHome != null &&
                    hachlataItemsForHome.length > index) {
                  final hachlataName = hachlataItemsForHome[index]!.name ?? '';
                  var tilecolor = hachlataItemsForHome[index]!.color ?? '';
                  Color finaltilecolor;
                  print('length${hachlataItemsForHome.length}');
                  if (tilecolor == 'Color(0xFFCBBD7F);') {
                    finaltilecolor = globals.lightGreen;
                  } else {
                    finaltilecolor = globals.doneHachlata;
                  }
                  filterHachlataList(hachlataItemsForHome);

                  return StatsHachlataTileWidget(
                      hachlataName: hachlataName, isclicked: finaltilecolor);
                  // Pass the name
                }
                // Create a tile widget for each category's name
                return Container();
                // return HachlataTileWidget();
              },
            ),
          ),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: globals.bage,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar, color: Color(0xFFC16C9E)),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.chart_bar,
                color: Color(0xFFC16C9E),
              ),
              label: 'Stats',
            ),
          ],
          selectedItemColor: Color(0xFFC16C9E),
          unselectedItemColor: Color(0xFFC16C9E),
          selectedFontSize: 10,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.fixed,
          onTap: (index) async {
            // Navigate to different pages based on the tapped icon
            switch (index) {
              case 0:
                showModalBottomSheet(
                    // backgroundColor: lightPink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (context) =>
                        MyCalendar(onDaySelectedCallback: updateGlobalsToday));
                break;
              case 1:
                // await showDialog(
                //     context: context,
                //     builder: (BuildContext context) {
                //       // Define the content of your dialog here
                //       return ThisIsNotAvailableYet();
                //     });
                await showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    isScrollControlled: false,
                    context: context,
                    builder: (BuildContext context) {
                      // Define the content of your dialog here
                      // return SingleChildScrollView(child: UserStats());
                      return UserStatsAdmin();
                      // return ThisIsNotAvailableYet();
                    });

                break;
            }
          }),
    );
  }
}
