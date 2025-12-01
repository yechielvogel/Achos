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
  DateTime? startDate;
  DateTime? endDate;

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
          Text(
            'Create Subscription',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: appStyle.themeBlack,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Start Date Picker
                Text(
                  'Start Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: appStyle.themeBlack,
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
                Text(
                  'End Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: appStyle.themeBlack,
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (date) {
                      setState(() {
                        endDate = date;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
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
