import 'package:flutter/cupertino.dart';
import 'package:kosher_dart/kosher_dart.dart';

List<String> AdminUIDs = [
  'J2qdDlOv3Vf28QaDfwyeZdc2iQo2',
  'l7HrIm5pdTNH6cYmpYrFKlB9v4S2'
];

String hachlata_name_for_widget = '';     
String hachlata_description_for_widget = '';
String hachlata_name_for_category_widget = 'test';
String hachlata_home_doc_name = '';
String done_hachlata_doc_name = '';
String current_category = '';
String current_category_choose = '';
int current_category_choose_int = 0;     
int global_hachlata_number = 0;

String currentHachlataChooseName = '';
Color currentHachlataChooseColor = Color(0xFFCBBD7F);

String current_user = '';
String focused_day = '';
String current_namesofuser = '';
String tempuesname = '';
String displayusernameinaccount = '';
String random_notification = '';
String hebrew_focused_day = JewishDate().toString();
String hebrew_focused_month = '';
String current_chosen_hachlata_home = '';
DateTime today = DateTime.now();

List<String> allmonths = ['Cheshvan', 'Kislev', 'Teves', 'Shevat', 'Adar I', 'Adar II', 'Nissan', 'Iyar','Sivan', 'Tammuz', 'Av', 'Elul', 'Tishrei',];
List<Widget> HachlataWidgetList = [];
List<Widget> AddHachlataWidgetList = [];
List<int> selectedIndices = [];
List<Widget> HachlataCategoryWidgetList = [];
Color lightPink = Color(0xFFEBB1C5);
Color bage = Color(0xFFF3E3DF);
Color lightGreen = Color(0xFFCBBD7F);
Color doneHachlata = Color(0xFFC16C9E);
Color newpink = Color(0xFFC16C9E);

var tilecolor = lightGreen;

bool isClicked = false;
