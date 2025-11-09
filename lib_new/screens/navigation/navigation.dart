import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/general.dart';
import '../../providers/user.dart';
import '../../types/dtos/app_style.dart';
import '../account/account.dart';
import '../admin/admin_account.dart';
import '../home/home.dart';

class Navigation extends ConsumerStatefulWidget {
  Navigation({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _NavigationState();
}

class _NavigationState extends ConsumerState<Navigation> {
  int currentIndex = 0;

  late final List<Widget> screens;
  late List<BottomNavigationBarItem> bottomNavItems;
  final styleProvider = Provider<AppStyle>((ref) => AppStyle.defaultStyle());

  @override
  void initState() {
    super.initState();

    screens = [
      HomeScreen(key: UniqueKey()),
      AccountScreen(key: UniqueKey()),
    ];

    bottomNavItems = _getBottomNavItems(currentIndex);
  }

  List<BottomNavigationBarItem> _getBottomNavItems(int index) {
    final style = ref.read(styleProvider);

    return [
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 2, top: 4),
          child: Icon(CupertinoIcons.home,
              color: index == 0 ? style.themeBlack : style.buttonBorderColor),
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 2, top: 4),
          child: Icon(CupertinoIcons.person,
              color: index == 1 ? style.themeBlack : style.buttonBorderColor),
        ),
        label: 'Account',
      ),
    ];
  }

  List<AppBar> _buildAppBars(WidgetRef ref) {
    final style = ref.read(styleProvider);
    return screens.map((screen) {
      String title = '';
      List<Widget> actions = [];

      if (screen is HomeScreen) {
        title = 'Home';
      }
      if (screen is AccountScreen) {
        title = 'Account';
      }

      return AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: style.backgroundColor,
        title: Text(
          title,
          style: TextStyle(
            color: style.themeBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: actions,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appBars = _buildAppBars(ref);

    final bool isAdmin = ref.read(isAdminProvider);

    return Scaffold(
      appBar: appBars[currentIndex],
      body: screens[currentIndex],
      bottomNavigationBar: buildBottomNavigationBar(isAdmin),
    );
  }

  Theme buildBottomNavigationBar(bool isAdmin) {
    final style = ref.read(styleProvider);

    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Material(
        elevation: 4.0,
        shadowColor: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedLabelStyle: TextStyle(
            fontSize: 13,
            color: style.themeBlack,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 13,
            color: style.buttonBorderColor,
          ),
          selectedItemColor: style.themeBlack,
          unselectedItemColor: style.buttonBorderColor,
          backgroundColor: style.backgroundColor,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) {
            if (index == 1) {
              if (isAdmin) {
                // Navigate to AdminAccountScreen if the user is an admin
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AdminAccountScreen(),
                  ),
                );
              } else {
                // If the user is not an admin, show the Account screen in a modal
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  context: context,
                  builder: (context) => AccountScreen(),
                );
              }
            } else {
              // Navigate to the selected screen
              setState(() {
                currentIndex = index;
                bottomNavItems = _getBottomNavItems(currentIndex);
              });
            }
          },
          items: bottomNavItems,
        ),
      ),
    );
  }
}
