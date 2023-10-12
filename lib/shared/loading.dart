import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bage,
      child: Center(
        child: SpinKitRing(
          color: newpink,
          size: 50.0,
        ),
      ),
    );
  }
}
