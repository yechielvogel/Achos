import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/models/add_hachlata_home.dart';
import 'package:tzivos_hashem_milwaukee/screens/account_page.dart';
import 'package:tzivos_hashem_milwaukee/widgets/hachlata_tile_widget.dart';
import 'package:tzivos_hashem_milwaukee/screens/category_admin.dart';
import '../../models/add_hachlata_home_new.dart';
import '../../services/database.dart';
import '../../shared/globals.dart' as globals;
import '../../models/ueser.dart';
import '../../shared/loading.dart';
import '../../widgets/calendar.dart';
import '../stats_admin.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class HomeAdmin extends StatefulWidget {
  @override
  HomeAdminState createState() => HomeAdminState();
}

class HomeAdminState extends State<HomeAdmin> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    void updateGlobalsToday(DateTime newToday) {
      setState(() {
        globals.today = newToday;
      });
    }

    return StreamBuilder<List<AddHachlataHomeNew>>(
        stream: DatabaseService(Uid: 'test').getSubCollectionStream(
            globals.displayusernameinaccount, globals.hebrew_focused_month),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
                backgroundColor: globals.bage,
                appBar: AppBar(
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
                  centerTitle: true,

                  backgroundColor: globals.bage,
                  elevation: 0,
                ),
                body: Loading());
          } else {
            List<AddHachlataHomeNew>? hachlataHomeNew = snapshot.data;
            if (hachlataHomeNew != null && hachlataHomeNew.isNotEmpty) {
              List<AddHachlataHomeNew?> hachlataItemsForHomeNew = [];

              final hachlataHome =
                  Provider.of<List<AddHachlataHome?>?>(context);
              void printDataFromList(List<AddHachlataHomeNew?>? dataList) {
                if (dataList == null) {
                }
                if (dataList != null) {
                  for (var item in dataList) {
                    if (item != null) {
                      print(
                          item); 
                    }
                  }
                }
              }

              final focusedDate = DateTime(
                  globals.today.year, globals.today.month, globals.today.day);
              globals.focused_day = focusedDate.toString();
              final user = Provider.of<Ueser?>(context);

              hachlataItemsForHomeNew = hachlataHomeNew.where((item) {
                    if (item.uid == user!.uesname) {
                      if (item.date == 'N/A') {
                        return true; 
                      }

                      final itemDate = DateTime.parse(item.date);

                      bool dateComparison =
                          itemDate.year == focusedDate.year &&
                              itemDate.month == focusedDate.month &&
                              itemDate.day == focusedDate.day;


                      return dateComparison; 
                    }

                    return false;
                  }).toList() ??
                  [];
              hachlataHome?.forEach((item) {
                if (item != null &&
                    item.uid == globals.displayusernameinaccount) {
                  AddHachlataHomeNew newItem = AddHachlataHomeNew(
                    uid: item.uid,
                    name: item.name,
                    hebrewdate: item.hebrewdate,
                    date: item.date,
                    color: item.color,
                  );

                  // Find the index to insert the new item in alphabetical order
                  int insertIndex = 0;
                  while (insertIndex < hachlataItemsForHomeNew.length) {
                    if (item.name.compareTo(
                            hachlataItemsForHomeNew[insertIndex]!.name) >
                        0) {
                      insertIndex++;
                    } else {
                      break;
                    }
                  }

                  hachlataItemsForHomeNew.insert(insertIndex, newItem);
                } else {}
              });

              List<AddHachlataHomeNew?> filterHachlataListNew(
                  List<AddHachlataHomeNew?> inputList) {
                Map<String, AddHachlataHomeNew?> itemsMap = {};

                // Get today's date year, month, and day
                DateTime focusedDate = DateTime(
                    globals.today.year, globals.today.month, globals.today.day);

                for (AddHachlataHomeNew? item in inputList) {
                  if (item != null) {
                    String itemKey = '${item.name}_${item.uid}';

                    if (item.date == 'N/A' && item.hebrewdate != 'N/A') {
                      if (item.hebrewdate.contains('2023') &&
                          !item.hebrewdate.contains('end')) {
                        DateTime itemDate1 = DateTime.parse(item.hebrewdate);
                        DateTime globalsfocusedDate =
                            DateTime.parse(globals.focused_day);
                        DateTime todayDate1 = DateTime(globals.today.year,
                            globals.today.month, globals.today.day);
                        DateTime todayhebrewdate = DateTime(
                            itemDate1.year, itemDate1.month, itemDate1.day);
                        DateTime itemDateAddOneDay =
                            itemDate1.add(Duration(days: 1));

                        if (globalsfocusedDate.isAfter(itemDateAddOneDay)) {
                          // If an item with the same key already exists and has a matching date, add the other one
                          if (itemsMap.containsKey(itemKey) &&
                              itemsMap[itemKey]?.date ==
                                  focusedDate.toString()) {
                            itemsMap.remove(itemKey);
                          }
                          itemsMap[itemKey] = item;
                        }
                      }
                      if (item.hebrewdate.contains('2023') &&
                          item.hebrewdate.contains('end')) {
                        String dateWithOutEnd =
                            item.hebrewdate.replaceAll(RegExp(r'end\s'), '');
                        DateTime itemDate1 = DateTime.parse(dateWithOutEnd);
                        DateTime globalsfocusedDate =
                            DateTime.parse(globals.focused_day);
                        DateTime todayDate1 = DateTime(globals.today.year,
                            globals.today.month, globals.today.day);
                        DateTime todayhebrewdate = DateTime(
                            itemDate1.year, itemDate1.month, itemDate1.day);
                        DateTime itemDatePlusOneDay =
                            itemDate1.add(Duration(days: 1));

                        if (globalsfocusedDate.isBefore(itemDatePlusOneDay)) {
                          // If an item with the same key already exists and has a matching date, add the other one
                          if (itemsMap.containsKey(itemKey) &&
                              itemsMap[itemKey]?.date ==
                                  focusedDate.toString()) {
                            itemsMap.remove(itemKey);
                          }
                          itemsMap[itemKey] = item;
                        }
                      }
                    }
                    if (item.date == 'N/A' && item.hebrewdate == 'N/A') {
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
                      bool dateComparisonResult =
                          itemDate.year == focusedDate.year &&
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

              hachlataItemsForHomeNew =
                  filterHachlataListNew(hachlataItemsForHomeNew);

              return Scaffold(
                backgroundColor: globals.bage,
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
                  centerTitle: true,

                  backgroundColor: globals.bage,
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
                            color: globals.newpink,
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MySettingsAdmin()));
                            }),
                      ),
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(children: [
                    Expanded(
                      child: GridView.builder(
                        itemCount: hachlataItemsForHomeNew.length,
                        shrinkWrap: true,

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 1,
                          childAspectRatio: 2.5,
                        ),
                        itemBuilder: (context, index) {
                          if (hachlataItemsForHomeNew != null &&
                              hachlataItemsForHomeNew.length > index) {
                            final hachlataName =
                                hachlataItemsForHomeNew[index]!.name ?? '';
                            var tilecolor =
                                hachlataItemsForHomeNew[index]!.color ?? '';
                            Color finaltilecolor;
                            if (tilecolor == 'Color(0xFFCBBD7F);') {
                              finaltilecolor = globals.lightGreen;
                            } else {
                              finaltilecolor = globals.doneHachlata;
                            }
                            filterHachlataListNew(hachlataItemsForHomeNew);

                            return HachlataTileWidget(
                                hachlataName: hachlataName,
                                isclicked: finaltilecolor);
                          }
                          return Container();
                        },
                      ),
                    ),
                  ]),
                ),
                bottomNavigationBar: BottomNavigationBar(
                    elevation: 0,
                    backgroundColor: globals.bage,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.person,
                            color: Color(0xFFC16C9E)),
                        label: 'Account',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.calendar,
                            color: Color(0xFFC16C9E)),
                        label: 'Calendar',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          CupertinoIcons.chart_bar,
                          color: Color(0xFFC16C9E),
                        ),
                        label: 'Stats',
                      ),
                      // remove for android
                      if (Platform.isIOS)
                        BottomNavigationBarItem(
                          icon: ImageIcon(
                            AssetImage('lib/assets/chabadorgachos1@3x.png'),
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
                      switch (index) {
                        case 0:
                          showModalBottomSheet(
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              context: context,
                              builder: (context) => MyCalendar(
                                  onDaySelectedCallback: updateGlobalsToday));
                          break;
                        case 2:
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StatsAdmin()));

                          break;
                        //remove for android
                        case 3:
                          await LaunchApp.openApp(
                            androidPackageName: 'org.chabad.android.DailyStudy',
                            iosUrlScheme: 'org.chabad.DailyStudy://',
                            appStoreLink:
                                'itms-apps://itunes.apple.com/us/app/chabad-org-daily-torah-study/id1408133263',
                            // openStore: false
                          );
                          break;
                      }
                    }),
              );
            } else {
              Future<void> updateHachlataForUser(
                  List<AddHachlataHome?>? hachlataHome, String username) async {
                if (hachlataHome != null) {
                  hachlataHome.forEach((hachlata) {
                    if (hachlata != null &&
                        hachlata.uid == username &&
                        hachlata.date != 'N/A') {
                      String hachlatadocname =
                          hachlata.uid + hachlata.name + hachlata.date;

                      DatabaseService(Uid: 'test').updateDoneHachlataNew(
                        hachlata.uid.toString(),
                        hachlata.name,
                        hachlata.date,
                        hachlata.hebrewdate,
                        hachlata.color,
                        username,
                        'Cheshvan',
                        hachlatadocname,
                      );
                      DatabaseService(Uid: 'test')
                          .delteHachlataHomeForUpdate(hachlatadocname);
                    }
                  });
                }
              }

              List<AddHachlataHome?> hachlataItemsForHome = [];
              List<AddHachlataHomeNew?> hachlataItemsForHomeNew = [];

              final hachlataHome =
                  Provider.of<List<AddHachlataHome?>?>(context);
              final hachlataHomeNew =
                  Provider.of<List<AddHachlataHomeNew?>?>(context);

              void printDataFromList(List<AddHachlataHomeNew?>? dataList) {
                if (dataList == null) {}
                if (dataList != null) {
                  for (var item in dataList) {
                    if (item != null) {
                      print(
                          item); // Will automatically call the overridden toString() method
                    }
                  }
                }
              }

              final focusedDate = DateTime(
                  globals.today.year, globals.today.month, globals.today.day);
              globals.focused_day = focusedDate.toString();
              final user = Provider.of<Ueser?>(context);

              hachlataItemsForHome = hachlataHome?.where((item) {
                    if (item != null) {
                      if (item.uid == user!.uesname) {
                        if (item.date == 'N/A') {
                          return true; // Include items with 'N/A' dates
                        }

                        // Parse the date from item.date
                        final itemDate = DateTime.parse(item.date);

                        // Compare the year, month, and day of itemDate with focusedDate
                        bool dateComparison =
                            itemDate.year == focusedDate.year &&
                                itemDate.month == focusedDate.month &&
                                itemDate.day == focusedDate.day;

                        // Print both dates

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
                DateTime focusedDate = DateTime(
                    globals.today.year, globals.today.month, globals.today.day);

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
                      bool dateComparisonResult =
                          itemDate.year == focusedDate.year &&
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

              printDataFromList(hachlataHomeNew);

              return Scaffold(
                backgroundColor: globals.bage,
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
                  centerTitle: true,

                  backgroundColor: globals.bage,
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
                            color: globals.newpink,
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () async {
                              // await updateHachlataForUser(hachlataHome,
                              //     globals.displayusernameinaccount);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MySettingsAdmin()));
                            }),
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

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 1,
                          childAspectRatio: 2.5,
                        ),
                        itemBuilder: (context, index) {         
                          if (hachlataItemsForHome != null &&
                              hachlataItemsForHome.length > index) {
                            final hachlataName =
                                hachlataItemsForHome[index]!.name ?? '';
                            var tilecolor =
                                hachlataItemsForHome[index]!.color ?? '';
                            Color finaltilecolor;
                            if (tilecolor == 'Color(0xFFCBBD7F);') {
                              finaltilecolor = globals.lightGreen;
                            } else {
                              finaltilecolor = globals.doneHachlata;
                            }
                            filterHachlataList(hachlataItemsForHome);

                            return HachlataTileWidget(
                                hachlataName: hachlataName,
                                isclicked: finaltilecolor);
                          }
                          return Container();
                        },
                      ),
                    ),
                  ]),
                ),
                bottomNavigationBar: BottomNavigationBar(
                    elevation: 0,
                    backgroundColor: globals.bage,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.person,
                            color: Color(0xFFC16C9E)),
                        label: 'Account',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.calendar,
                            color: Color(0xFFC16C9E)),
                        label: 'Calendar',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          CupertinoIcons.chart_bar,
                          color: Color(0xFFC16C9E),
                        ),
                        label: 'Stats',
                      ),
                      if (Platform.isIOS)
                        BottomNavigationBarItem(
                          icon: ImageIcon(
                            AssetImage('lib/assets/chabadorgachos1@3x.png'),
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
                      switch (index) {
                        case 0:
                          showModalBottomSheet(
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              context: context,
                              builder: (context) => MyCalendar(
                                  onDaySelectedCallback: updateGlobalsToday));
                          break;
                        case 2:
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StatsAdmin()));

                          break;
                        case 3:
                          await LaunchApp.openApp(
                            androidPackageName: 'org.chabad.android.DailyStudy',
                            iosUrlScheme: 'org.chabad.DailyStudy://',
                            appStoreLink:
                                'itms-apps://itunes.apple.com/us/app/chabad-org-daily-torah-study/id1408133263',
                          );
                          break;
                      }
                    }),
              );
            }
          }
          // }
        });
  }
}
