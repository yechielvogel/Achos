import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/repository.dart';
import '../providers/app_hachlatas.dart';
import '../providers/app_settings.dart';
import '../providers/app_users.dart';
import '../providers/categories.dart';
import '../providers/completed_hachlatas.dart';
import '../providers/general.dart';
import '../providers/subscription.dart';
import '../providers/user.dart';
import '../types/dtos/categories.dart';
import '../types/dtos/hachlata.dart';
import '../types/dtos/hachlata_completed.dart';
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

  // accept a user
  Future<void> acceptUser(int userId) async {
    await repo.acceptUser(userId);
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

  // create a hachlata
  Future<Category> createCategory(Category category) async {
    Category newCategory = await repo.createCategory(category);
    ref.read(categoriesProvider.notifier).addCategory(newCategory);
    return newCategory;
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

  // create a hachlata
  Future<Hachlata> createHachlata(Hachlata hachlata) async {
    Hachlata newHachlata = await repo.createHachlata(hachlata);
    ref.read(appHachlatasProvider.notifier).addHachlata(newHachlata);
    return newHachlata;
  }

  // get subscriptions for user
  Future<void> getUserSubscriptions(
      int userId, DateTime startDate, DateTime endDate) async {
    final subscriptions =
        await repo.getUserSubscriptions(userId, startDate, endDate);
    await ref
        .read(subscriptionsProvider.notifier)
        .setSubscriptions(subscriptions);
  }

  // complete a hachlata
  Future<void> completeHachlata(HachlataCompleted hachlata) async {
    HachlataCompleted newHachlata = await repo.completeHachlata(hachlata);
    await ref
        .read(completedHachlatasProvider.notifier)
        .addHachlata(newHachlata);
  }

  // get completed hachlatas for user for selected day
  Future<void> getCompletedHachlatas(
      int userId, DateTime startDate, DateTime endDate) async {
    final completedHachlatas =
        await repo.getCompletedHachlatas(userId, startDate, endDate);
    await ref
        .read(completedHachlatasProvider.notifier)
        .setHachlatas(completedHachlatas);
  }
}
