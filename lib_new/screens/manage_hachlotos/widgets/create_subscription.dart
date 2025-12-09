import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/cupertino.dart';

import '../../../providers/general.dart';
import '../../../providers/user.dart';
import '../../../services/data.dart';
import '../../../shared/widgets/buttons/custom_button.dart';
import '../../../shared/widgets/input/input_field.dart';
import '../../../types/dtos/hachlata.dart';
import '../../../types/dtos/subscription.dart';

class CreateSubscription extends ConsumerStatefulWidget {
  final Hachlata hachlata;

  const CreateSubscription({
    Key? key,
    required this.hachlata,
  }) : super(key: key);

  @override
  ConsumerState<CreateSubscription> createState() => _CreateSubscriptionState();
}

class _CreateSubscriptionState extends ConsumerState<CreateSubscription> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 30));

  @override
  Widget build(BuildContext context) {
    final appStyle = ref.read(styleProvider);
    final dataService = DataService(ref);

    Future<void> handleCreateSubscription() async {
      final currentUser = ref.read(userProvider);
      final subscription = Subscription(
        user: currentUser.id ?? 0,
        dateStart: startDate!,
        dateEnd: endDate,
        hachlata: widget.hachlata,
        isActive: true,
      );

      await dataService.createSubscription(subscription);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Create Subscription',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: appStyle.themeBlack,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Start Date Picker
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Start Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: appStyle.subtitleFontWeight,
                      color: appStyle.themeBlack,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (date) {
                    setState(() {
                      startDate = date;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              // End Date Picker
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 16),
                  child: Text(
                    'End Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: appStyle.subtitleFontWeight,
                      color: appStyle.themeBlack,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime.now().add(const Duration(days: 30)),
                  onDateTimeChanged: (date) {
                    setState(() {
                      endDate = date;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  isOutline: true,
                  title: 'Cancel',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  title: 'Create',
                  onPressed: () async {
                    if (startDate == null || endDate == null) {
                      // Show error if dates are not selected
                      print('Please select both start and end dates.');
                      setState(() {
                        ref.read(errorProvider.notifier).state =
                            'Please select both start and end dates.';
                      });

                      return;
                    }
                    if (startDate!.isAfter(endDate!)) {
                      // Show error if start date is after end date
                      print('Start date must be before or equal to end date.');
                      setState(() {
                        ref.read(errorProvider.notifier).state =
                            'Start date must be before or equal to end date.';
                      });

                      return;
                    }
                    try {
                      handleCreateSubscription();

                      Navigator.of(context).pop();
                      print('Subscription created successfully!');
                    } catch (e) {
                      print('Failed to create subscription: $e');
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
