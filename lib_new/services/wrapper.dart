import 'package:flutter/material.dart';
import '../api/repository.dart';
import '../providers/auth.dart';
import '../providers/user.dart';
import '../screens/navigation/navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../types/dtos/user.dart';
import 'auth/authenticate.dart';

class Wrapper extends ConsumerStatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<Wrapper> {
  bool initialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeData();

      // This kicks off the worker, which will update ordersLoadingProvider
      // No need to manually set loading here
      setState(() {
        initialized = true;
      });
    });
  }

  Future<void> _initializeData() async {
    Repository _repository = Repository();

    final user = ref.watch(authStateProvider).value;

    User userTest = await _repository.getUserInfo(user?.uid ?? '');
    ref.read(userProvider.notifier).setUser(userTest);

    print("user is ${ref.watch(userProvider).contact?.firstName}");
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;

    if (user != null) {
      print(user.email);
      return Navigation();
    } else {
      return Authenticate();
    }
  }
}
