import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/app_users.dart';
import '../../../providers/general.dart';
import '../../../services/data.dart';
import '../../../shared/widgets/buttons/tab_button.dart';
import '../../../shared/widgets/tiles/general_list_tile.dart';
import '../../../types/dtos/user.dart';

class ManageUsers extends ConsumerStatefulWidget {
  ManageUsers({Key? key}) : super(key: key);

  @override
  ConsumerState<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends ConsumerState<ManageUsers>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getUsers();

      setState(() {});
    });
  }

  Future<void> getUsers() async {
    DataService dataService = DataService(ref);
    await dataService.getAllUsers();
  }

  Future<void> handleUserSwipe(User user) async {
    DataService dataService = DataService(ref);
    await dataService.acceptUser(user.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final style = ref.read(styleProvider);
    List<User> appUsers = ref.watch(appUsersProvider);

    List<User> activeUsers =
        appUsers.where((user) => user.isActive == true).toList();
    List<User> inactiveUsers =
        appUsers.where((user) => user.isActive == false).toList();

    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 24, right: 8, left: 8, bottom: 16),
              child: Text(
                'Manage Users',
                style: TextStyle(
                    color: style.themeBlack,
                    fontSize: style.titleFontSize,
                    fontWeight: style.titleFontWeight),
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomTabButton(
              title: 'Active',
              isSelected: _tabController.index == 0,
              onPressed: () => setState(() => _tabController.animateTo(0)),
            ),
            CustomTabButton(
              title: 'Waiting Room',
              isSelected: _tabController.index == 1,
              onPressed: () => setState(() => _tabController.animateTo(1)),
            ),
          ],
        ),
        Expanded(
          // Wrap TabBarView in Expanded to provide constraints
          child: TabBarView(
            controller: _tabController,
            children: [
              // Active Users Tab
              ListView.builder(
                itemCount: activeUsers.length,
                itemBuilder: (context, index) {
                  final user = activeUsers[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomListTile(
                      title:
                          "${user.contact?.firstName ?? ""} ${user.contact?.lastName ?? ""}",
                      onPressed: () {
                        // Handle tile tap
                      },
                    ),
                  );
                },
              ),
              // Waiting Room Tab
              ListView.builder(
                itemCount: inactiveUsers.length,
                itemBuilder: (context, index) {
                  final user = inactiveUsers[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomListTile(
                      title: user.username ?? 'No Name',
                      onPressed: () {
                        // Handle tile tap
                      },
                      dismissible: true,
                      onDismissed: () {
                        handleUserSwipe(user);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
