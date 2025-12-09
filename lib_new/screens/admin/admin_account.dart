import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/general.dart';
import '../../shared/widgets/tiles/general_list_tile.dart';
import 'widgets/manage_users.dart';

class AdminAccountScreen extends ConsumerStatefulWidget {
  AdminAccountScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<AdminAccountScreen> createState() => _AdminAccountScreenState();
}

class _AdminAccountScreenState extends ConsumerState<AdminAccountScreen> {
  @override
  Widget build(BuildContext context) {
    final style = ref.read(styleProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    final adminActions = [
      Padding(
        padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
        child: CustomListTile(
          title: 'Manage Users',
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              builder: (context) {
                return SizedBox(
                    height: screenHeight * 0.6,
                    child: Container(
                        decoration: BoxDecoration(
                          color: style.backgroundColor,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: ManageUsers()));
              },
            );
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
        child: CustomListTile(
          title: 'View Reports',
          onPressed: () {},
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
        child: CustomListTile(
          title: 'System Settings',
          onPressed: () {},
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
        child: CustomListTile(
          title: 'Manage hachlatas and categories',
          onPressed: () {},
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: style.backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: style.primaryColor,
        ),
        title: Text(
          'Admin',
          style: TextStyle(
            color: style.themeBlack,
            fontSize: style.titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: style.backgroundColor,
      ),
      body: ListView(
        children: adminActions,
      ),
    );
  }
}
