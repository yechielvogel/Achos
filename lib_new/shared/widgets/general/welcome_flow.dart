import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/style.dart';
import '../../../providers/user.dart';
import '../../../services/data.dart';
import '../../../test/hachlata_circle.dart';
import '../../../types/dtos/categories.dart';
import '../../../types/dtos/hachlata.dart';
import '../../../types/dtos/subscription.dart';
import '../buttons/custom_button.dart';

class WelcomeFlowDialog extends ConsumerStatefulWidget {
  final List<Category> categories;
  final Map<Category, List<Hachlata>> hachlatasByCategory;
  final Function(Hachlata) onComplete;

  const WelcomeFlowDialog({
    Key? key,
    required this.categories,
    required this.hachlatasByCategory,
    required this.onComplete,
  }) : super(key: key);

  @override
  ConsumerState<WelcomeFlowDialog> createState() => _WelcomeFlowDialogState();
}

class _WelcomeFlowDialogState extends ConsumerState<WelcomeFlowDialog> {
  int _currentPage = 0;
  final Map<Category, Set<Hachlata>> _completedHachlatas = {};

  @override
  void initState() {
    super.initState();
    for (final category in widget.categories) {
      _completedHachlatas[category] = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataService = DataService(ref);
    final user = ref.read(userProvider);
    final style = ref.read(appStyleProvider);

    final isWelcomePage = _currentPage == 0;
    final isLastPage = _currentPage == widget.categories.length + 1;
    final currentCategory =
        (_currentPage > 0 && _currentPage <= widget.categories.length)
            ? widget.categories[_currentPage - 1]
            : null;

    final canProceed = isWelcomePage ||
        (currentCategory != null &&
            _completedHachlatas[currentCategory]!.length >= 2) ||
        isLastPage;

    Future<void> createSubscriptions() async {
      if (_completedHachlatas.isNotEmpty) {
        for (var entry in _completedHachlatas.entries) {
          final hachlatas = entry.value.toList();

          for (final hachlata in hachlatas) {
            final subscription = Subscription(
              user: user.id ?? 0,
              dateStart: DateTime(DateTime.now().year, DateTime.now().month, 1),
              // dateEnd: DateTime.now().add(const Duration(
              //   days: 365,
              // )),
              hachlata: hachlata,
              isActive: true,
            );
            await dataService.createSubscription(subscription);
          }
        }
      }
    }

    String getTitle() {
      if (isWelcomePage) {
        return "Welcome to Achos App!";
      } else if (isLastPage) {
        return "You're all set!";
      } else {
        return "Choose at least two hachlatas from ${currentCategory?.name}:";
      }
    }

    return Dialog(
      backgroundColor: style.backgroundColor,
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
          maxHeight: 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 16.0, left: 16.0, top: 24, bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  getTitle(),
                  style: TextStyle(
                    color: style.themeBlack,
                    fontSize: 20,
                    fontWeight: style.titleFontWeight,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildContent(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          setState(() {
                            _currentPage--;
                          });
                        },
                        title: "Previous",
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 8),
                  SizedBox(width: 8),
                  Expanded(
                    child: CustomButton(
                      isOutline: !canProceed,
                      onPressed: canProceed
                          ? () async {
                              if (isLastPage) {
                                await createSubscriptions();
                                Navigator.of(context).pop();
                              } else {
                                setState(() {
                                  _currentPage++;
                                });
                              }
                            }
                          : () {},
                      title: isLastPage ? "Done" : "Next",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_currentPage == 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Some house rules...",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          _buildListItem(
              "1", "Choose at least two Hachlatas from each category."),
          const SizedBox(height: 4),
          _buildListItem("2",
              "The Hachlata is a scratch card that you reveal to mark as complete."),
          const SizedBox(height: 4),
          _buildListItem("3",
              "On the home screen, you can pinch to zoom out to view your Hachlatas by week. Pinching out further allows you to see the entire month."),
          const SizedBox(height: 4),
          _buildListItem("4",
              "Tapping the date opens the calendar view, allowing you to navigate and select different days."),
        ],
      );
    } else if (_currentPage == widget.categories.length + 1) {
      // Last "all set" page
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(right: 10, left: 10),
          child: Text(
            textAlign: TextAlign.center,
            "You’re all set! Tap ‘Done’ to head to your home screen.",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      );
    } else {
      final category = widget.categories[_currentPage - 1];
      final hachlatas = widget.hachlatasByCategory[category] ?? [];

      return hachlatas.isEmpty
          ? const Text("No hachlatas available for this category.")
          : GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: hachlatas.length,
              itemBuilder: (context, index) {
                final hachlata = hachlatas[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_completedHachlatas[category]!.contains(hachlata)) {
                        _completedHachlatas[category]!.remove(hachlata);
                      } else {
                        _completedHachlatas[category]!.add(hachlata);
                        widget.onComplete(hachlata);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: HachlataCircle(
                      hachlata: hachlata,
                      category: category,
                      completed:
                          _completedHachlatas[category]!.contains(hachlata),
                      allowInteraction: false,
                      onComplete: null,
                    ),
                  ),
                );
              },
            );
    }
  }
}

Widget _buildListItem(String number, String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("$number. ", style: const TextStyle(fontWeight: FontWeight.bold)),
      Expanded(child: Text(text)),
    ],
  );
}
