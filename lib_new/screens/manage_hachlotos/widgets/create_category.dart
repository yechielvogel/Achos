import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/general.dart';
import '../../../providers/user.dart';
import '../../../services/data.dart';
import '../../../shared/widgets/buttons/custom_button.dart';
import '../../../shared/widgets/input/input_field.dart';
import '../../../types/dtos/categories.dart';

class CreateCategory extends ConsumerStatefulWidget {
  CreateCategory({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends ConsumerState<CreateCategory> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 30));
  String categoryName = '';
  String categoryColor = '';

  final List<Color> availableColors = [
    // Mint Shades
    Color(0xFFC9E4CA), // Light Mint
    Color(0xFFA8D5BA), // Slightly darker Mint

    // Pink Shades
    Color(0xFFEAD7E2), // Soft Pink
    Color(0xFFD4A5C3), // Slightly darker Pink

    // Orange Shades
    Color(0xFFFFC6A4), // Light Orange
    Color(0xFFFFA07A), // Slightly darker Orange

    // Lavender Shades
    Color(0xFFE6E6FA), // Light Lavender
    Color(0xFFD8BFD8), // Thistle

    // Blue Shades
    Color(0xFFB3E5FC), // Light Blue
    Color(0xFF81D4FA), // Sky Blue

    // Yellow Shades
    Color(0xFFFFF9C4), // Light Yellow
    Color(0xFFFFF59D), // Lemon Yellow

    // Green Shades
    Color(0xFFC8E6C9), // Light Green
    Color(0xFFA5D6A7), // Mint Green
  ];

  @override
  Widget build(BuildContext context) {
    final appStyle = ref.read(styleProvider);
    final dataService = DataService(ref);
    final user = ref.read(userProvider);

    Future<void> handleCreateCategory() async {
      Category newCategory = Category(
          name: categoryName,
          school: user.school?.id ?? 0,
          color: categoryColor);
      await dataService.createCategory(newCategory);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Create Theme',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: appStyle.themeBlack,
                    ),
                  ),
                ),
              ),
              CustomInputField(
                hintText: 'Theme Name',
                onChanged: (val) {
                  categoryName = val;
                },
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: availableColors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          categoryColor =
                              '0x${color.value.toRadixString(16).toUpperCase()}';
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: categoryColor ==
                                    '0x${color.value.toRadixString(16).toUpperCase()}'
                                ? appStyle.primaryColor
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
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
                      title: 'Create Theme',
                      onPressed: () async {
                        await handleCreateCategory();
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
