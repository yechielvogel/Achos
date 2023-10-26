import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart';

class StatsCounterWidget extends StatefulWidget {
  final String hachlatacountint;
  final isclicked;
  const StatsCounterWidget(
      {super.key, required this.hachlatacountint, required this.isclicked});

  @override
  State<StatsCounterWidget> createState() => _StatsCounterWidgetState();
}

class _StatsCounterWidgetState extends State<StatsCounterWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8),
      child: Container(
        height: 58,
        child: CircleAvatar(
            backgroundColor: widget.isclicked,
            // radius: 15,
            child: Center(
              child: Text(
                widget.hachlatacountint,
                style: TextStyle(color: bage, fontSize: 10),
              ),
            )),
      ),
    );
  }
}
