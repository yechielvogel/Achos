import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/general.dart';
import '../../providers/user.dart';
import '../../services/auth/auth.dart';
import '../../shared/widgets/buttons/theme_button.dart';
import '../../shared/widgets/input/input_field.dart';

class AccountScreen extends ConsumerStatefulWidget {
  AccountScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final style = ref.read(styleProvider);
    final user = ref.watch(userProvider);
    final repo = ref.read(repositoryProvider);
    final AuthService _auth = AuthService();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome ${user.contact?.firstName}',
              style: TextStyle(
                color: style.tertiaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomButton(
                  title: 'Sign out',
                  onPressed: () {
                    _auth.signOut();
                  },
                  height: 50,
                  width: 150,
                ),
                const SizedBox(width: 16),
                CustomButton(
                  title: 'Delete account',
                  onPressed: () {},
                  height: 50,
                  width: 150,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
