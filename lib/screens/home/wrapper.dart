import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
// class Wrapper extends StatelessWidget {
//   const Wrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<Ueser?>(context);
//     if (user == null) {
//       return Authenticate();
//     } else if (AdminUIDs.contains(user.uid)) {
//       print('loged in as admin ${user.uid}');
//       return HomeAdmin();
//       // eventually change this to admin home
//     } else {
//       print('this is ${user.uid}');
//       print('name is ${user!.uesname}');
//       return Home();
//     }
//   }
// }
class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve data from providers
    final admins = Provider.of<List<Admins?>?>(context);
    // final user = Provider.of<Ueser?>(context);
    var user = Provider.of<Ueser?>(context);
    final hachlatahome = Provider.of<List<AddHachlataHome?>?>(context);
    final firstcategorylist = Provider.of<List<Category?>?>(context);
    // Check if user is null or if user's username is null
    if (user == null) {
      print(user?.uesname); // Debug print if user is null or username is null
      return Authenticate();
    } else {
      // user.uesname = 'test';
      // If admins list is not null, check if user is an admin
      if (admins != null) {
        bool isAdmin = admins.any((admin) => admin?.uid == user.uid);
        if (isAdmin) {
          displayusernameinaccount = user.uesname!;
          return HomeAdmin();
        }
      }

      // If user is not an admin or admins list is null, proceed to Home
      print(user.uesname); // Debug print
      print(user.uid); // Debug print
      displayusernameinaccount = user.uesname!;
      return Home();
    }
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
