import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/input/input_field.dart';
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

    final adminActions = [
      CustomListTile(
        title: 'Manage Users',
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            builder: (context) {
              return FractionallySizedBox(
                heightFactor: 0.5,
                child: ManageUsers(),
              );
            },
          );
        },
      ),
      CustomListTile(
        title: 'View Reports',
        onPressed: () {},
      ),
      CustomListTile(
        title: 'System Settings',
        onPressed: () {},
      ),
      CustomListTile(
        title: 'Manage hachlatas and categories',
        onPressed: () {},
      ),
    ];

    return Scaffold(
      backgroundColor: style.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Admin',
          style: TextStyle(
            color: style.primaryColor,
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
