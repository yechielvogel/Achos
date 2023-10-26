import 'package:tzivos_hashem_milwaukee/models/add_hachlata_home.dart';
import 'package:tzivos_hashem_milwaukee/models/admins.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'hachlata_category_widget.dart';

class LeaderBoard extends StatefulWidget {
  final PageController pageController;

  LeaderBoard({required this.pageController});

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  
  @override
  Widget build(BuildContext context) {
    final leaderboard = Provider.of<List<AddHachlataHome?>?>(context);
    final admins = Provider.of<List<Admins?>?>(context);

    Map<String, int> uidCounts = {};

    for (var item in leaderboard ?? []) {
      if (item != null &&
          item.uid != 'Yechiel Vogel' &&
          !item.uid.contains('test') &&
          !admins!.any((admin) => admin?.name == item.uid)) {
        uidCounts[item.uid] = (uidCounts[item.uid] ?? 0) + 1;
      }
    }

    List<String> sortedUids = uidCounts.keys.toList()
      ..sort((a, b) => uidCounts[b]!.compareTo(uidCounts[a]!));

    return Container(
      decoration: BoxDecoration(
          color: bage,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              color: bage,
              child: Text(
                'Leader Board',
                style: TextStyle(color: newpink, fontSize: 20),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            // padding: EdgeInsets.zero,
            itemCount: sortedUids.length,
            itemBuilder: (context, index) {
              final uid = sortedUids[index];
              final count = uidCounts[uid];

              return HachlataCategoryTileWidget(
                categoryName: uid,
                // Pass count if needed: count?.toString() ?? '',
              );
            },
          ),
        ],
      ),
    );
  }
}
