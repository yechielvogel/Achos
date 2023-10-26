import 'package:flutter/cupertino.dart';

class Waiting extends StatefulWidget {
  @override
  _WaitingState createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  bool voxt = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 7)),
      builder: (c, s) => s.connectionState != ConnectionState.done
          ? Text('Waiting')
          : Text('3 sec passed')
    );
  }
}