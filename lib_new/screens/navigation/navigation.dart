import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../types/dtos/app_style.dart';
import '../account/account.dart';
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
              color: index == 0 ? style.primaryColor : style.accentColor),
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 2, top: 4),
          child: Icon(CupertinoIcons.person,
              color: index == 1 ? style.primaryColor : style.accentColor),
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
            color: style.secondaryColor,
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

    return Scaffold(
      appBar: appBars[currentIndex],
      body: screens[currentIndex],
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Theme buildBottomNavigationBar() {
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
            color: style.primaryColor,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 13,
            color: style.accentColor,
          ),
          selectedItemColor: style.primaryColor,
          unselectedItemColor: style.accentColor,
          backgroundColor: style.backgroundColor,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) {
            setState(() {
              currentIndex = index;
              bottomNavItems = _getBottomNavItems(currentIndex);
            });
          },
          items: bottomNavItems,
        ),
      ),
    );
  }
}
