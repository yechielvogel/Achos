import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/general.dart';
import '../../services/data.dart';
import '../../shared/widgets/tiles/general_list_tile.dart';
import '../../providers/categories.dart';
import '../../providers/app_hachlatas.dart';
import 'widgets/create_category.dart';
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
    final hachlatas = ref.watch(appHachlatasProvider);
    final style = ref.read(styleProvider);

    // Filter hachlatas by category
    final filteredHachlatas =
        hachlatas.where((hachlata) => hachlata.category == categoryId).toList();

    final category = ref.watch(categoriesProvider).firstWhere(
          (cat) => cat.id == categoryId,
        );

    print(filteredHachlatas);
    print(hachlatas);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;
        return SizedBox(
          height: screenHeight * 0.8,
          child: HachlataBottomSheet(
            category: category,
            style: style,
          ),
        );
      },
    );
  }

  Future<void> openCreateCategoryDialog(BuildContext context) async {
    final style = ref.read(styleProvider);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: style.backgroundColor,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 200,
            ),
            child: CreateCategory(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = ref.read(styleProvider);
    final categories = ref.watch(categoriesProvider);
    final bool isAdmin = ref.read(isAdminProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: style.primaryColor,
        ),
        backgroundColor: style.backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              // this should be changed to category by default and use school settings
              'Choose a theme',
              style: TextStyle(
                color: style.themeBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isAdmin)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: GestureDetector(
                  onTap: () => {
                    openCreateCategoryDialog(context),
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    color: style.primaryColor,
                    size: 20,
                  ),
                ),
              ),
          ],
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
