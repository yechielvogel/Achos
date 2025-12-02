import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/completed_hachlatas.dart';
import '../../providers/subscription.dart';
import '../../providers/user.dart';
import '../../services/data.dart';
import '../../test/hachlata_circle.dart';
import '../../types/dtos/hachlata.dart';
import '../../types/dtos/hachlata_completed.dart';

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
      // this should eventually be from the calendar or something
      // final today = DateTime.now().add(const Duration(days: 1));
      final today = DateTime.now();
      final dataService = DataService(ref);
      final userId = ref.read(userProvider).id;
      dataService.getUserSubscriptions(userId ?? 0, today);
      dataService.getCompletedHachlatas(userId ?? 0, today);
    });
  }

  @override
  Widget build(BuildContext context) {
    DataService dataService = DataService(ref);
    final subscriptions = ref.watch(subscriptionsProvider);
    final hachlatas = subscriptions.map((sub) => sub.hachlata).toList();
    final completedHachlatas = ref.watch(completedHachlatasProvider);

    Future<void> handelCompleteHachlata(Hachlata hachlata) async {
      HachlataCompleted newHachlataCompleted = HachlataCompleted(
        hachlata: hachlata.id ?? 0,
        subscription: subscriptions
            .firstWhere((sub) => sub.hachlata.id == hachlata.id)
            .id,
        completedAt: DateTime.now(),
        user: ref.read(userProvider).id ?? 0,
      );

      dataService.completeHachlata(newHachlataCompleted);
    }

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
                    final isCompleted = completedHachlatas.any(
                      (completed) => completed.hachlata == hachlata.id,
                    );

                    return HachlataCircle(
                      onComplete: () {
                        if (!isCompleted) {
                          handelCompleteHachlata(hachlata);
                        }
                      },
                      key: ValueKey(hachlata.id),
                      hachlata: hachlata,
                      completed: isCompleted,
                    );
                  },
                ),
              ),
            ),
    );
  }
}
