import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/models/admins.dart';
import 'package:tzivos_hashem_milwaukee/models/category.dart';
import 'package:tzivos_hashem_milwaukee/screens/authenticate/authenticate.dart';
import 'package:tzivos_hashem_milwaukee/screens/home/admin_home.dart';

import '../../models/add_hachlata_home.dart';
import '../../models/ueser.dart';
import '../../shared/globals.dart';
import '../choose_hachlatas_on_start.dart';
import '../choose_hachlatas_on_start_admin.dart.dart';
import 'home.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart' as globals;

// import 'package:tzivos_hashem_milwaukee/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final admins = Provider.of<List<Admins?>?>(context);
    final user = Provider.of<Ueser?>(context);
    final hachlatahome = Provider.of<List<AddHachlataHome?>?>(context);
    final firstcategorylist = Provider.of<List<Category?>?>(context);

    List<AddHachlataHome?> istherehachlatas = [];

    istherehachlatas = hachlatahome?.where((item) {
          if (item != null) {
            // Check if the UID matches the user's username
            return item.uid == user?.uesname;
          }
          // Return false for items that are null
          return false;
        }).toList() ??
        [];
    if (user == null) {
      return Authenticate();
    }
    if (admins != null) {
      bool isAdmin = admins.any((admin) => admin?.uid == user.uid);
      if (isAdmin) {
        displayusernameinaccount = user.uesname!;
        if (firstcategorylist != null) {
          if (istherehachlatas.length != 0 &&
              istherehachlatas.length > firstcategorylist.length) {
            print('admin is there hachlatas${istherehachlatas.length}');
            return HomeAdmin();
          }
          if (istherehachlatas.length == 0 ||
              istherehachlatas.length < firstcategorylist.length) {
            globals.current_category_choose = firstcategorylist.first!.name;
            print(istherehachlatas.length);
            print(globals.current_category_choose);
            return ChooseHachlataOnStartAdmin();

            // print('Logged in as admin ${user.uid}');
          }
        } else
          print('return home admin line 63');
        return HomeAdmin();
      }
    }
    if (firstcategorylist != null) {
      displayusernameinaccount = user.uesname!;
      if (istherehachlatas.length != 0 &&
          istherehachlatas.length > firstcategorylist.length) {
        return Home();
      }
      if (istherehachlatas.length == 0 ||
          istherehachlatas.length < firstcategorylist.length) {
        globals.current_category_choose = firstcategorylist.first!.name;
        print('none admin is there hachlatas ${istherehachlatas.length}');
        print(globals.current_category_choose);
        return ChooseHachlataOnStart();
      } else
        return Home();
    } else
      displayusernameinaccount = user.uesname!;
    print('else');
    return Home();
  }
}

// print('Logged in as admin ${user.uid}');
// return HomeAdmin();

// } else {
//   // If user is not an admin, return regular home
//   return Home(); // Change this to whatever you intend for regular users
// }

// // eventually change this to admin home else {
// print('this is ${user.uid}');
// print('name is ${user.uesname}'); // Check for the correct property name
// return Home(); // Return a default home widget if admins is null
