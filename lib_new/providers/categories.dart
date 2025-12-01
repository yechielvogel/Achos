import 'package:flutter_riverpod/legacy.dart';

import '../types/dtos/categories.dart';

class CategoriesNotifier extends StateNotifier<List<Category>> {
  CategoriesNotifier() : super([]);

  Future<void> addCategory(Category category) async {
    state = [...state, category];
  }

  Future<void> removeCategory(Category category) async {
    state = state.where((c) => c != category).toList();
  }

  void clearCategories() {
    state = [];
  }

  void setCategories(List<Category> categories) {
    state = categories;
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<Category>>(
        (ref) => CategoriesNotifier());
