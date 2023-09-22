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
import '../widgets/stats_hachlata_tile_widget.dart';

class StatsAdminIndividual extends StatefulWidget {
  @override
  StatsAdminIndividualState createState() => StatsAdminIndividualState();
}

class StatsAdminIndividualState extends State<StatsAdminIndividual> {
  // final AuthService _auth = AuthService();

  bool isPressed = false;
  // bool isHachlataListEmpty() {
  //   return HachlataWidgetList.isEmpty;
  // }
  // // List<Widget> HachlataWidgetList = [];

  // void addHachlataTile() {
  //   setState(() {
  //     HachlataWidgetList.add(HachlataTileWidget());
  //   });
  // }

  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<AddHachlataHome?> hachlataItemsForHome = [];

    final hachlataHome = Provider.of<List<AddHachlataHome?>?>(context);
    final focusedDate = DateTime(today.year, today.month, today.day);
    globals.focused_day = focusedDate.toString();
    final user = Provider.of<Ueser?>(context);

    hachlataItemsForHome = hachlataHome?.where((item) {
          if (item != null) {
            if (item.uid == globals.current_namesofuser) {
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
      DateTime focusedDate = DateTime(today.year, today.month, today.day);

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

    return Scaffold(
      backgroundColor: globals.bage,
      appBar: AppBar(
        title: Text(
          globals.current_namesofuser,
          style: TextStyle(color: globals.lightPink),
        ),
        backgroundColor: globals.bage,
        elevation: 0,
        iconTheme: IconThemeData(
          color: globals.lightPink,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              right: 8,
              left: 8,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: globals.lightGreen,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: TableCalendar(
                rowHeight: 60,
                daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: globals.bage),
                    weekdayStyle: TextStyle(color: globals.bage)),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                      color: globals.bage,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  leftChevronIcon: Icon(Icons.arrow_back_ios,
                      color: globals.darkGreen), // Change the color here
                  rightChevronIcon: Icon(Icons.arrow_forward_ios,
                      color: globals.darkGreen), // Change the color here
                ),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                focusedDay: today,
                calendarStyle: CalendarStyle(
                    weekendTextStyle: TextStyle(color: globals.bage),
                    outsideDaysVisible: false,
                    defaultTextStyle: TextStyle(
                      fontSize: 16.0, // Change the font size
                      color: globals.bage, // Change the text color
                    ),
                    todayDecoration: BoxDecoration(
                      color: globals
                          .bage, // Customize the background color for today
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: globals
                          .darkGreen, // Customize the background color for selected days
                      shape: BoxShape.circle,
                    )),
                firstDay: DateTime.utc(2023, 07, 7),
                lastDay: DateTime.utc(2033, 07, 7),
                onDaySelected: _onDaySelected,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: GridView.builder(
              itemCount: hachlataItemsForHome.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 1,
                childAspectRatio: 2.5,
              ),
              // physics: NeverScrollableScrollPhysics(), // Disable grid scroll
              itemBuilder: (context, index) {
                if (hachlataItemsForHome != null &&
                    hachlataItemsForHome.length > index) {
                  final hachlataName = hachlataItemsForHome[index]!.name ?? '';
                  var tilecolor = hachlataItemsForHome[index]!.color ?? '';
                  Color finaltilecolor;
                  if (tilecolor == 'Color(0xFFCBBD7F);') {
                    finaltilecolor = globals.lightGreen;
                  } else {
                    finaltilecolor = globals.darkGreen;
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
        ],
      ),
    );
  }
}
