import 'dart:io';
import 'package:external_app_launcher/external_app_launcher.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/widgets/hachlata_tile_widget.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;
import '../../models/add_hachlata_home.dart';
import '../../models/add_hachlata_home_new.dart';
import '../../models/change_settings_switch.dart';
import '../../models/ueser.dart';
import '../../services/database.dart';
import '../../shared/loading.dart';
import '../../widgets/calendar.dart';
import '../../widgets/new_admin_stats.dart';
import '../../widgets/new_user_stats.dart';
import '../../widgets/settings_off_widget.dart';
import '../account_page.dart';
import '../category.dart';
import '../stats_admin_individual.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          globals.displayusernameinaccount, globals.hebrew_focused_month),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              backgroundColor: globals.bage,
              appBar: AppBar(
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
          List<AddHachlataHomeNew?> hachlataItemsForHomeNew = [];

          final hachlataHome = Provider.of<List<AddHachlataHome?>?>(context);
          void printDataFromList(List<AddHachlataHomeNew?>? dataList) {
            if (dataList == null) {}
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

          hachlataItemsForHomeNew = hachlataHomeNew?.where((item) {
                if (item != null) {
                  if (item.uid == user!.uesname) {
                    if (item.date == 'N/A') {
                      return true; 
                    }
                    final itemDate = DateTime.parse(item.date);
                    bool dateComparison = itemDate.year == focusedDate.year &&
                        itemDate.month == focusedDate.month &&
                        itemDate.day == focusedDate.day;
                    return dateComparison; 
                  }
                }

                return false;
              }).toList() ??
              [];
          hachlataHome?.forEach((item) {
            if (item != null && item.uid == globals.displayusernameinaccount) {
              AddHachlataHomeNew newItem = AddHachlataHomeNew(
                uid: item.uid,
                name: item.name,
                hebrewdate: item.hebrewdate,
                date: item.date,
                color: item.color,
              );

              
              int insertIndex = 0;
              while (insertIndex < hachlataItemsForHomeNew.length) {
                if (item.name
                        .compareTo(hachlataItemsForHomeNew[insertIndex]!.name) >
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

           
            DateTime focusedDate = DateTime(
                globals.today.year, globals.today.month, globals.today.day);

            for (AddHachlataHomeNew? item in inputList) {
              if (item != null) {
                String itemKey = '${item.name}_${item.uid}';

                if (item.date == 'N/A' && item.hebrewdate != 'N/A') {
                  if (!item.hebrewdate.contains('end')) {
                    
                    String itemDate =
                        item.hebrewdate.toString().replaceAll("Z", "");
                    DateTime globalsFocusedDate =
                        DateTime.parse(globals.focused_day);
                    if (globalsFocusedDate.isAfter(DateTime.parse(itemDate)) ||
                        globalsFocusedDate.toString() == itemDate.toString()) {
                      if (itemsMap.containsKey(itemKey) &&
                          itemsMap[itemKey]?.date == focusedDate.toString()) {
                        itemsMap.remove(itemKey);
                      }
                      itemsMap[itemKey] = item;
                    }
                  } else if (item.hebrewdate.contains('end')) {
                    String dateWithOutEnd =
                        item.hebrewdate.replaceAll(RegExp(r'end\s'), '');
                    DateTime itemDateWitchOutZ = DateTime.parse(dateWithOutEnd);
                    String itemDate =
                        itemDateWitchOutZ.toString().replaceAll("Z", "");
                    DateTime globalsFocusedDate =
                        DateTime.parse(globals.focused_day);
                    print('focused date $globalsFocusedDate');
                    print('item date $itemDate');
                    if (globalsFocusedDate.isBefore(DateTime.parse(itemDate)) ||
                        globalsFocusedDate.toString() == itemDate.toString()) {
                      if (itemsMap.containsKey(itemKey) &&
                          itemsMap[itemKey]?.date == focusedDate.toString()) {
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
                  
                  DateTime itemDate;
                  try {
                    itemDate = DateTime.parse(item.date);
                  } catch (e) {
                   
                    itemDate = DateTime(0);
                  }

                 
                  if (itemsMap.containsKey(itemKey) &&
                      itemsMap[itemKey]?.date == focusedDate.toString()) {
                    itemsMap.remove(itemKey);
                  }

                  
                  if (itemsMap.containsKey(itemKey) &&
                      itemsMap[itemKey]?.date == 'N/A') {
                    itemsMap.remove(itemKey);
                    itemsMap[itemKey] = item;
                  }

                
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
              changesettingsswitch.any((element) => element?.off == true)) {
            isSettingsOn = true;
          } else {
            isSettingsOn = false;
          }
          return Scaffold(
            backgroundColor: globals.bage,    
            appBar: AppBar(
              leading: Container(),

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
                        if (isSettingsOn) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MySettings(),
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
                        if (tilecolor == 'Color(0xFFCBBD7F);') {
                          finaltilecolor = globals.lightGreen;
                        } else {
                          finaltilecolor = globals.doneHachlata;
                        }
                        filterHachlataListNew(hachlataItemsForHomeNew);

                        return HachlataTileWidget(
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
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.person, color: Color(0xFFC16C9E)),
                    label: 'Account',
                  ),
                  BottomNavigationBarItem(
                    icon:
                        Icon(CupertinoIcons.calendar, color: Color(0xFFC16C9E)),
                    label: 'Calendar',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.chart_bar,
                      color: Color(0xFFC16C9E),
                    ),
                    label: 'Stats',
                  ),
                  //remove for android
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
                          builder: (context) => MyCalendar(
                              onDaySelectedCallback: updateGlobalsToday));
                      break;
                    case 2:
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
                            // return UserStatsAdmin();

                            return UserStats();
                            // return ThisIsNotAvailableYet();
                          });

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

  
      },
    );
  }


}

