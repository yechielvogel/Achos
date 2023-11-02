import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;
import 'package:gtext/gtext.dart';
import '../models/add_hachlata_home.dart';
import '../models/ueser.dart';
import 'package:intl/intl.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({super.key, required this.onDaySelectedCallback});
  final Function(DateTime) onDaySelectedCallback;

  @override
  State<MyCalendar> createState() => MyCalendarState();
}

class MyCalendarState extends State<MyCalendar> {
  bool isPressed = false;

  // DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      JewishDate jewishDate = JewishDate(); // Create an instance
      jewishDate.setDate(day); // Set the date using a method like setDate
      globals.hebrew_focused_day = jewishDate.toString(); // today = day;
      globals.today = day;
      // print(globals.today);
      print(focusedDay);
      widget.onDaySelectedCallback(day);
    });
  }

  @override
  Widget build(BuildContext context) {
    JewishDate jewishDate = JewishDate();
    HebrewDateFormatter hebrewDateFormatter = HebrewDateFormatter();
    String hebrewDate = hebrewDateFormatter.format(jewishDate);
    String hebrewday = jewishDate.getJewishDayOfMonth().toString();
    String hebrewmonth = jewishDate.toString();
    String hebrewdaynew = '';
    // hebrewmonth = hebrewmonth.replaceAll(RegExp(r'[0-9]'), '');

    JewishDate convertToHebrewDate(DateTime gregorianDate) {
      JewishDate jewishDate = JewishDate.fromDateTime(gregorianDate);
      return jewishDate;
    }

    final focusedDate =
        DateTime(globals.today.year, globals.today.month, globals.today.day);
    globals.focused_day = focusedDate.toString();

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: globals.newpink),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TableCalendar(
              // locale: 'he',
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
                    color: globals.bage), // Change the color here
                rightChevronIcon: Icon(Icons.arrow_forward_ios,
                    color: globals.bage), // Change the color here
              ),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, globals.today),
              focusedDay: globals.today,
              calendarStyle: CalendarStyle(
                  weekendTextStyle: TextStyle(color: globals.bage),
                  outsideDaysVisible: false,
                  defaultTextStyle: TextStyle(
                    fontSize: 16.0, // Change the font size
                    color: globals.bage, // Change the text color
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors
                        .white, // Customize the background color for today
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(color: globals.doneHachlata),
                  selectedDecoration: BoxDecoration(
                    color: globals
                        .bage, // Customize the background color for selected days
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: globals.doneHachlata)),
              firstDay: DateTime.utc(2023, 07, 7),
              lastDay: DateTime.utc(2033, 07, 7),
              onDaySelected: _onDaySelected,
              calendarBuilders: CalendarBuilders(
                // todayBuilder: ,
                defaultBuilder: (context, date, events) {
                  var gregorianDate = date;

                  var jewishDate = convertToHebrewDate(gregorianDate);
                  GText('${jewishDate}', toLang: 'iw');
                  String monthName = DateFormat('MMMM').format(date);
                  var jewishdate2 = date;
                  var jewishDate1 = convertToHebrewDate(jewishdate2);
                  String hebrewmonthconvert = jewishDate1.toString();
                  hebrewmonth =
                      hebrewmonthconvert.replaceAll(RegExp(r'[0-9]'), '');
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(50),
                        // ),
                        child: Text(
                          '${jewishDate.getGregorianDayOfMonth()}',
                          style: TextStyle(fontSize: 16, color: globals.bage),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          (jewishDate.getJewishDayOfMonth() == 1)
                              ? '${hebrewmonth.toString()}'
                              : '${jewishDate.getJewishDayOfMonth()}',
                          style: TextStyle(fontSize: 8, color: globals.bage),
                        ),
                      ),
                    ],
                  );
                },
                selectedBuilder: (context, date, events) {
                  var gregorianDate = date;
                  var jewishDate = convertToHebrewDate(gregorianDate);
                  String monthName = DateFormat('MMMM').format(date);
                  var jewishdate2 = date;
                  var jewishDate1 = convertToHebrewDate(jewishdate2);
                  String hebrewmonthconvert = jewishDate1.toString();
                  hebrewmonth =
                      hebrewmonthconvert.replaceAll(RegExp(r'[0-9]'), '');

                  // isItRoshChodesh();
                  return Container(
                    margin: const EdgeInsets.only(bottom: 9.0),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),

                      color: globals
                          .bage, // Customize the background color for selected days
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.topCenter,
                          child: Text(
                            '${gregorianDate.day}',
                            style: TextStyle(
                                fontSize: 16, color: globals.doneHachlata),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            (jewishDate.getJewishDayOfMonth() == 1)
                                ? '${hebrewmonth.toString()}'
                                : '${jewishDate.getJewishDayOfMonth()}',
                            style: TextStyle(
                              fontSize: 8,
                              color: globals.doneHachlata,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                todayBuilder: (context, date, events) {
                  var gregorianDate = date;
                  String monthName = DateFormat('MMMM').format(date);
                  var jewishdate2 = date;
                  var jewishDate1 = convertToHebrewDate(jewishdate2);
                  String hebrewmonthconvert = jewishDate1.toString();
                  hebrewmonth =
                      hebrewmonthconvert.replaceAll(RegExp(r'[0-9]'), '');

                  // isItRoshChodesh();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 9.0),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),

                      color: Colors
                          .white, // Customize the background color for selected days
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.topCenter,
                          child: Text(
                            '${gregorianDate.day}',
                            style: TextStyle(
                                fontSize: 16, color: globals.doneHachlata),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            (jewishDate.getJewishDayOfMonth() == 1)
                                ? '${hebrewmonth.toString()}'
                                : '${jewishDate.getJewishDayOfMonth()}',
                            style: TextStyle(
                              fontSize: 8,
                              color: globals.doneHachlata,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                headerTitleBuilder: (context, date) {
                  String monthName = DateFormat('MMMM').format(date);
                  var jewishdate2 = date;
                  var jewishDate1 = convertToHebrewDate(jewishdate2);
                  String hebrewmonthconvert = jewishDate1.toString();
                  hebrewmonth =
                      hebrewmonthconvert.replaceAll(RegExp(r'[0-9]'), '');

                  return Center(
                    child: Text(
                      '${monthName} -${hebrewmonth.toString()}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: globals.bage),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}
