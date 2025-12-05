import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/completed_hachlatas.dart';
import '../../providers/general.dart';
import '../../providers/style.dart';
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

    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDataForDate(ref.read(dateProvider));
    });

    // Listen for changes in dateProvider and fetch data
  }

  void _fetchDataForDate(DateTime date) {
    final dataService = DataService(ref);
    final userId = ref.read(userProvider).id;

    dataService.getUserSubscriptions(userId ?? 0, date);
    dataService.getCompletedHachlatas(userId ?? 0, date);
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = ref.watch(dateProvider);

    // Listen for changes in dateProvider
    ref.listen<DateTime>(dateProvider, (previous, next) {
      if (previous != next) {
        _fetchDataForDate(next);
      }
    });

    final subscriptions = ref.watch(subscriptionsProvider);
    final hachlatas = subscriptions.map((sub) => sub.hachlata).toList();
    final completedHachlatas = ref.watch(completedHachlatasProvider);
    final style = ref.watch(appStyleProvider);

    Future<void> handelCompleteHachlata(Hachlata hachlata) async {
      if (ref.watch(dateProvider.notifier).state.day == DateTime.now().day &&
          ref.watch(dateProvider.notifier).state.month ==
              DateTime.now().month &&
          ref.watch(dateProvider.notifier).state.year == DateTime.now().year) {
        final HachlataCompleted newHachlataCompleted = HachlataCompleted(
          hachlata: hachlata.id ?? 0,
          subscription: subscriptions
              .firstWhere((sub) => sub.hachlata.id == hachlata.id)
              .id,
          completedAt: DateTime.now(),
          user: ref.read(userProvider).id ?? 0,
        );

        final dataService = DataService(ref);
        dataService.completeHachlata(newHachlataCompleted);
      }
    }

    return Scaffold(
      backgroundColor: style.backgroundColor,
      body: hachlatas.isEmpty
          ? Center(child: Text('No Hachlatas available'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1,
                  ),
                  itemCount: hachlatas.length,
                  itemBuilder: (context, index) {
                    final hachlata = hachlatas[index];

                    return Consumer(
                      builder: (context, ref, _) {
                        final isCompleted = completedHachlatas.any(
                            (completed) =>
                                completed.hachlata == hachlata.id &&
                                completed.completedAt.day == currentDate.day &&
                                completed.completedAt.month ==
                                    currentDate.month &&
                                completed.completedAt.year == currentDate.year);
                        return HachlataCircle(
                          onComplete: () {
                            if (!isCompleted) {
                              handelCompleteHachlata(hachlata);
                            }
                          },
                          key: ObjectKey(
                            '${hachlata.id}_${hachlata}_${subscriptions.where((sub) => sub.hachlata.id == hachlata.id).first.id}',
                          ),
                          hachlata: hachlata,
                          completed: isCompleted,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
    );
  }
}
