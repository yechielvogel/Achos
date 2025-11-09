import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../input/input_field.dart';

class Loading extends ConsumerStatefulWidget {
  Loading({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<Loading> createState() => _LoadingState();
}

class _LoadingState extends ConsumerState<Loading> {
  @override
  Widget build(BuildContext context) {
    final style = ref.read(styleProvider);
    return Scaffold(
      body: Center(
          child: CircularProgressIndicator(
        color: style.primaryColor,
      )),
    );
  }
}
