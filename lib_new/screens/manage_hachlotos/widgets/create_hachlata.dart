import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/general.dart';
import '../../../providers/user.dart';
import '../../../services/data.dart';
import '../../../shared/widgets/buttons/custom_button.dart';
import '../../../shared/widgets/input/input_field.dart';
import '../../../types/dtos/hachlata.dart';
import '../../../types/dtos/subscription.dart';

class CreateHachlata extends ConsumerStatefulWidget {
  final int categoryId;
  CreateHachlata({
    required this.categoryId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CreateHachlata> createState() => _CreateHachlataState();
}

class _CreateHachlataState extends ConsumerState<CreateHachlata> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 30));
  String hachlataName = '';
  String hachlataDescription = '';

  @override
  Widget build(BuildContext context) {
    final appStyle = ref.read(styleProvider);
    final dataService = DataService(ref);
    final user = ref.read(userProvider);

    Future<void> handleCreateHachlata() async {
      Hachlata newHachlata = Hachlata(
        school: user.school?.id ?? 0,
        name: hachlataName,
        description: hachlataDescription,
        category: widget.categoryId,
      );

      await dataService.createHachlata(newHachlata);
      // await dataService.createSubscription(subscription);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16,
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Create Hachlata',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: appStyle.themeBlack,
                    ),
                  ),
                ),
              ),
              CustomInputField(
                hintText: 'Hachlata Name',
                onChanged: (val) {
                  hachlataName = val;
                },
              ),
              SizedBox(height: 16),
              CustomInputField(
                hintText: 'Description',
                onChanged: (val) {
                  hachlataDescription = val;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: 'Cancel',
                      isOutline: true,
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      title: 'Create Hachlata',
                      onPressed: () async {
                        await handleCreateHachlata();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}
