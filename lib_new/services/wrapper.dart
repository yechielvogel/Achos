import 'package:flutter/material.dart';
import '../api/repository.dart';
import '../providers/auth.dart';
import '../providers/general.dart';
import '../providers/user.dart';
import '../screens/navigation/navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shared/widgets/buttons/custom_button.dart';
import 'auth/auth.dart';
import 'auth/authenticate.dart';

class Wrapper extends ConsumerStatefulWidget {
  const Wrapper({super.key});

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
      if (mounted) setState(() => initialized = true);
    });
  }

  Future<void> _initializeData() async {
    final firebaseUser = ref.read(authStateProvider).value;

    if (firebaseUser == null) return;

    try {
      final localUser = await Repository().getUserInfo(firebaseUser.uid);
      await ref.read(userProvider.notifier).setUser(localUser);
      ref.read(generalLoadingProvider.notifier).state = false;
      print("Local user loaded: ${localUser.contact?.firstName}");
    } catch (e, stack) {
      print('Error fetching local user: $e');
      print(stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = ref.watch(authStateProvider).value;
    final localUser = ref.watch(userProvider);
    final style = ref.read(styleProvider);
    final AuthService _auth = AuthService();

    if (firebaseUser == null) return const Authenticate();

    if (!initialized || localUser.id == null) {
      // need to look over this again as not sure we need this really
      try {
        _initializeData();
      } catch (e) {
        print('Error during initialization: $e');
      }
    }

    if (localUser.isActive == true) return Navigation();

    // need to make a waiting room screen and a update app screen and maybe more
    return Scaffold(
      backgroundColor: style.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: SizedBox(
              width: 400,
              child: Center(
                  child: Text(
                      textAlign: TextAlign.center,
                      "Your account isn’t active yet. Please wait for an admin to approve your access.")),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: SizedBox(
              width: 100,
              child: CustomButton(
                title: 'Logout',
                onPressed: () async {
                  await _auth.signOut(ref);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
