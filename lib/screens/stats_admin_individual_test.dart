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
import '../models/add_hachlata_home_new.dart';
import '../models/change_settings_switch.dart';
import '../services/database.dart';
import '../shared/loading.dart';
import '../widgets/calendar.dart';
import '../widgets/get_all_data_in_all_collections.dart';
import '../widgets/new_admin_stats.dart';
import '../widgets/new_user_stats.dart';
import '../widgets/settings_off_widget.dart';
import '../widgets/stats_hachlata_tile_widget.dart';
import '../widgets/this_is_not_avalible_yet.dart';
import 'category.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    void updateGlobalsToday(DateTime newToday) {
      setState(() {
        globals.today = newToday;
      });
    }

    bool isSettingsOn = false;

    return StreamBuilder<List<AddHachlataHomeNew>>(
        stream: DatabaseService(Uid: 'test').getSubCollectionStream(
            globals.current_namesofuser, globals.hebrew_focused_month),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading(); // Display a loading indicator while waiting for data
          } else {
            if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Your Widget'),
                ),
                body: Center(
                  child: Text(
                      'Error: ${snapshot.error}'), // Display an error message if an error occurs
                ),
              );
            } else {
              List<AddHachlataHomeNew>? hachlataHomeNew = snapshot.data;
              if (hachlataHomeNew != null && hachlataHomeNew.isNotEmpty) {
                List<AddHachlataHome?> hachlataItemsForHome = [];
                List<AddHachlataHomeNew?> hachlataItemsForHomeNew = [];

                final hachlataHome =
                    Provider.of<List<AddHachlataHome?>?>(context);
                // final hachlataHomeNew =
                //     Provider.of<List<AddHachlataHomeNew?>?>(context);

                void printDataFromList(List<AddHachlataHomeNew?>? dataList) {
                  if (dataList == null) {
                    print('the list is empty');
                  }
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

                hachlataItemsForHomeNew = hachlataHomeNew?.where((item) {
                      if (item != null) {
                        if (item.uid == globals.current_namesofuser) {
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
                          print(
                              'itemDate: $itemDate, focusedDate: $focusedDate');

                          return dateComparison; // Include items where the date comparison is true
                        }
                      }

                      return false;
                    }).toList() ??
                    [];
                hachlataHome?.forEach((item) {
                  if (item != null && item.uid == globals.current_namesofuser) {
                    print('yes');
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
                  } else {
                    print('no');
                  }
                });
                print(
                    'current list is before filter ${hachlataItemsForHomeNew} current list is before filter length ${hachlataItemsForHomeNew.length}');
                List<AddHachlataHomeNew?> filterHachlataListNew(
                    List<AddHachlataHomeNew?> inputList) {
                  Map<String, AddHachlataHomeNew?> itemsMap = {};

                  // Get today's date year, month, and day
                  DateTime focusedDate = DateTime(globals.today.year,
                      globals.today.month, globals.today.day);

                  for (AddHachlataHomeNew? item in inputList) {
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

                hachlataItemsForHomeNew =
                    filterHachlataListNew(hachlataItemsForHomeNew);
                final changesettingsswitch =
                    Provider.of<List<ChangeSettingsSwitch?>?>(context);
                if (changesettingsswitch != null &&
                    changesettingsswitch.isNotEmpty &&
                    changesettingsswitch
                        .any((element) => element?.off == true)) {
                  isSettingsOn = true;
                } else {
                  isSettingsOn = false;
                }
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
                            itemCount: hachlataItemsForHomeNew.length,
                            shrinkWrap: true,

                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
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
                              if (hachlataItemsForHomeNew != null &&
                                  hachlataItemsForHomeNew.length > index) {
                                final hachlataName =
                                    hachlataItemsForHomeNew[index]!.name ?? '';
                                var tilecolor =
                                    hachlataItemsForHomeNew[index]!.color ?? '';
                                Color finaltilecolor;
                                print(
                                    'length${hachlataItemsForHomeNew.length}');
                                if (tilecolor == 'Color(0xFFCBBD7F);') {
                                  finaltilecolor = globals.lightGreen;
                                } else {
                                  finaltilecolor = globals.doneHachlata;
                                }
                                filterHachlataListNew(hachlataItemsForHomeNew);

                                return StatsHachlataTileWidget(
                                    hachlataName: hachlataName,
                                    isclicked: finaltilecolor);
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
                                  builder: (context) => MyCalendar(
                                      onDaySelectedCallback:
                                          updateGlobalsToday));
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
                        }));

//
//
//
              } else {
                Future<void> updateHachlataForUser(
                    List<AddHachlataHome?>? hachlataHome,
                    String username) async {
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

                print('stream hachlatanew${hachlataItemsForHomeNew.length}');
                void printDataFromList(List<AddHachlataHomeNew?>? dataList) {
                  if (dataList == null) {
                    print('the list is empty');
                  }
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
                        if (item.uid == globals.current_namesofuser) {
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
                          print(
                              'itemDate: $itemDate, focusedDate: $focusedDate');

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
                  DateTime focusedDate = DateTime(globals.today.year,
                      globals.today.month, globals.today.day);

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
                print('hachlatahome${hachlataItemsForHome.length}');
                print('hachlatahomenew list ${hachlataItemsForHomeNew.length}');

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

                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                              final hachlataName =
                                  hachlataItemsForHome[index]!.name ?? '';
                              var tilecolor =
                                  hachlataItemsForHome[index]!.color ?? '';
                              Color finaltilecolor;
                              print('length${hachlataItemsForHome.length}');
                              if (tilecolor == 'Color(0xFFCBBD7F);') {
                                finaltilecolor = globals.lightGreen;
                              } else {
                                finaltilecolor = globals.doneHachlata;
                              }
                              filterHachlataList(hachlataItemsForHome);

                              return StatsHachlataTileWidget(
                                  hachlataName: hachlataName,
                                  isclicked: finaltilecolor);
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
                      ],
                      selectedItemColor: Color(0xFFC16C9E),
                      unselectedItemColor: Color(0xFFC16C9E),
                      selectedFontSize: 10,
                      unselectedFontSize: 10,
                      type: BottomNavigationBarType.fixed,
                      onTap: (index) async {
                        // Navigate to different pages based on the tapped icon
                        // FirestoreDataFetcher alldata = FirestoreDataFetcher();
                        // await alldata.fetchAllCollectionsData();
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
                                builder: (context) => MyCalendar(
                                    onDaySelectedCallback: updateGlobalsToday));
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
          }
        });
  }
}
