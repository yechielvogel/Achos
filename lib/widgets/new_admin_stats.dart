import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;
import 'package:tzivos_hashem_milwaukee/shared/globals.dart';
import 'package:tzivos_hashem_milwaukee/widgets/stats_counter_widget.dart';
import 'package:tzivos_hashem_milwaukee/widgets/this_is_not_avalible_yet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/add_hachlata_home.dart';
import '../models/add_hachlata_home_new.dart';
import '../models/add_hachlata_home_new_test.dart';
import '../models/change_settings_switch.dart';
import '../models/ueser.dart';
import '../services/database.dart';
import '../shared/loading.dart';
import 'get_all_data_in_all_collections.dart';
import 'hachlata_tile_widget.dart';
import 'hachlata_tile_widget_for_stats.dart';

class UserStatsAdmin extends StatefulWidget {
  const UserStatsAdmin({super.key});

  @override
  State<UserStatsAdmin> createState() => _UserStatsAdminState();
}

class _UserStatsAdminState extends State<UserStatsAdmin> {
  get updateGlobalsToday => null;

  @override
  Widget build(BuildContext context) {
    // print('name to look for${globals.current_namesofuser}');
    return StreamBuilder<List<AddHachlataHomeNew>>(
        stream: DatabaseService(Uid: 'test').getSubCollectionStream(
            globals.current_namesofuser, globals.hebrew_focused_month),
        builder: (context, snapshot1) {
          return StreamBuilder(
              stream: DatabaseService(Uid: 'test').fetchAllCollectionsData(
                  globals.current_namesofuser, globals.allmonths),
              builder: (context, snapshot2) {
                // if (!snapshot2.hasData) {
                //   // No data available in the stream.
                //   print('no data');
                // } else
                //   print('snapshot two data = ${snapshot2.data}');
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return Loading(); // Display a loading indicator while waiting for data
                // } else {
                if (snapshot1.hasError) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('Your Widget'),
                    ),
                    body: Center(
                      child: Text(
                          'Error: ${snapshot1.error}'), // Display an error message if an error occurs
                    ),
                  );
                } else {
                  List<AddHachlataHomeNew>? hachlataHomeNew = snapshot1.data;
                  List<AddHachlataHomeNewTest>? hachlataHomeNewTest =
                      snapshot2.data;

                  if (hachlataHomeNew != null && hachlataHomeNew.isNotEmpty) {
                    final hachlataHome =
                        Provider.of<List<AddHachlataHome?>?>(context);

                    List<AddHachlataHome?> hachlataItemsForHome = [];
                    List<AddHachlataHomeNew?> hachlataItemsForHomeNew = [];
                    List<AddHachlataHomeNewTest?> hachlataItemsForHomeNewTest =
                        [];

                    // final hachlataHomeNew =
                    //     Provider.of<List<AddHachlataHomeNew?>?>(context);
                    // final user = Provider.of<Ueser?>(context);

                    JewishDate jewishDate = JewishDate();
                    HebrewDateFormatter hebrewDateFormatter =
                        HebrewDateFormatter();
                    String hebrewDate = hebrewDateFormatter.format(jewishDate);
                    String hebrewday =
                        jewishDate.getJewishDayOfMonth().toString();
                    String hebrewmonth = jewishDate.toString();
                    hebrewmonth = hebrewmonth.replaceAll(RegExp(r'[0-9]'), '');

                    List<AddHachlataHome?> hachlataItemsForStatsNew = [];
                    List<AddHachlataHomeNew?>
                        hachlataItemsForStatsThisMonthNew = [];
                    List<AddHachlataHomeNew?>
                        hachlataItemsForStatsThisMonthAllNew = [];
                    List<AddHachlataHomeNew?> hachlataItemsForStatsThisWeekNew =
                        [];
                    List<AddHachlataHomeNew?>
                        hachlataItemsForStatsTotalSpecificHachlataNew = [];

                    List<AddHachlataHomeNew?>
                        hachlataCountsThisMonthAllHachlataTotalNew = [];
                    List<AddHachlataHomeNew?>
                        hachlataCountsThisWeekAllHachlataTotalNew = [];
                    List<AddHachlataHomeNewTest?> hachlataItemsForStatsNewTest =
                        [];
                    List<AddHachlataHomeNewTest?> hachlataAllSpecificNewTest =
                        [];

                    Map<String, int> hachlataCountsThisMonthNew =
                        Map<String, int>();
                    Map<String, int> hachlataCountsThisWeekNew =
                        Map<String, int>();
                    Map<String, int> hachlataCountsThisHachlataTotalNew =
                        Map<String, int>();
                    // Map<String, int> hachlataCountsThisMonthAllHachlataTotal = Map<String, int>();
                    // Map<String, int> hachlataCountsThisWeekAllHachlataTotal = Map<String, int>();
                    // Map<String, int> hachlataCountsAllHachlataTotal = Map<String, int>();

                    // bool isfull = false;

                    displayusernameinaccount = globals.current_namesofuser;

// This will get all the hachlatas in all months hopefully :)
                    hachlataItemsForStatsNewTest =
                        hachlataHomeNewTest?.where((item) {
                              if (item != null) {
                                // if (item.hebrewdate.contains(hebrewmonth)) {
                                //   print('yes');
                                //   return true; // Include items with 'N/A' dates
                                // }
                                return true;
                                // Parse the date from item.date

                                // Include items where the date comparison is true
                              }

                              return false;
                            }).toList() ??
                            [];

                    // gets all the hachlatas
                    hachlataItemsForStatsNew = hachlataHome?.where((item) {
                          if (item != null) {
                            if (item.uid == displayusernameinaccount) {
                              // if (item.hebrewdate.contains(hebrewmonth)) {
                              //   print('yes');
                              //   return true; // Include items with 'N/A' dates
                              // }
                              return true;
                              // Parse the date from item.date

                              // Include items where the date comparison is true
                            }
                          }

                          return false;
                        }).toList() ??
                        [];
                    // gets all hachlatas for the month

                    hachlataCountsThisMonthAllHachlataTotalNew =
                        hachlataHomeNew?.where((item) {
                              if (item != null) {
                                if (item.uid == displayusernameinaccount &&
                                    item.date != 'N/A' &&
                                    item.hebrewdate.contains(
                                        globals.hebrew_focused_month)) {
                                  return true;
                                }
                              }

                              return false;
                            }).toList() ??
                            [];
                    // gets all this month
                    hachlataItemsForStatsThisMonthNew = hachlataHomeNew
                            ?.where((item) {
                          if (item != null) {
                            // Use a map to store counts for each hachlata name

                            if (item.uid == displayusernameinaccount &&
                                item.hebrewdate
                                    .contains(globals.hebrew_focused_month)) {
                              // Increment count for the current hachlata name
                              hachlataCountsThisMonthNew[item.name] =
                                  (hachlataCountsThisMonthNew[item.name] ?? 0) +
                                      1;
                              // if (hachlataCountsTotal != hebrewday) {
                              //   print('hachlatacountstotal${hachlataCountsTotal}');
                              //   setState(() {
                              //     isfull = false;
                              //   });
                              // }
                              // You can add additional conditions if needed

                              return true;
                            }
                          }

                          return false;
                        }).toList() ??
                        [];

                    bool isDateInCurrentWeek(String dateString) {
                      // Parse the date string into a DateTime object
                      DateTime date = DateTime.parse(dateString);

                      // Get the current date and time
                      DateTime now = DateTime.now();

                      // Check if the dates are in the same week
                      if (date.year == now.year &&
                          date.weekday <= now.weekday) {
                        // Check if the date is within 7 days ago
                        return now.difference(date).inDays <= 7;
                      }

                      return false;
                    }

                    // gets all this week
                    hachlataItemsForStatsThisWeekNew =
                        hachlataHomeNew?.where((item) {
                              if (item != null && item.date != 'N/A') {
                                // Use a map to store counts for each hachlata name for the week
                                if (item.uid == displayusernameinaccount &&
                                    item.hebrewdate != 'N/A' &&
                                    isDateInCurrentWeek(item.date)) {
                                  // Increment count for the current hachlata name for the week
                                  hachlataCountsThisWeekNew[item.name] =
                                      (hachlataCountsThisWeekNew[item.name] ??
                                              0) +
                                          1;

                                  // You can add additional conditions if needed

                                  return true;
                                }
                              }

                              return false;
                            }).toList() ??
                            [];

                    // gets all hachlatas this week
                    hachlataCountsThisWeekAllHachlataTotalNew =
                        hachlataHomeNew?.where((item) {
                              if (item != null && item.date != 'N/A') {
                                // Use a map to store counts for each hachlata name for the week
                                if (item.uid == displayusernameinaccount &&
                                    item.hebrewdate != 'N/A' &&
                                    isDateInCurrentWeek(item.date)) {
                                  // Increment count for the current hachlata name for the week

                                  // You can add additional conditions if needed

                                  return true;
                                }
                              }

                              return false;
                            }).toList() ??
                            [];

                    // gets total of specific hachlata
                    // hachlataItemsForStatsTotalSpecificHachlataNew =
                    //     hachlataHomeNew?.where((item) {
                    //           if (item != null) {
                    //             // Use a map to store counts for each hachlata name

                    //             // Increment count for the current hachlata name
                    //             hachlataCountsThisHachlataTotalNew[item.name] =
                    //                 (hachlataCountsThisHachlataTotalNew[
                    //                             item.name] ??
                    //                         0) +
                    //                     1;

                    //             // isfull = true;

                    //             // You can add additional conditions if needed

                    //             return true;
                    //           }

                    //           return false;
                    //         }).toList() ??
                    //         [];
                    hachlataAllSpecificNewTest =
                        hachlataHomeNewTest?.where((item) {
                              if (item != null) {
                                // Use a map to store counts for each hachlata name

                                // Increment count for the current hachlata name
                                hachlataCountsThisHachlataTotalNew[item.name] =
                                    (hachlataCountsThisHachlataTotalNew[
                                                item.name] ??
                                            0) +
                                        1;

                                // isfull = true;

                                // You can add additional conditions if needed

                                return true;
                              }

                              return false;
                            }).toList() ??
                            [];
                    // gets total of all hachlata
                    // hachlataCountsAllHachlataTotalNew =
                    //     hachlataItemsForHomeNewTest?.where((item) {
                    //           if (item != null) {
                    //             print('got to line 39');
                    //             print(displayusernameinaccount);
                    //             print(item.uid);

                    //             // Use a map to store counts for each hachlata name

                    //             if (item.uid == displayusernameinaccount &&
                    //                 item.hebrewdate != 'N/A') {
                    //               print('got here');

                    //               // Increment count for the current hachlata name

                    //               // isfull = true;

                    //               // You can add additional conditions if needed

                    //               return true;
                    //             }
                    //           }

                    //           return false;
                    //         }).toList() ??
                    //         [];

                    void isFull() {}

                    return Container(
                      decoration: BoxDecoration(
                          color: bage,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          )),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 25.0, bottom: 8),
                              child: Text(
                                'Stats',
                                style: TextStyle(
                                  color: newpink,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 20,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Container(
                                              child: Text(
                                                'This month',
                                                style: TextStyle(
                                                  color: newpink,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            child: Container(
                                              child: Text(
                                                'This week',
                                                style: TextStyle(
                                                  color: newpink,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              'Total',
                                              style: TextStyle(
                                                color: newpink,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 5),
                                      child: Container(
                                        child: Text(
                                          "Hachlata's",
                                          style: TextStyle(
                                            color: newpink,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),

                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: ListView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),

                                                          itemCount:
                                                              hachlataItemsForStatsNew
                                                                  .length,
                                                          shrinkWrap: true,
                                                          // gridDelegate:
                                                          // const SliverGridDelegateWithFixedCrossAxisCount(
                                                          // crossAxisCount: 1,
                                                          // crossAxisSpacing: 0,
                                                          // childAspectRatio: 1,

                                                          itemBuilder:
                                                              (context, index) {
                                                            if (hachlataItemsForStatsNew !=
                                                                    null &&
                                                                hachlataItemsForStatsNew
                                                                        .length >
                                                                    index) {
                                                              final hachlataName =
                                                                  hachlataItemsForStatsNew[
                                                                              index]!
                                                                          .name ??
                                                                      '';

                                                              // Retrieve the count for the hachlata name from the hachlataCounts map
                                                              int count =
                                                                  hachlataCountsThisMonthNew[
                                                                          hachlataName] ??
                                                                      0;

                                                              return StatsCounterWidget(
                                                                hachlatacountint:
                                                                    count
                                                                        .toString(),
                                                                isclicked:
                                                                    newpink,
                                                              );
                                                            }

                                                            // Handle other cases or return an empty container

                                                            // Create a tile widget for each category's name
                                                            return Container();
                                                            // return HachlataTileWidgetForStats();
                                                          },
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                        // padding: EdgeInsets.zero,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount: 1,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          if (hachlataItemsForStatsNew !=
                                                                  null &&
                                                              hachlataItemsForStatsNew
                                                                      .length >
                                                                  index) {
                                                            final hachlataName =
                                                                hachlataItemsForStatsNew[
                                                                            index]!
                                                                        .name ??
                                                                    '';
                                                            int count =
                                                                hachlataCountsThisWeekNew[
                                                                        hachlataName] ??
                                                                    0;
                                                            return StatsCounterWidget(
                                                              hachlatacountint:
                                                                  hachlataCountsThisMonthAllHachlataTotalNew
                                                                      .length
                                                                      .toString(),
                                                              isclicked:
                                                                  lightGreen,
                                                            );
                                                          }
                                                          return Container();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: ListView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),

                                                          itemCount:
                                                              hachlataItemsForStatsNew
                                                                  .length,
                                                          shrinkWrap: true,
                                                          // gridDelegate:
                                                          // const SliverGridDelegateWithFixedCrossAxisCount(
                                                          // crossAxisCount: 1,
                                                          // crossAxisSpacing: 0,
                                                          // childAspectRatio: 1,

                                                          itemBuilder:
                                                              (context, index) {
                                                            if (hachlataItemsForStatsNew !=
                                                                    null &&
                                                                hachlataItemsForStatsNew
                                                                        .length >
                                                                    index) {
                                                              final hachlataName =
                                                                  hachlataItemsForStatsNew[
                                                                              index]!
                                                                          .name ??
                                                                      '';

                                                              // Retrieve the count for the hachlata name from the hachlataCounts map
                                                              int count =
                                                                  hachlataCountsThisWeekNew[
                                                                          hachlataName] ??
                                                                      0;

                                                              return StatsCounterWidget(
                                                                hachlatacountint:
                                                                    count
                                                                        .toString(),
                                                                isclicked:
                                                                    newpink,
                                                              );
                                                            }

                                                            // Create a tile widget for each category's name
                                                            return Container();
                                                            // return HachlataTileWidgetForStats();
                                                          },
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                        // padding: EdgeInsets.zero,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount: 1,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          if (hachlataItemsForStatsNew !=
                                                                  null &&
                                                              hachlataItemsForStatsNew
                                                                      .length >
                                                                  index) {
                                                            final hachlataName =
                                                                hachlataItemsForStatsNew[
                                                                            index]!
                                                                        .name ??
                                                                    '';
                                                            int count =
                                                                hachlataCountsThisWeekNew[
                                                                        hachlataName] ??
                                                                    0;
                                                            return StatsCounterWidget(
                                                              hachlatacountint:
                                                                  hachlataCountsThisWeekAllHachlataTotalNew
                                                                      .length
                                                                      .toString(),
                                                              isclicked:
                                                                  lightGreen,
                                                            );
                                                          }
                                                          return Container();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: ListView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),

                                                          itemCount:
                                                              hachlataItemsForStatsNew
                                                                  .length,
                                                          shrinkWrap: true,
                                                          // gridDelegate:
                                                          // const SliverGridDelegateWithFixedCrossAxisCount(
                                                          // crossAxisCount: 1,
                                                          // crossAxisSpacing: 0,
                                                          // childAspectRatio: 1,

                                                          itemBuilder:
                                                              (context, index) {
                                                            if (hachlataItemsForStatsNew !=
                                                                    null &&
                                                                hachlataItemsForStatsNew
                                                                        .length >
                                                                    index) {
                                                              final hachlataName =
                                                                  hachlataItemsForStatsNew[
                                                                              index]!
                                                                          .name ??
                                                                      '';

                                                              // Retrieve the count for the hachlata name from the hachlataCounts map
                                                              int count =
                                                                  hachlataCountsThisHachlataTotalNew[
                                                                          hachlataName] ??
                                                                      0;

                                                              return StatsCounterWidget(
                                                                hachlatacountint:
                                                                    count
                                                                        .toString(),
                                                                isclicked:
                                                                    newpink,
                                                              );
                                                            }

                                                            // Create a tile widget for each category's name
                                                            return Container();
                                                            // return HachlataTileWidgetForStats();
                                                          },
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                        // padding: EdgeInsets.zero,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount: 1,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          if (hachlataItemsForStatsNew !=
                                                                  null &&
                                                              hachlataItemsForStatsNew
                                                                      .length >
                                                                  index) {
                                                            final hachlataName =
                                                                hachlataItemsForStatsNew[
                                                                            index]!
                                                                        .name ??
                                                                    '';
                                                            int count =
                                                                hachlataCountsThisWeekNew[
                                                                        hachlataName] ??
                                                                    0;
                                                            return StatsCounterWidget(
                                                              hachlatacountint:
                                                                  hachlataItemsForStatsNewTest
                                                                      .length
                                                                      .toString(),
                                                              isclicked:
                                                                  lightGreen,
                                                            );
                                                          }
                                                          return Container();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Text(
                                            //     'you have done ${hachlataItemsForStats.length.toString()} hachlatas this month'),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: ListView.builder(
                                                padding: EdgeInsets.zero,
                                                physics:
                                                    NeverScrollableScrollPhysics(),

                                                itemCount:
                                                    hachlataItemsForStatsNew
                                                        .length,
                                                shrinkWrap: true,
                                                // gridDelegate:
                                                // const SliverGridDelegateWithFixedCrossAxisCount(
                                                // crossAxisCount: 1,
                                                // crossAxisSpacing: 0,
                                                // childAspectRatio: 1,

                                                itemBuilder: (context, index) {
                                                  if (hachlataItemsForStatsNew !=
                                                          null &&
                                                      hachlataItemsForStatsNew
                                                              .length >
                                                          index) {
                                                    final hachlataName =
                                                        hachlataItemsForStatsNew[
                                                                    index]!
                                                                .name ??
                                                            '';

                                                    return HachlataTileWidgetForStats(
                                                        hachlataName:
                                                            hachlataName,
                                                        isclicked:
                                                            globals.newpink);
                                                    // Pass the name
                                                  }

                                                  // Create a tile widget for each category's name
                                                  return Container();
                                                  // return HachlataTileWidgetForStats();
                                                },
                                              ),
                                            ),
                                            ListView.builder(
                                              // padding: EdgeInsets.zero,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: 1,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                if (hachlataItemsForStatsNew !=
                                                        null &&
                                                    hachlataItemsForStatsNew
                                                            .length >
                                                        index) {
                                                  final hachlataName =
                                                      hachlataItemsForStatsNew[
                                                                  index]!
                                                              .name ??
                                                          '';
                                                  int count =
                                                      hachlataCountsThisWeekNew[
                                                              hachlataName] ??
                                                          0;
                                                  return HachlataTileWidgetForStats(
                                                      hachlataName: 'Total',
                                                      isclicked:
                                                          globals.lightGreen);
                                                }
                                                return Container();
                                              },
                                            ),
                                            // Text(
                                            //     'you have done ${hachlataItemsForStats.length.toString()} hachlatas this month'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Expanded(
                          //       child: Container(
                          //           child: HachlataTileWidgetForStats(
                          //               hachlataName: 'Total this month', isclicked: newpink)),
                          //     ),
                          //     Expanded(child: StatsCounterWidget(hachlatacountint: '1'))
                          //   ],
                          // )
                        ],
                      ),
                    );

//
//
//
                  } else {
                    final hachlataHome =
                        Provider.of<List<AddHachlataHome?>?>(context);
                    final user = Provider.of<Ueser?>(context);

                    JewishDate jewishDate = JewishDate();
                    HebrewDateFormatter hebrewDateFormatter =
                        HebrewDateFormatter();
                    String hebrewDate = hebrewDateFormatter.format(jewishDate);
                    String hebrewday =
                        jewishDate.getJewishDayOfMonth().toString();
                    String hebrewmonth = jewishDate.toString();
                    hebrewmonth = hebrewmonth.replaceAll(RegExp(r'[0-9]'), '');

                    List<AddHachlataHome?> hachlataItemsForStats = [];
                    List<AddHachlataHome?> hachlataItemsForStatsThisMonth = [];
                    List<AddHachlataHome?> hachlataItemsForStatsThisMonthAll =
                        [];
                    List<AddHachlataHome?> hachlataItemsForStatsThisWeek = [];
                    List<AddHachlataHome?>
                        hachlataItemsForStatsTotalSpecificHachlata = [];

                    List<AddHachlataHome?>
                        hachlataCountsThisMonthAllHachlataTotal = [];
                    List<AddHachlataHome?>
                        hachlataCountsThisWeekAllHachlataTotal = [];
                    List<AddHachlataHome?> hachlataCountsAllHachlataTotal = [];

                    Map<String, int> hachlataCountsThisMonth =
                        Map<String, int>();
                    Map<String, int> hachlataCountsThisWeek =
                        Map<String, int>();
                    Map<String, int> hachlataCountsThisHachlataTotal =
                        Map<String, int>();
                    // Map<String, int> hachlataCountsThisMonthAllHachlataTotal = Map<String, int>();
                    // Map<String, int> hachlataCountsThisWeekAllHachlataTotal = Map<String, int>();
                    // Map<String, int> hachlataCountsAllHachlataTotal = Map<String, int>();

                    // bool isfull = false;

                    displayusernameinaccount = globals.current_namesofuser;
                    // gets all the hachlatas
                    hachlataItemsForStats = hachlataHome?.where((item) {
                          if (item != null) {
                            if (item.uid == displayusernameinaccount &&
                                item.date == 'N/A') {
                              // if (item.hebrewdate.contains(hebrewmonth)) {
                              //   print('yes');
                              //   return true; // Include items with 'N/A' dates
                              // }
                              return true;
                              // Parse the date from item.date

                              // Include items where the date comparison is true
                            }
                          }

                          return false;
                        }).toList() ??
                        [];
// gets all hachlatas for the month

                    hachlataCountsThisMonthAllHachlataTotal =
                        hachlataHome?.where((item) {
                              if (item != null) {
                                if (item.uid == displayusernameinaccount &&
                                    item.date != 'N/A' &&
                                    item.hebrewdate.contains(
                                        globals.hebrew_focused_month)) {
                                  return true;
                                }
                              }

                              return false;
                            }).toList() ??
                            [];
                    // gets all this month
                    hachlataItemsForStatsThisMonth = hachlataHome
                            ?.where((item) {
                          if (item != null) {
                            // Use a map to store counts for each hachlata name

                            if (item.uid == displayusernameinaccount &&
                                item.hebrewdate
                                    .contains(globals.hebrew_focused_month)) {
                              // Increment count for the current hachlata name
                              hachlataCountsThisMonth[item.name] =
                                  (hachlataCountsThisMonth[item.name] ?? 0) + 1;
                              // if (hachlataCountsTotal != hebrewday) {
                              //   print('hachlatacountstotal${hachlataCountsTotal}');
                              //   setState(() {
                              //     isfull = false;
                              //   });
                              // }
                              // You can add additional conditions if needed

                              return true;
                            }
                          }

                          return false;
                        }).toList() ??
                        [];

                    bool isDateInCurrentWeek(String dateString) {
                      // Parse the date string into a DateTime object
                      DateTime date = DateTime.parse(dateString);

                      // Get the current date and time
                      DateTime now = DateTime.now();

                      // Check if the dates are in the same week
                      if (date.year == now.year &&
                          date.weekday <= now.weekday) {
                        // Check if the date is within 7 days ago
                        return now.difference(date).inDays <= 7;
                      }

                      return false;
                    }

                    // gets all this week
                    hachlataItemsForStatsThisWeek = hachlataHome?.where((item) {
                          if (item != null && item.date != 'N/A') {
                            // Use a map to store counts for each hachlata name for the week
                            if (item.uid == displayusernameinaccount &&
                                item.hebrewdate != 'N/A' &&
                                isDateInCurrentWeek(item.date)) {
                              // Increment count for the current hachlata name for the week
                              hachlataCountsThisWeek[item.name] =
                                  (hachlataCountsThisWeek[item.name] ?? 0) + 1;

                              // You can add additional conditions if needed

                              return true;
                            }
                          }

                          return false;
                        }).toList() ??
                        [];

                    // gets all hachlatas this week
                    hachlataCountsThisWeekAllHachlataTotal =
                        hachlataHome?.where((item) {
                              if (item != null && item.date != 'N/A') {
                                // Use a map to store counts for each hachlata name for the week
                                if (item.uid == displayusernameinaccount &&
                                    item.hebrewdate != 'N/A' &&
                                    isDateInCurrentWeek(item.date)) {
                                  // Increment count for the current hachlata name for the week

                                  // You can add additional conditions if needed

                                  return true;
                                }
                              }

                              return false;
                            }).toList() ??
                            [];

                    // gets total of specific hachlata
                    hachlataItemsForStatsTotalSpecificHachlata = hachlataHome
                            ?.where((item) {
                          if (item != null) {
                            // Use a map to store counts for each hachlata name

                            if (item.uid == displayusernameinaccount &&
                                item.hebrewdate != 'N/A') {
                              // Increment count for the current hachlata name
                              hachlataCountsThisHachlataTotal[item.name] =
                                  (hachlataCountsThisHachlataTotal[item.name] ??
                                          0) +
                                      1;

                              // isfull = true;

                              // You can add additional conditions if needed

                              return true;
                            }
                          }

                          return false;
                        }).toList() ??
                        [];
                    // gets total of all hachlata
                    hachlataCountsAllHachlataTotal =
                        hachlataHome?.where((item) {
                              if (item != null) {
                                // Use a map to store counts for each hachlata name

                                if (item.uid == displayusernameinaccount &&
                                    item.hebrewdate != 'N/A') {
                                  // Increment count for the current hachlata name

                                  // isfull = true;

                                  // You can add additional conditions if needed

                                  return true;
                                }
                              }

                              return false;
                            }).toList() ??
                            [];

                    void isFull() {}

                    return Container(
                      decoration: BoxDecoration(
                          color: bage,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          )),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 25.0, bottom: 8),
                              child: Text(
                                'Stats',
                                style: TextStyle(
                                  color: newpink,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 20,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Container(
                                              child: Text(
                                                'This month',
                                                style: TextStyle(
                                                  color: newpink,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            child: Container(
                                              child: Text(
                                                'This week',
                                                style: TextStyle(
                                                  color: newpink,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              'Total',
                                              style: TextStyle(
                                                color: newpink,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 5),
                                      child: Container(
                                        child: Text(
                                          "Hachlata's",
                                          style: TextStyle(
                                            color: newpink,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),

                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: ListView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),

                                                          itemCount:
                                                              hachlataItemsForStats
                                                                  .length,
                                                          shrinkWrap: true,
                                                          // gridDelegate:
                                                          // const SliverGridDelegateWithFixedCrossAxisCount(
                                                          // crossAxisCount: 1,
                                                          // crossAxisSpacing: 0,
                                                          // childAspectRatio: 1,

                                                          itemBuilder:
                                                              (context, index) {
                                                            if (hachlataItemsForStats !=
                                                                    null &&
                                                                hachlataItemsForStats
                                                                        .length >
                                                                    index) {
                                                              final hachlataName =
                                                                  hachlataItemsForStats[
                                                                              index]!
                                                                          .name ??
                                                                      '';

                                                              // Retrieve the count for the hachlata name from the hachlataCounts map
                                                              int count =
                                                                  hachlataCountsThisMonth[
                                                                          hachlataName] ??
                                                                      0;

                                                              return StatsCounterWidget(
                                                                hachlatacountint:
                                                                    count
                                                                        .toString(),
                                                                isclicked:
                                                                    newpink,
                                                              );
                                                            }

                                                            // Handle other cases or return an empty container

                                                            // Create a tile widget for each category's name
                                                            return Container();
                                                            // return HachlataTileWidgetForStats();
                                                          },
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                        // padding: EdgeInsets.zero,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount: 1,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          if (hachlataItemsForStats !=
                                                                  null &&
                                                              hachlataItemsForStats
                                                                      .length >
                                                                  index) {
                                                            final hachlataName =
                                                                hachlataItemsForStats[
                                                                            index]!
                                                                        .name ??
                                                                    '';
                                                            int count =
                                                                hachlataCountsThisWeek[
                                                                        hachlataName] ??
                                                                    0;
                                                            return StatsCounterWidget(
                                                              hachlatacountint:
                                                                  hachlataCountsThisMonthAllHachlataTotal
                                                                      .length
                                                                      .toString(),
                                                              isclicked:
                                                                  lightGreen,
                                                            );
                                                          }
                                                          return Container();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: ListView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),

                                                          itemCount:
                                                              hachlataItemsForStats
                                                                  .length,
                                                          shrinkWrap: true,
                                                          // gridDelegate:
                                                          // const SliverGridDelegateWithFixedCrossAxisCount(
                                                          // crossAxisCount: 1,
                                                          // crossAxisSpacing: 0,
                                                          // childAspectRatio: 1,

                                                          itemBuilder:
                                                              (context, index) {
                                                            if (hachlataItemsForStats !=
                                                                    null &&
                                                                hachlataItemsForStats
                                                                        .length >
                                                                    index) {
                                                              final hachlataName =
                                                                  hachlataItemsForStats[
                                                                              index]!
                                                                          .name ??
                                                                      '';

                                                              // Retrieve the count for the hachlata name from the hachlataCounts map
                                                              int count =
                                                                  hachlataCountsThisWeek[
                                                                          hachlataName] ??
                                                                      0;

                                                              return StatsCounterWidget(
                                                                hachlatacountint:
                                                                    count
                                                                        .toString(),
                                                                isclicked:
                                                                    newpink,
                                                              );
                                                            }

                                                            // Create a tile widget for each category's name
                                                            return Container();
                                                            // return HachlataTileWidgetForStats();
                                                          },
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                        // padding: EdgeInsets.zero,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount: 1,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          if (hachlataItemsForStats !=
                                                                  null &&
                                                              hachlataItemsForStats
                                                                      .length >
                                                                  index) {
                                                            final hachlataName =
                                                                hachlataItemsForStats[
                                                                            index]!
                                                                        .name ??
                                                                    '';
                                                            int count =
                                                                hachlataCountsThisWeek[
                                                                        hachlataName] ??
                                                                    0;
                                                            return StatsCounterWidget(
                                                              hachlatacountint:
                                                                  hachlataCountsThisWeekAllHachlataTotal
                                                                      .length
                                                                      .toString(),
                                                              isclicked:
                                                                  lightGreen,
                                                            );
                                                          }
                                                          return Container();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: ListView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),

                                                          itemCount:
                                                              hachlataItemsForStats
                                                                  .length,
                                                          shrinkWrap: true,
                                                          // gridDelegate:
                                                          // const SliverGridDelegateWithFixedCrossAxisCount(
                                                          // crossAxisCount: 1,
                                                          // crossAxisSpacing: 0,
                                                          // childAspectRatio: 1,

                                                          itemBuilder:
                                                              (context, index) {
                                                            if (hachlataItemsForStats !=
                                                                    null &&
                                                                hachlataItemsForStats
                                                                        .length >
                                                                    index) {
                                                              final hachlataName =
                                                                  hachlataItemsForStats[
                                                                              index]!
                                                                          .name ??
                                                                      '';

                                                              // Retrieve the count for the hachlata name from the hachlataCounts map
                                                              int count =
                                                                  hachlataCountsThisHachlataTotal[
                                                                          hachlataName] ??
                                                                      0;

                                                              return StatsCounterWidget(
                                                                hachlatacountint:
                                                                    count
                                                                        .toString(),
                                                                isclicked:
                                                                    newpink,
                                                              );
                                                            }

                                                            // Create a tile widget for each category's name
                                                            return Container();
                                                            // return HachlataTileWidgetForStats();
                                                          },
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                        // padding: EdgeInsets.zero,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount: 1,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          if (hachlataItemsForStats !=
                                                                  null &&
                                                              hachlataItemsForStats
                                                                      .length >
                                                                  index) {
                                                            final hachlataName =
                                                                hachlataItemsForStats[
                                                                            index]!
                                                                        .name ??
                                                                    '';
                                                            int count =
                                                                hachlataCountsThisWeek[
                                                                        hachlataName] ??
                                                                    0;
                                                            return StatsCounterWidget(
                                                              hachlatacountint:
                                                                  hachlataCountsAllHachlataTotal
                                                                      .length
                                                                      .toString(),
                                                              isclicked:
                                                                  lightGreen,
                                                            );
                                                          }
                                                          return Container();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Text(
                                            //     'you have done ${hachlataItemsForStats.length.toString()} hachlatas this month'),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: ListView.builder(
                                                padding: EdgeInsets.zero,
                                                physics:
                                                    NeverScrollableScrollPhysics(),

                                                itemCount: hachlataItemsForStats
                                                    .length,
                                                shrinkWrap: true,
                                                // gridDelegate:
                                                // const SliverGridDelegateWithFixedCrossAxisCount(
                                                // crossAxisCount: 1,
                                                // crossAxisSpacing: 0,
                                                // childAspectRatio: 1,

                                                itemBuilder: (context, index) {
                                                  if (hachlataItemsForStats !=
                                                          null &&
                                                      hachlataItemsForStats
                                                              .length >
                                                          index) {
                                                    final hachlataName =
                                                        hachlataItemsForStats[
                                                                    index]!
                                                                .name ??
                                                            '';

                                                    return HachlataTileWidgetForStats(
                                                        hachlataName:
                                                            hachlataName,
                                                        isclicked:
                                                            globals.newpink);
                                                    // Pass the name
                                                  }

                                                  // Create a tile widget for each category's name
                                                  return Container();
                                                  // return HachlataTileWidgetForStats();
                                                },
                                              ),
                                            ),
                                            ListView.builder(
                                              // padding: EdgeInsets.zero,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: 1,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                if (hachlataItemsForStats !=
                                                        null &&
                                                    hachlataItemsForStats
                                                            .length >
                                                        index) {
                                                  final hachlataName =
                                                      hachlataItemsForStats[
                                                                  index]!
                                                              .name ??
                                                          '';
                                                  int count =
                                                      hachlataCountsThisWeek[
                                                              hachlataName] ??
                                                          0;
                                                  return HachlataTileWidgetForStats(
                                                      hachlataName: 'Total',
                                                      isclicked:
                                                          globals.lightGreen);
                                                }
                                                return Container();
                                              },
                                            ),
                                            // Text(
                                            //     'you have done ${hachlataItemsForStats.length.toString()} hachlatas this month'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Expanded(
                          //       child: Container(
                          //           child: HachlataTileWidget(
                          //               hachlataName: 'Total this month', isclicked: newpink)),
                          //     ),
                          //     Expanded(child: StatsCounterWidget(hachlatacountint: '1'))
                          //   ],
                          // )
                        ],
                      ),
                    );
                  }
                }
                // }
              });
        });
  }
}
//  return StreamBuilder<List<AddHachlataHomeNewTest>>(
//   stream: DatabaseService(Uid: 'test')
//       .fetchAllCollectionsData(globals.current_namesofuser),
//   builder: (context, snapshotSecond) {
//           builder: (context, snapshotSecond) {



// StreamBuilder(
//   stream: DatabaseService(Uid: 'test')
//        .fetchAllCollectionsData(globals.current_namesofuser),
//   builder: (context, snapshot1) {
    // return StreamBuilder(
    //   stream: stream2,
    //   builder: (context, snapshot2) {
//         // do some stuff with both streams here
//       },
//     );
//   },
// )