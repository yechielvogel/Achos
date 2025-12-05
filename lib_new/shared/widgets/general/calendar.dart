import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../../providers/general.dart';
import '../../helpers/functions.dart';
import '../input/input_field.dart';

class CustomCalendar extends ConsumerStatefulWidget {
  CustomCalendar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends ConsumerState<CustomCalendar> {
  bool isPressed = false;
  final Functions functions = Functions();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      JewishDate jewishDate = JewishDate();
      jewishDate.setDate(day);
      ref.watch(dateProvider.notifier).state = day;
      print(focusedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = ref.read(styleProvider);
    final focusedDate = ref.watch(dateProvider);

    JewishDate convertToHebrewDate(DateTime gregorianDate) {
      JewishDate jewishDate = JewishDate.fromDateTime(gregorianDate);
      return jewishDate;
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        color: style.backgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TableCalendar(
              rowHeight: 60,
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: style.lighterBlack),
                  weekdayStyle: TextStyle(color: style.lighterBlack)),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                    color: style.lighterBlack,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                leftChevronIcon:
                    Icon(Icons.arrow_back_ios, color: style.primaryColor),
                rightChevronIcon:
                    Icon(Icons.arrow_forward_ios, color: style.primaryColor),
              ),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, focusedDate),
              focusedDay: focusedDate,
              calendarStyle: CalendarStyle(
                  weekendTextStyle: TextStyle(color: style.lighterBlack),
                  outsideDaysVisible: false,
                  defaultTextStyle: TextStyle(
                    fontSize: 16.0,
                    color: style.lighterBlack,
                  ),
                  todayDecoration: BoxDecoration(
                    color: style.accentColor,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(color: style.primaryColor),
                  selectedDecoration: BoxDecoration(
                    color: style.lighterBlack,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: style.primaryColor)),
              firstDay: DateTime.utc(2023, 07, 7),
              lastDay: DateTime.utc(2033, 07, 7),
              onDaySelected: _onDaySelected,
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, events) {
                  var gregorianDate = date;
                  var jewishDate = convertToHebrewDate(gregorianDate);

                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Text(
                          '${jewishDate.getGregorianDayOfMonth()}',
                          style: TextStyle(
                              fontSize: 16, color: style.lighterBlack),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          functions.getHebrewDay(date),
                          style:
                              TextStyle(fontSize: 8, color: style.lighterBlack),
                        ),
                      ),
                    ],
                  );
                },
                selectedBuilder: (context, date, events) {
                  var gregorianDate = date;
                  var jewishDate = convertToHebrewDate(gregorianDate);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 9.0),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: style.primaryColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.topCenter,
                          child: Text(
                            '${gregorianDate.day}',
                            style: TextStyle(
                                fontSize: 16, color: style.backgroundColor),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            functions.getHebrewDay(date),
                            style: TextStyle(
                              fontSize: 8,
                              color: style.backgroundColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                todayBuilder: (context, date, events) {
                  var gregorianDate = date;
                  var jewishDate = convertToHebrewDate(gregorianDate);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 9.0),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: style.accentColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.topCenter,
                          child: Text(
                            '${gregorianDate.day}',
                            style: TextStyle(
                                fontSize: 16, color: style.lighterBlack),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            functions.getHebrewDay(date),
                            style: TextStyle(
                              fontSize: 8,
                              color: style.lighterBlack,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                headerTitleBuilder: (context, date) {
                  JewishDate jewishDate = JewishDate.fromDateTime(date);

                  String hebrewMonth = jewishDate.toString();
                  hebrewMonth = hebrewMonth.replaceAll(RegExp(r'[0-9]'), '');

                  String gregorianMonth = DateFormat('MMMM').format(date);

                  return Center(
                    child: Text(
                      '$gregorianMonth -$hebrewMonth',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: style.lighterBlack,
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}
