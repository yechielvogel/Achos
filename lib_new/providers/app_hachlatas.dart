import 'package:flutter_riverpod/legacy.dart';
import '../types/dtos/hachlata.dart';

class AppHachlatasNotifier extends StateNotifier<List<Hachlata>> {
  AppHachlatasNotifier() : super([]);

  Future<void> addHachlata(Hachlata hachlata) async {
    state = [...state, hachlata];
  }

  Future<void> removeHachlata(Hachlata hachlata) async {
    state = state.where((c) => c != hachlata).toList();
  }

  void clearHachlatas() {
    state = [];
  }

  void setHachlatas(List<Hachlata> hachlata) {
    state = hachlata;
  }
}

final appHachlatasProvider =
    StateNotifierProvider<AppHachlatasNotifier, List<Hachlata>>(
        (ref) => AppHachlatasNotifier());
