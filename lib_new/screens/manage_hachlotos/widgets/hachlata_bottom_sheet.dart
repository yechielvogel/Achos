import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/general.dart';
import '../../../test/hachlata_circle.dart';
import '../../../types/dtos/app_style.dart';
import '../../../types/dtos/categories.dart';
import '../../../types/dtos/hachlata.dart';
import 'create_hachlata.dart';
import 'create_subscription.dart';

class HachlataBottomSheet extends ConsumerStatefulWidget {
  final List<Hachlata> hachlatas;
  final Category category;
  final AppStyle style;

  const HachlataBottomSheet({
    Key? key,
    required this.hachlatas,
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
    final isAdmin = ref.watch(isAdminProvider);
    for (var hachlata in widget.hachlatas) {
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
                minHeight: 200,
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
              itemCount: widget.hachlatas.length,
              itemBuilder: (context, index) {
                final hachlata = widget.hachlatas[index];
                return GestureDetector(
                  onTap: () {
                    openCreateSubscriptionDialog(context, hachlata);
                  },
                  child: Container(
                    child: HachlataCircle(
                      hachlata: hachlata,
                      completed: false,
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
