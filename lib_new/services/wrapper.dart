import 'package:flutter/material.dart';
import '../providers/auth.dart';
import '../screens/navigation/navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth/authenticate.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;

    if (user != null) {
      print(user.email);
      return Navigation();
    } else {
      return Authenticate();
    }
  }
}
