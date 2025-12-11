import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/app_hachlatas.dart';
import '../../../providers/general.dart';
import '../../../providers/subscription.dart';
import '../../../test/hachlata_circle.dart';
import '../../../types/dtos/app_style.dart';
import '../../../types/dtos/categories.dart';
import '../../../types/dtos/hachlata.dart';
import 'create_hachlata.dart';
import 'create_subscription.dart';

class HachlataBottomSheet extends ConsumerStatefulWidget {
  final Category category;
  final AppStyle style;

  const HachlataBottomSheet({
    Key? key,
    required this.category,
    required this.style,
  }) : super(key: key);

  @override
  ConsumerState<HachlataBottomSheet> createState() =>
      _HachlataBottomSheetState();
}

class _HachlataBottomSheetState extends ConsumerState<HachlataBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final hachlatas = ref.watch(appHachlatasProvider);
    final subscriptions = ref.watch(subscriptionsProvider);
    final style = ref.read(styleProvider);

    final filteredHachlatas = hachlatas
        .where((hachlata) => hachlata.category == widget.category.id)
        .toList();
    final isAdmin = ref.watch(isAdminProvider);
    for (var hachlata in hachlatas) {
      print('Hachlata: ${hachlata.name}, Category: ${hachlata.category}');
    }

    Future<void> openCreateHachlataDialog(BuildContext context) async {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: widget.style.backgroundColor,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 200,
              ),
              child: CreateHachlata(
                categoryId: widget.category.id ?? 0,
              ),
            ),
          );
        },
      );
    }

    void openCreateSubscriptionDialog(BuildContext context, Hachlata hachlata) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: widget.style.backgroundColor,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 100,
              ),
              child: CreateSubscription(
                hachlata: hachlata,
              ),
            ),
          );
        },
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: widget.style.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hachlatas',
                  style: TextStyle(
                    fontSize: widget.style.titleFontSize,
                    fontWeight: widget.style.titleFontWeight,
                    color: widget.style.themeBlack,
                  ),
                ),
              ),
              isAdmin || widget.category.name == "Personal"
                  ? IconButton(
                      icon: Icon(Icons.add_circle_outline,
                          color: widget.style.primaryColor),
                      onPressed: () {
                        openCreateHachlataDialog(context);
                        // add a hachlata if admin
                      },
                    )
                  : Container(),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredHachlatas.length,
              itemBuilder: (context, index) {
                final hachlata = filteredHachlatas[index];

                // Check if there are any subscriptions for this hachlata
                final hasSubscription = subscriptions.any(
                    (subscription) => subscription.hachlata.id == hachlata.id);

                return GestureDetector(
                  onTap: () {
                    openCreateSubscriptionDialog(context, hachlata);
                  },
                  child: Container(
                    child: HachlataCircle(
                      hachlata: hachlata,
                      completed:
                          hasSubscription, // Set completed based on the subscription check
                      category: widget.category,
                      allowInteraction: false,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
