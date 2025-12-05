import 'package:flutter/material.dart';
import '../../../test/hachlata_circle.dart';
import '../../../types/dtos/app_style.dart';
import '../../../types/dtos/hachlata.dart';
import 'create_subscription.dart';

class HachlataBottomSheet extends StatelessWidget {
  final List<Hachlata> hachlatas;
  final AppStyle style;

  const HachlataBottomSheet({
    Key? key,
    required this.hachlatas,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    for (var hachlata in hachlatas) {
      print('Hachlata: ${hachlata.name}, Category: ${hachlata.category}');
    }

    void openCreateSubscriptionDialog(BuildContext context, Hachlata hachlata) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: style.backgroundColor,
            child: CreateSubscription(
              hachlata: hachlata,
            ),
          );
        },
      );
    }

    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Hachlatas',
            style: TextStyle(
              fontSize: style.titleFontSize,
              fontWeight: FontWeight.bold,
              color: style.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: hachlatas.length,
              itemBuilder: (context, index) {
                final hachlata = hachlatas[index];
                return GestureDetector(
                  onTap: () {
                    openCreateSubscriptionDialog(context, hachlata);
                  },
                  child: Container(
                    child: HachlataCircle(hachlata: hachlata, completed: false),
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
