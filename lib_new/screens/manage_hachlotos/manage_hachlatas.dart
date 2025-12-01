import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/data.dart';
import '../../shared/widgets/input/input_field.dart';
import '../../shared/widgets/tiles/general_list_tile.dart';
import '../../providers/categories.dart';
import '../../providers/app_hachlatas.dart';
import 'widgets/hachlata_bottom_sheet.dart';

class ManageHachlatas extends ConsumerStatefulWidget {
  ManageHachlatas({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ManageHachlatas> createState() => _ManageHachlatasState();
}

class _ManageHachlatasState extends ConsumerState<ManageHachlatas> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getCategories();
      await getHachlatas();
    });
  }

  Future<void> getCategories() async {
    DataService dataService = DataService(ref);
    await dataService.getCategories();
  }

  Future<void> getHachlatas() async {
    DataService dataService = DataService(ref);
    await dataService.getAllHachlatas();
  }

  void showHachlataBottomSheet(BuildContext context, int categoryId) {
    print("categories id: $categoryId");
    final hachlatas = ref.read(appHachlatasProvider);
    final style = ref.read(styleProvider);

    // Filter hachlatas by category
    final filteredHachlatas = hachlatas
        .where((hachlata) => hachlata.category?.id == categoryId)
        .toList();

    print(filteredHachlatas);
    print(hachlatas);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => HachlataBottomSheet(
        hachlatas: filteredHachlatas,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = ref.read(styleProvider);
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.backgroundColor,
        title: Text(
          'Choose a category',
          style: TextStyle(
            color: style.themeBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: style.backgroundColor,
      body: categories.isEmpty
          ? Center(
              child: Text(
                'No categories available',
                style: TextStyle(
                  color: style.themeBlack,
                  fontSize: style.bodyFontSize,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomListTile(
                    title: category.name ?? '',
                    onPressed: () {
                      showHachlataBottomSheet(context, category.id ?? 0);
                    },
                  ),
                );
              },
            ),
    );
  }
}
