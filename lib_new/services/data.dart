import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/repository.dart';
import '../providers/app_hachlatas.dart';
import '../providers/app_settings.dart';
import '../providers/app_users.dart';
import '../providers/categories.dart';
import '../providers/general.dart';
import '../providers/subscription.dart';
import '../providers/user.dart';
import '../types/dtos/school.dart';
import '../types/dtos/subscription.dart';
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

  // get app settings
  Future<void> getAppSettings() async {
    final settings =
        await repo.getAppSettings(ref.read(userProvider).school?.id ?? 0);
    ref.read(appSettingsProvider.notifier).setAppSettings(settings);
  }

  // get app settings
  Future<void> getCategories() async {
    final categories =
        await repo.getCategories(ref.read(userProvider).school?.id ?? 0);
    ref.read(categoriesProvider.notifier).setCategories(categories);
  }

  // get all hachlatas
  Future<void> getAllHachlatas() async {
    final hachlatas =
        await repo.getAllHachlatas(ref.read(userProvider).school?.id ?? 0);
    ref.read(appHachlatasProvider.notifier).setHachlatas(hachlatas);
  }

  // create a subscription
  Future<void> createSubscription(Subscription subscription) async {
    Subscription newSubscription = await repo.createSubscription(subscription);
    ref.read(subscriptionsProvider.notifier).addSubscription(newSubscription);
  }
}
