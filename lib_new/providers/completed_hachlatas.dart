import 'package:flutter_riverpod/legacy.dart';
import '../types/dtos/hachlata.dart';
import '../types/dtos/hachlata_completed.dart';

class completedHachlatasNotifier
    extends StateNotifier<List<HachlataCompleted>> {
  completedHachlatasNotifier() : super([]);

  Future<void> addHachlata(HachlataCompleted hachlata) async {
    state = [...state, hachlata];
  }

  Future<void> removeHachlata(Hachlata hachlata) async {
    state = state.where((c) => c != hachlata).toList();
  }

  void clearHachlatas() {
    state = [];
  }

  Future<void> setHachlatas(List<HachlataCompleted> hachlatas) async {
    state = hachlatas;
  }
}

final completedHachlatasProvider =
    StateNotifierProvider<completedHachlatasNotifier, List<HachlataCompleted>>(
        (ref) => completedHachlatasNotifier());
