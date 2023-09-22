import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tzivos_hashem_milwaukee/models/admins.dart';
import 'package:tzivos_hashem_milwaukee/screens/authenticate/authenticate.dart';
import 'package:tzivos_hashem_milwaukee/screens/home/admin_home.dart';

import '../../models/ueser.dart';
import '../../shared/globals.dart';
import 'home.dart';
// import 'package:tzivos_hashem_milwaukee/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final admins = Provider.of<List<Admins?>?>(context);
    final user = Provider.of<Ueser?>(context);

    if (user == null) {
      return Authenticate();
    } else if (admins != null) {
      bool isAdmin = admins.any((admin) => admin?.uid == user.uid);
      if (isAdmin) {
        print('Logged in as admin ${user.uid}');
        return HomeAdmin();
      } else {
        // If user is not an admin, return regular home
        return Home(); // Change this to whatever you intend for regular users
      }
    } else
      // eventually change this to admin home else {
      print('this is ${user.uid}');
    print('name is ${user.uesname}'); // Check for the correct property name
    return Home(); // Return a default home widget if admins is null
  }
}
