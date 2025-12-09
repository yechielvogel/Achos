import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/categories.dart';
import '../../providers/completed_hachlatas.dart';
import '../../providers/general.dart';
import '../../providers/style.dart';
import '../../providers/subscription.dart';
import '../../providers/user.dart';
import '../../services/data.dart';
import '../../test/hachlata_circle.dart';
import '../../types/dtos/hachlata.dart';
import '../../types/dtos/hachlata_completed.dart';

enum ZoomLevel { day, week, month }

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  double _zoom = 1.3;
  double _baseZoom = 1.3;

  static const double _dayScale = 1.3;
  static const double _weekScale = 1.0;
  static const double _monthScale = 0.85;

  ZoomLevel currentZoomLevel = ZoomLevel.day;

  int _columnsForZoom(ZoomLevel level) {
    switch (level) {
      case ZoomLevel.day:
        return 2;
      case ZoomLevel.week:
        return 3;
      case ZoomLevel.month:
        return 5;
    }
  }

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(currentStartDateProvider.notifier).state = today;
      ref.read(currentEndDateProvider.notifier).state = today;

      final startOfMonth = DateTime(today.year, today.month, 1);
      final endOfMonth = DateTime(today.year, today.month + 1, 0);

      await _fetchDataForDate(startOfMonth, endOfMonth);
    });
  }

  Future<void> _fetchDataForDate(DateTime start, DateTime end) async {
    final dataService = DataService(ref);
    final userId = ref.read(userProvider).id;

    await dataService.getCategories();
    await dataService.getUserSubscriptions(userId ?? 0, start, end);
    await dataService.getCompletedHachlatas(userId ?? 0, start, end);
  }

  Map<DateTime, List<Hachlata>> _filterHachlatasByRange(
      DateTime start, DateTime end) {
    final allSubs = ref.watch(subscriptionsProvider);
    Map<DateTime, List<Hachlata>> map = {};

    for (int i = 0; i <= end.difference(start).inDays; i++) {
      final day = start.add(Duration(days: i));

      final hachlatasForDay = allSubs
          .where((sub) =>
              (day.isAfter(sub.dateStart) ||
                  day.isAtSameMomentAs(sub.dateStart)) &&
              (sub.dateEnd == null ||
                  day.isBefore(sub.dateEnd!) ||
                  day.isAtSameMomentAs(sub.dateEnd!)))
          .map((sub) => sub.hachlata)
          .toList();

      map[day] = hachlatasForDay;
    }

    return map;
  }

  Map<DateTime, List<HachlataCompleted>> _filterCompletedHachlatasByRange(
      DateTime start, DateTime end) {
    final allCompleted = ref.watch(completedHachlatasProvider);
    Map<DateTime, List<HachlataCompleted>> map = {};

    for (int i = 0; i <= end.difference(start).inDays; i++) {
      final day = start.add(Duration(days: i));

      map[day] = allCompleted
          .where((completed) =>
              completed.completedAt.day == day.day &&
              completed.completedAt.month == day.month &&
              completed.completedAt.year == day.year)
          .toList();
    }

    return map;
  }

  Future<void> handelCompleteHachlata(Hachlata hachlata, DateTime day) async {
    if (ref.watch(dateProvider).day == day.day &&
        ref.watch(dateProvider).month == day.month &&
        ref.watch(dateProvider).year == day.year) {
      final allSubsForDay = ref
          .watch(subscriptionsProvider)
          .where((sub) =>
              sub.hachlata.id == hachlata.id &&
              (day.isAfter(sub.dateStart) ||
                  day.isAtSameMomentAs(sub.dateStart)) &&
              (day.isBefore(sub.dateEnd!) ||
                  day.isAtSameMomentAs(sub.dateEnd!)))
          .toList();

      if (allSubsForDay.isEmpty) return;

      final newHachlataCompleted = HachlataCompleted(
        hachlata: hachlata.id ?? 0,
        subscription: allSubsForDay.first.id,
        completedAt: day,
        user: ref.read(userProvider).id ?? 0,
      );

      final dataService = DataService(ref);
      dataService.completeHachlata(newHachlataCompleted);
    } else {
      setState(() {});
      ref.read(errorProvider.notifier).state =
          "Cannot complete hachlata for a different day than today.";
    }
  }

  void _applyZoomLevelToDateRange(ZoomLevel level) {
    final today = ref.watch(dateProvider);

    if (level == ZoomLevel.day) {
      ref.read(currentStartDateProvider.notifier).state = today;
      ref.read(currentEndDateProvider.notifier).state = today;
    } else if (level == ZoomLevel.week) {
      final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      ref.read(currentStartDateProvider.notifier).state = startOfWeek;
      ref.read(currentEndDateProvider.notifier).state =
          startOfWeek.add(Duration(days: 6));
    } else {
      final startOfMonth = DateTime(today.year, today.month, 1);
      ref.read(currentStartDateProvider.notifier).state = startOfMonth;
      ref.read(currentEndDateProvider.notifier).state =
          DateTime(today.year, today.month + 1, 0);
    }
  }

  void _snapToZoomLevel(ZoomLevel level) {
    final target = (level == ZoomLevel.day)
        ? _dayScale
        : (level == ZoomLevel.week)
            ? _weekScale
            : _monthScale;

    setState(() {
      _zoom = target;
      _baseZoom = target;
      currentZoomLevel = level;
    });

    ref.read(currentZoomLevelProvider.notifier).state = level;
    _applyZoomLevelToDateRange(level);
  }

  ZoomLevel _nextLevelOnZoomOut(ZoomLevel current) {
    switch (current) {
      case ZoomLevel.day:
        return ZoomLevel.week;
      case ZoomLevel.week:
        return ZoomLevel.month;
      case ZoomLevel.month:
        return ZoomLevel.month;
    }
  }

  ZoomLevel _prevLevelOnZoomIn(ZoomLevel current) {
    switch (current) {
      case ZoomLevel.day:
        return ZoomLevel.day;
      case ZoomLevel.week:
        return ZoomLevel.day;
      case ZoomLevel.month:
        return ZoomLevel.week;
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentStartDate = ref.watch(currentStartDateProvider);
    var currentEndDate = ref.watch(currentEndDateProvider);
    final categories = ref.watch(categoriesProvider);
    final style = ref.watch(appStyleProvider);

    var filteredHachlatasByDay =
        _filterHachlatasByRange(currentStartDate, currentEndDate);
    var filteredCompletedByDay =
        _filterCompletedHachlatasByRange(currentStartDate, currentEndDate);

    return Scaffold(
      backgroundColor: style.backgroundColor,
      body: GestureDetector(
        onScaleStart: (_) {
          _baseZoom = _zoom;
        },
        onScaleUpdate: (details) {
          setState(() {
            _zoom = (_baseZoom * details.scale).clamp(_monthScale, _dayScale);
          });
        },
        onScaleEnd: (details) {
          final delta = _zoom - _baseZoom;

          if (delta.abs() < 0.03) return;

          if (delta > 0) {
            _snapToZoomLevel(_prevLevelOnZoomIn(currentZoomLevel));
          } else {
            _snapToZoomLevel(_nextLevelOnZoomOut(currentZoomLevel));
          }
        },
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return child!;
          },
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),

            // physics: currentZoomLevel == ZoomLevel.day
            //     ? NeverScrollableScrollPhysics()
            //     : BouncingScrollPhysics(),
            slivers: filteredHachlatasByDay.entries
                .where((entry) => entry.value.isNotEmpty)
                .expand((entry) {
              final day = entry.key;
              final hachlatas = entry.value;
              final completedForDay = filteredCompletedByDay[day] ?? [];

              final crossAxisCount = _columnsForZoom(currentZoomLevel);
              final screenWidth = MediaQuery.of(context).size.width;
              final spacing = currentZoomLevel == ZoomLevel.day ? 20 : 16;

              final baseTileWidth =
                  (screenWidth - spacing * (crossAxisCount - 1) - 32) /
                      crossAxisCount;
              final tileWidth = baseTileWidth;
              final tileHeight = baseTileWidth;
              final childAspectRatio = tileWidth / tileHeight;
              final tileSize =
                  100.0 * (currentZoomLevel == ZoomLevel.day ? 1.3 : 1.0);

              return [
                if (currentZoomLevel != ZoomLevel.day)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        "${day.day}/${day.month}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final hachlata = hachlatas[index];
                        final isCompleted = completedForDay
                            .any((c) => c.hachlata == hachlata.id);

                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          child: HachlataCircle(
                            key: ValueKey('${hachlata.id}-$isCompleted'),
                            hachlata: hachlata,
                            completed: isCompleted,
                            category: categories.firstWhere(
                                (cat) => cat.id == hachlata.category),
                            scale:
                                currentZoomLevel == ZoomLevel.day ? 1.3 : 1.0,
                            radius: tileSize / 2, // <-- pass actual radius here
                            onComplete: () {
                              if (!isCompleted)
                                handelCompleteHachlata(hachlata, day);
                            },
                            allowInteraction: currentZoomLevel == ZoomLevel.day
                                ? true
                                : false,
                          ),
                        );
                      },
                      childCount: hachlatas.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: spacing.toDouble(),
                      crossAxisSpacing: spacing.toDouble(),
                      childAspectRatio: childAspectRatio,
                    ),
                  ),
                ),
              ];
            }).toList(),
          ),
        ),
      ),
    );
  }
}
