import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final user = Provider.of<Ueser?>(context);
    if (user == null) {
      return Authenticate();
    } else if (AdminUIDs.contains(user.uid)) {
      print('loged in as admin ${user.uid}');
      return HomeAdmin();
      // eventually change this to admin home
    } else {
      print('this is ${user.uid}');
      print('name is ${user!.uesname}');
      return Home();
    }
  }
}
