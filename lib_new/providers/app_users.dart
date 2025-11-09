import 'package:flutter_riverpod/legacy.dart';
import '../types/dtos/user.dart';

class AppUsersNotifier extends StateNotifier<List<User>> {
  AppUsersNotifier() : super([]);

  void setAppUsers(List<User> users) {
    state = users;
  }

  void addUser(User user) {
    state = [...state, user];
  }

  void removeUser(User user) {
    state = state.where((u) => u != user).toList();
  }

  void clearAppUsers() {
    state = [];
  }
}

final appUsersProvider = StateNotifierProvider<AppUsersNotifier, List<User>>(
    (ref) => AppUsersNotifier());
