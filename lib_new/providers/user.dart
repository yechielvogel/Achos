import 'package:flutter_riverpod/legacy.dart';
import '../types/dtos/user.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User());

  void setUser(User user) {
    state = user;
  }

  void clearUser() {
    state = User();
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier());
