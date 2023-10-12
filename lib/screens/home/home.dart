import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tzivos_hashem_milwaukee/models/add_hachlata_home.dart';
import 'package:tzivos_hashem_milwaukee/screens/account_page.dart';
// import 'package:tzivos_hashem_milwaukee/services/auth.dart';
import 'package:tzivos_hashem_milwaukee/widgets/hachlata_tile_widget.dart';
import 'package:tzivos_hashem_milwaukee/screens/category_admin.dart';
// import '../../services/auth.dart';
import '../../models/change_settings_switch.dart';
import '../../shared/globals.dart';
import '../../models/ueser.dart';
import '../../widgets/calendar.dart';
import '../../widgets/settings_off_widget.dart';
import '../../widgets/this_is_not_avalible_yet.dart';
import '../stats_admin.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
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

  // final AuthService _auth = AuthService();

  bool isPressed = false;
  bool isSettingsOn = false;

  // DateTime today = DateTime.now();
  // void _onDaySelected(DateTime day, DateTime focusedDay) {
  //   setState(() {
  //     today = day;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    void updateGlobalsToday(DateTime newToday) {
      setState(() {
        today = newToday;
      });
    }

    List<AddHachlataHome?> hachlataItemsForHome = [];

    final hachlataHome = Provider.of<List<AddHachlataHome?>?>(context);
    final focusedDate = DateTime(today.year, today.month, today.day);
    focused_day = focusedDate.toString();
    final user = Provider.of<Ueser?>(context);

    // for (var item in hachlataHome!)
    //   if (item!.date.contains('2023')) {
    //     globals.global_hachlata_number += 1;

    // }
    if (user?.uesname == null) {
      displayusernameinaccount = tempuesname;
    } else
      displayusernameinaccount = user!.uesname!;
    hachlataItemsForHome = hachlataHome?.where((item) {
          if (item != null) {
            print('got here1');
            print(user!.uesname);
            if (item.uid == displayusernameinaccount) {
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

    // DoneHachlata? matchingDoneHachlata;

    // if (doneHachlata != null) {
    //   try {
    //     matchingDoneHachlata = doneHachlata.firstWhere(
    //       (doneHachlataItem) {
    //         if (doneHachlataItem?.name == user!.uesname) {
    //           // Parse the date from doneHachlataItem.date
    //           final dbDate = DateTime.parse(doneHachlataItem?.date ?? '');

    //           // Compare the focused date (with time set to midnight) and the database date
    //           return dbDate.year == focusedDate.year &&
    //               dbDate.month == focusedDate.month &&
    //               dbDate.day == focusedDate.day;
    //         }

    //         return false;
    //       },
    //     );
    //   } catch (e) {
    //     matchingDoneHachlata = null;
    //   }
    // }

    // if (matchingDoneHachlata == null) {
    //   globals.tilecolor = globals.lightGreen;
    // } else {
    //   globals.tilecolor = globals.darkGreen;
    // } // Replace 'current_category' with the actual current category value
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
      backgroundColor: bage,
      appBar: AppBar(
        leading: Container(),
        // Padding(
        //   padding: const EdgeInsets.all(10.0),
        //   child: Container(
        //       child: Center(
        //           child: Text(
        //         globals.global_hachlata_number.toString(),
        //         style: TextStyle(color: globals.bage),
        //       )),
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: globals.newpink,
        //       )),
        // ),
        // leadingWidth: 40,
        title: Center(
          child: Image.asset(
            'lib/assets/NewLogo.png',
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
                  CupertinoIcons.gear,
                ),
                color: newpink,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () async {
                  if (isSettingsOn) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MySettingsAdmin(),
                      ),
                    );
                  } else {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // Define the content of your dialog here
                        return SettingsOffWidget();
                      },
                    );
                    // SettingsOffWidget();
                  }
                },
              ),
            ),
          ),
        ],
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
              // physics: NeverScrollableScrollPhysics(), // Disable grid scroll

              itemBuilder: (context, index) {
                //   if (hachlataItemsForHome.isEmpty) {
                //   print('length${hachlataItemsForHome.length}');

                //   return const EmptyListWidget();
                // }
                if (hachlataItemsForHome != null &&
                    hachlataItemsForHome.length > index) {
                  final hachlataName = hachlataItemsForHome[index]!.name ?? '';
                  var tilecolor = hachlataItemsForHome[index]!.color ?? '';
                  Color finaltilecolor;
                  print('length${hachlataItemsForHome.length}');
                  if (tilecolor == 'Color(0xFFCBBD7F);') {
                    finaltilecolor = lightGreen;
                  } else {
                    finaltilecolor = doneHachlata;
                  }
                  filterHachlataList(hachlataItemsForHome);

                  return HachlataTileWidget(
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
          backgroundColor: bage,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person, color: Color(0xFFC16C9E)),
              label: 'Account',
            ),
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
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.book,
                color: Color(0xFFC16C9E),
              ),
              label: 'Daily Study',
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
                    builder: (context) => AccountPage());
                break;
              case 1:
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
              case 2:
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // Define the content of your dialog here
                      return ThisIsNotAvailableYet();
                    });

                break;
              case 3:
                await LaunchApp.openApp(
                  androidPackageName: 'org.chabad.android.DailyStudy',
                  iosUrlScheme: 'chabad-org-daily-torah-study://',
                  appStoreLink:
                      'itms-apps://itunes.apple.com/us/app/chabad-org-daily-torah-study/id1408133263',
                  // openStore: false
                );

                // Enter the package name of the App you want to open and for iOS add the URLscheme to the Info.plist file.
                // The `openStore` argument decides whether the app redirects to PlayStore or AppStore.
                // For testing purpose you can enter com.instagram.android

                break;
            }
          }),
    );
  }
}
// test this is a test