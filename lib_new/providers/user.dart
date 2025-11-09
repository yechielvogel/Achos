import 'package:flutter_riverpod/legacy.dart';
import '../types/dtos/user.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User());

  Future<void> setUser(User user) async {
    state = user;
  }

  void clearUser() {
    state = User();
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier());
