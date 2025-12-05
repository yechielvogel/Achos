import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kosher_dart/kosher_dart.dart';
import '../../providers/general.dart';
import '../../providers/user.dart';
import '../../shared/helpers/functions.dart';
import '../../shared/widgets/general/calendar.dart';
import '../../types/dtos/app_style.dart';
import '../account/account.dart';
import '../admin/admin_account.dart';
import '../home/home.dart';
import '../manage_hachlotos/manage_hachlatas.dart';

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

  Future<void> _changeDate(int days) async {
    setState(() {
      final currentDate = ref.read(dateProvider);
      final newDate = currentDate.add(Duration(days: days));
      ref.read(dateProvider.notifier).state = newDate;
    });
  }

  List<BottomNavigationBarItem> _getBottomNavItems(int index) {
    final style = ref.read(styleProvider);

    return [
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 2, top: 4),
          child: Icon(
            index == 0 ? Icons.home_filled : Icons.home,
            color: index == 0 ? style.themeBlack : style.lighterBlack,
          ),
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 2, top: 4),
          child: Icon(
            index == 1 ? Icons.person : Icons.person_outline,
            color: index == 1 ? style.themeBlack : style.lighterBlack,
          ),
        ),
        label: 'Account',
      ),
    ];
  }

  List<AppBar> _buildAppBars(WidgetRef ref) {
    final style = ref.read(styleProvider);

    return screens.map((screen) {
      if (screen is HomeScreen) {
        return AppBar(
          backgroundColor: style.backgroundColor,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async => await _changeDate(-1),
                child: Icon(Icons.arrow_back_ios, color: style.primaryColor),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (context) => CustomCalendar(),
                  );
                },
                child: Text(
                  "${Functions().getEnglishDay(ref.watch(dateProvider))} ${Functions().getHebrewDay(ref.watch(dateProvider))}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ref.watch(dateProvider).day == DateTime.now().day
                        ? style.primaryColor
                        : style.themeBlack,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _changeDate(1),
                child: Icon(Icons.arrow_forward_ios, color: style.primaryColor),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add_circle_rounded, color: style.primaryColor),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ManageHachlatas()),
                );
              },
            ),
          ],
        );
      }

      if (screen is AccountScreen) {
        return AppBar(
          backgroundColor: style.backgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Account",
            style: TextStyle(
              color: style.themeBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }

      return AppBar(
        backgroundColor: style.backgroundColor,
        elevation: 0,
        title: const Text(""),
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
            fontWeight: FontWeight.bold,
            color: style.themeBlack,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 13,
            color: style.lighterBlack,
          ),
          selectedItemColor: style.themeBlack,
          unselectedItemColor: style.lighterBlack,
          backgroundColor: style.backgroundColor,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) {
            if (index == 1) {
              if (isAdmin) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AdminAccountScreen(),
                  ),
                );
              } else {
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
