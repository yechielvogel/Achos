import 'package:kosher_dart/kosher_dart.dart';

class Functions {
  String getHebrewDay(DateTime date) {
    final jewish = JewishDate.fromDateTime(date);
    final day = jewish.getJewishDayOfMonth();

    final hebrewNumbers = [
      "",
      "א",
      "ב",
      "ג",
      "ד",
      "ה",
      "ו",
      "ז",
      "ח",
      "ט",
      "י",
      "יא",
      "יב",
      "יג",
      "יד",
      "טו",
      "טז",
      "יז",
      "יח",
      "יט",
      "כ",
      "כא",
      "כב",
      "כג",
      "כד",
      "כה",
      "כו",
      "כז",
      "כח",
      "כט",
      "ל"
    ];

    return hebrewNumbers[day];
  }

  String getEnglishDay(DateTime date) {
    const names = {
      1: "Monday",
      2: "Tuesday",
      3: "Wednesday",
      4: "Thursday",
      5: "Friday",
      6: "Shabbos",
      7: "Sunday",
    };
    return names[date.weekday]!;
  }
}
