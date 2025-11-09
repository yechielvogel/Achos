import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/repository.dart';
import '../providers/app_users.dart';
import '../providers/general.dart';
import '../providers/user.dart';
import '../types/dtos/school.dart';
import '../types/dtos/user.dart';

// this is a class of functions like a layer between the repo and the app

class DataService {
  final WidgetRef ref;
  final Repository repo;

  DataService(this.ref) : repo = ref.read(repositoryProvider);

  // get all users (admin)
  Future<void> getAllUsers() async {
    User currentUser = ref.read(userProvider);
    School currentSchool = currentUser.school!;
    List<User> users = await repo.getAllSchoolUsers(currentSchool.id ?? 0);
    ref.read(appUsersProvider.notifier).setAppUsers(users);
  }
}
