import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/repository.dart';
import '../../../providers/app_users.dart';
import '../../../providers/general.dart';
import '../../../providers/user.dart';
import '../../../services/data.dart';
import '../../../shared/widgets/buttons/tab_button.dart';
import '../../../shared/widgets/tiles/general_list_tile.dart';
import '../../../types/dtos/school.dart';
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

  @override
  Widget build(BuildContext context) {
    // need to find a better way than to do this twice
    List<User> appUsers = ref.watch(appUsersProvider);

    List<User> activeUsers =
        appUsers.where((user) => user.isActive == true).toList();
    List<User> inactiveUsers =
        appUsers.where((user) => user.isActive == false).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            CustomTabButton(
              title: 'Active',
              isSelected: _tabController.index == 0,
              onPressed: () => _tabController.animateTo(0),
            ),
            CustomTabButton(
              title: 'Waiting Room',
              isSelected: _tabController.index == 1,
              onPressed: () => _tabController.animateTo(1),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active Users Tab
          ListView.builder(
            itemCount: activeUsers.length,
            itemBuilder: (context, index) {
              final user = activeUsers[index];
              return CustomListTile(
                title: user.username ?? 'No Name',
                onPressed: () {
                  // Handle tile tap
                },
              );
            },
          ),
          // Waiting Room Tab
          ListView.builder(
            itemCount: inactiveUsers.length,
            itemBuilder: (context, index) {
              final user = inactiveUsers[index];
              return CustomListTile(
                title: user.username ?? 'No Name',
                onPressed: () {
                  // Handle tile tap
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
