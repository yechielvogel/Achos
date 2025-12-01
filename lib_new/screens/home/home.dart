import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/subscription.dart';
import '../../providers/user.dart';
import '../../services/data.dart';
import '../../test/hachlata_circle.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dataService = DataService(ref);
      final userId = ref.read(userProvider).id;
      dataService.getUserSubscriptions(userId ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final subscriptions = ref.watch(subscriptionsProvider);

    final hachlatas = subscriptions.map((sub) => sub.hachlata).toList();

    return Scaffold(
      body: hachlatas.isEmpty
          ? Center(child: Text('No Hachlatas available'))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1,
                  ),
                  itemCount: hachlatas.length,
                  itemBuilder: (context, index) {
                    final hachlata = hachlatas[index];
                    return HachlataCircle(
                      key: ValueKey(hachlata.id),
                      hachlata: hachlata,
                    );
                  },
                ),
              ),
            ),
    );
  }
}
