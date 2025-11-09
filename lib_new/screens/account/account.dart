import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../providers/general.dart';
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
    final AuthService _auth = AuthService();

    return Container(
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      // padding is wrong as there should never be such a big padding it should
      // be something like margin instead
      padding: const EdgeInsets.only(top: 16, bottom: 60, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: Text(
              'Welcome ${user.contact?.firstName}',
              style: TextStyle(
                color: style.themeBlack,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  title: 'Sign out',
                  onPressed: () {
                    _auth.signOut();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  title: 'Delete account',
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
