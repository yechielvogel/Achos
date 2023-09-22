// in wrapper file if user == 'admin' then it should show admin_home screen
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tzivos_hashem_milwaukee/screens/account_page.dart';
// import 'package:tzivos_hashem_milwaukee/services/auth.dart';
import 'package:tzivos_hashem_milwaukee/screens/category.dart';
import '../../shared/globals.dart';
import '../../widgets/empty_list_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final AuthService _auth = AuthService();
  bool isPressed = false;
  bool isHachlataListEmpty() {
    return HachlataWidgetList.isEmpty;
  }

  // List<Widget> HachlataWidgetList = [];

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
    return Scaffold(
      backgroundColor: bage,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.person,
            color: lightPink,
          ),
          onPressed: () async {
            showModalBottomSheet(
                // backgroundColor: lightPink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                context: context,
                builder: (context) => AccountPage());
            // _auth.signOut();
          },
        ),
        title: Center(
          child: Image.asset(
            'lib/assets/Asset3@3x.png',
            width: 60,
            height: 60,
          ),
        ),
        backgroundColor: bage,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                  icon: Icon(
                    isPressed
                        ? CupertinoIcons.gear_alt_fill
                        : CupertinoIcons.gear,
                  ),
                  color: lightPink,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MySettings())); // Replace with your widget
                    //   setState(() {
                    //     addHachlataTile();
                    //     // isPressed = true;
                    //   });

                    //   print(HachlataWidgetList.length);
                    // },
                  }),
            ),
          ),
        ],
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
                color: lightGreen,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: TableCalendar(
                rowHeight: 60,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                      color: bage, fontSize: 20, fontWeight: FontWeight.bold),
                  leftChevronIcon: Icon(Icons.arrow_back_ios,
                      color: darkGreen), // Change the color here
                  rightChevronIcon: Icon(Icons.arrow_forward_ios,
                      color: darkGreen), // Change the color here
                ),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                focusedDay: today,
                calendarStyle: CalendarStyle(
                    weekendTextStyle: TextStyle(color: bage),
                    outsideDaysVisible: false,
                    defaultTextStyle: TextStyle(
                      fontSize: 16.0, // Change the font size
                      color: bage, // Change the text color
                    ),
                    todayDecoration: BoxDecoration(
                      color: bage, // Customize the background color for today
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color:
                          darkGreen, // Customize the background color for selected days
                      shape: BoxShape.circle,
                    )),
                firstDay: DateTime.utc(2023, 07, 7),
                lastDay: DateTime.utc(2033, 07, 7),
                onDaySelected: _onDaySelected,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: GridView.builder(
              itemCount: isHachlataListEmpty() ? 1 : HachlataWidgetList.length,
              shrinkWrap: true,

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isHachlataListEmpty() ? 1 : 2,
                crossAxisSpacing: 1,
                childAspectRatio: isHachlataListEmpty() ? 4.5 : 2.5,
              ),

              // physics: NeverScrollableScrollPhysics(), // Disable grid scroll
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 0),
                  child: isHachlataListEmpty()
                      ? EmptyListWidget()
                      : HachlataWidgetList[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
